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
    input zero_flag,
    input pos_flag,
    output reg rf_write,
    output reg [2:0] rs_addr,
    output reg [2:0] rt_addr,
    output reg [2:0] rd_addr,
    output reg [15:0] imm_data,
    output reg [3:0] alu_sel,
    output reg imm_sel,
    output reg mem_write,
    output reg [15:0] mem_data
    );

    // State Machine
    localparam [2:0] FETCH = 1, 
                    DECODE = 2, 
                    EXECUTE = 3, 
                    MEMORY = 4, 
                    WRITEBACK = 5, 
                    STOP = 0;
    reg [2:0] state;
    localparam [4:0] ADDI = 5'b00001,
                    ADD = 5'b00010,
                    SUBI = 5'b00011,
                    SUB = 5'b00100,
                    MULI = 5'b00101,
                    MUL = 5'b00110,
                    DIVI = 5'b00111,
                    DIV = 5'b01000,
                    ANDI = 5'b01001,
                    AND = 5'b01010,
                    ORI = 5'b01011,
                    OR = 5'b01100,
                    XORI = 5'b01101,
                    XOR = 5'b01110,
                    LSLI = 5'b01111,
                    LSL = 5'b10000,
                    LSRI = 5'b10001,
                    LSR = 5'b10010,
                    LDI = 5'b10011,
                    LD = 5'b10100,
                    STI = 5'b10101,
                    ST = 5'b10110,
                    MOVI = 5'b10111,
                    MOV = 5'b11000,
                    CMPI = 5'b11001,
                    CMP = 5'b11010,
                    BEQ = 5'b11011,
                    BLT = 5'b11100,
                    BGT = 5'b11101,
                    J = 5'b11110;


    reg [15:0] instr;
    reg [4:0] PC;
    reg [4:0] opcode;
    wire [15:0] PM_data;
    program_memory PM (
        .addr(PC),
        .data_out(PM_data)
    );
    reg [10:0] imm_addr;
    
    
    always @ (posedge clock) begin
        if (PC == 5'b11111) begin
            state <= STOP;
        end
        else if (reset == 1) begin
            PC <= 0;
            state <= FETCH;
        end
        else begin
            case (state)
                FETCH: begin
                        rf_write <= 0; 
                        instr <= PM_data;
                        PC <= PC + 1;
                        state <= DECODE;
                    end
                DECODE: begin
                        rf_write = 0; 
                        opcode = instr[15:11];
                        if (opcode < 5'b10111) begin
                            // 3-input instruction
                            rd_addr <= instr[10:8];
                            rs_addr <= instr[7:5];
                            rt_addr <= instr[4:0];
                            imm_sel <= instr[11];
                            imm_data <= instr[4:0];
                        end
                        else if (opcode < 5'b11011) begin
                            // 2-input instruction
                            rd_addr <= instr[10:8];
                            rs_addr <= instr[7:0];
                            imm_sel <= instr[11];
                            imm_data <= instr[7:0];
                        end
                        else begin
                            // 1-input instruction
                            imm_addr <= instr[10:0];
                        end
                        state <= EXECUTE;
                    end
                EXECUTE: begin
                        case (opcode)
                            MOV: begin             
                                    rf_write <= 0; 
                                    alu_sel <= 4'b0000;
                                    state <= WRITEBACK;
                                end
                            MOVI: begin                  
                                    rf_write <= 0; 
                                    alu_sel <= 4'b0001;
                                    state <= WRITEBACK;
                                end
                            ADD: begin                  
                                    rf_write <= 0; 
                                    alu_sel <= 4'b0010;
                                    state <= WRITEBACK;
                                end
                            ADDI: begin                  
                                    rf_write <= 0; 
                                    alu_sel <= 4'b0010;
                                    state <= WRITEBACK;
                                end
                            default: begin
                                    rf_write <= 0;
                                    rs_addr <= 0;
                                    rt_addr <= 0;
                                    rd_addr <= 0;
                                    imm_data <= 16'b0;
                                    alu_sel <= 4'b0000;
                                    mem_write <= 0;
                                    mem_data <= 16'b0;
                                    imm_addr <= 11'b0;
                                    state <= FETCH;
                                end
                        endcase
                    end
                MEMORY: begin
                        rf_write = 0; 
                        state <= WRITEBACK;
                    end
                WRITEBACK: begin
                        rf_write <= 1; 
                        state <= FETCH;
                    end
                default: begin
                        rf_write <= 0; 
                        instr <= 0;
                        PC <= 0;
                        opcode <= 0;
                    end
            endcase
        end
    end

//    always @ (posedge clock) begin
//        if (reset) begin
//            PC <= 5'b0;
//            state <= FETCH;
//        end 
//    end
endmodule
