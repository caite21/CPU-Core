`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Design Name: 
// Module Name: control_unit
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Finite state machine controlling the instruction fetch, decode, and 
//              execution of instruction from the program memory. Also contains 
//              executable instruction definitions. Capable of branching to an 
//              instruction from an immediate value or to a relative location from
//              a value stored in a register.
// 
// Dependencies: program_memory
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit(
    input clock,
    input reset,
    input enter,
    inout wire [7:0] imm_data,
    input wire [7:0] alu_result,
    input positive_flag,
    input zero_flag,
    output reg [1:0] mux_select,
    output reg acc_enable,
    output reg rf_write,
    output reg [2:0] rf_address,
    output reg [3:0] alu_select,
    output reg output_enable,
    output reg [4:0] PC,
    output reg [1:0] alu_num_rotate,
    output reg [3:0] OPCODE,
    output reg done
    );

    // State Machine
    reg [4:0] state = 0;
    localparam [4:0] FETCH = 16, DECODE = 17, EXECUTE=18, B_RELATIVE = 19, STOP=20;
    localparam [3:0] INA=4'b0001, LDA=4'b0011, LDI=4'b0010, STA=4'b0100, 
                    OUTA=4'b1110, ADD=4'b0101, SUB=4'b0110, INC=4'b1001, 
                    DEC=4'b1010, ROTR=4'b1000, AND=4'b1011, SLT=4'b1100, 
                    JZ=4'b1101, BZ=4'b0111, todo=4'b1111;
    reg [7:0] IR;
    reg [7:0] r_imm_data, r_alu_out;
    integer i;
    
    wire [7:0] PM_data;
    program_memory PM (
        .addr(PC),
        .data_out(PM_data)
    );
    
    assign imm_data = r_imm_data;
    
    always @ (posedge clock) begin
        if (reset) begin
            PC <= 32'b0;
            reset_control_signals();
            state <= FETCH;
        end else begin
            case (state)
                FETCH: begin
                        if (PC == 5'b11111)
                            state <= STOP;
                        else begin
                            // load instruction register
                            IR <= PM_data;
                            reset_control_signals();
                            
                            if (enter) begin
                                PC <= PC + 1;
                                output_enable <= 0;
                                state <= DECODE;
                            end else
                                state <= FETCH;
                        end
                    end
                DECODE: begin
//                        state <= IR[7:4];
                        OPCODE <= IR[7:4];
                        mux_select <= 0;
                        // pre-fetch imm data
                        if (PC < 5'b11111)
                            r_imm_data <= PM_data;
                        else
                            r_imm_data <= 0;
                            
                        acc_enable <= 0;
                        // saves 1 cycle
                        rf_address <= IR[2:0];
                        
                        rf_write <= 0;
                        alu_select <= 0;
                        done <= 1'b0;
                        
                        alu_num_rotate <= IR[1:0];
                        state <= EXECUTE;
                    end
                EXECUTE: begin
                    case (OPCODE)
                        INA: begin
                                mux_select <= 2'b11;
                                r_imm_data <= 7'b0;
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0000;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        LDA: begin
                                mux_select <= 2'b01;
                                // r_imm_data pre-fetched
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0000;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        LDI: begin
                                mux_select <= 2'b10;
                                // r_imm_data pre-fetched
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0000;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                PC <= PC + 1;
                                state <= FETCH;
                            end
                        STA: begin
                                mux_select <= 2'b00;
                                r_imm_data <= 7'b0;
                                acc_enable <= 1'b0;
                                rf_write <= 1'b1;
                                alu_select <= 4'b0000;
                                output_enable <= 1'b1;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        OUTA: begin
                            mux_select <= 2'b00;
                                // r_imm_data pre-fetched
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0000;
                                output_enable <= 1'b1;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        ADD: begin
                                mux_select <= 2'b00;
                                // r_imm_data pre-fetched
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0011;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        SUB: begin
                                mux_select <= 2'b00;
                                // r_imm_data pre-fetched
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0100;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        INC: begin
                                mux_select <= 2'b00;
                                // r_imm_data pre-fetched
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0101;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        DEC: begin
                                mux_select <= 2'b00;
                                // r_imm_data pre-fetched
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0110;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        ROTR: begin
                                mux_select <= 2'b00;
                                // r_imm_data pre-fetched
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0111;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        AND: begin
                                mux_select <= 2'b00;
                                // r_imm_data pre-fetched
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0001;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        SLT: begin
                                mux_select <= 2'b00;
                                // r_imm_data
                                acc_enable <= 1'b1;
                                rf_write <= 1'b0;
                                alu_select <= 4'b1000;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                state <= FETCH;
                            end
                        JZ: begin  // absolute branch from immediate value
                                mux_select <= 2'b00;
                                // r_imm_data pre-fetched
                                acc_enable <= 1'b0;
                                rf_write <= 1'b0;
                                alu_select <= 4'b0000;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                
                                if (zero_flag)
                                    PC <= r_imm_data;
                                else
                                    PC <= PC + 1;
                                state <= FETCH;
                            end
                        BZ: begin  // relative branch from reigster value
                                mux_select <= 2'b00;
                                // r_imm_data
                                acc_enable <= 1'b0;
                                rf_write <= 1'b0;
                                alu_select <= 4'b1001;
                                output_enable <= 1'b0;
                                done <= 1'b0;
                                
                                if (zero_flag)
                                    state <= B_RELATIVE;
                                else
                                    state <= FETCH;
                            end
                        default: begin
                                reset_control_signals();
                                done <= 1'b1;
                                state <= STOP;
                            end
                    endcase
                end   
                B_RELATIVE: begin
                        PC <= PC + alu_result - 1;
                        state <= FETCH;
                    end
                STOP: begin
                        reset_control_signals();
                        done <= 1'b1;
                        state <= STOP;
                    end 
            endcase   
        end
    end
    
    task reset_control_signals();
        begin
            mux_select <= 2'b00;
            acc_enable <= 1'b0;
            rf_write <= 1'b0;
            alu_select <= 4'b0000;
            output_enable <= 1'b0;
            done <= 1'b0;
        end
    endtask
endmodule
