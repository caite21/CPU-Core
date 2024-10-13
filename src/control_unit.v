`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Design Name: 
// Module Name: control_unit
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Finite state machine for instruction fetch, decode, execute, 
//              memory access, and write-back. 
// 
// Dependencies: program_memory
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Revision 2.1 - mux before rf data input; mem_sel instead of data_mem
// Revision 2.2 - control unit is connected to separate program memory
// Revision 2.3 - changed opcodes 
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit
    #(
        parameter PC_WIDTH = 6
    )(
        input clock,
        input reset,
        input zero_flag,
        input pos_flag,
        input [15:0] PM_data,
        output reg rf_write,
        output reg [2:0] rs_addr,
        output reg [2:0] rt_addr,
        output reg [2:0] rd_addr,
        output reg [15:0] imm_data,
        output reg [3:0] alu_sel,
        output reg imm_sel,
        output reg mem_write,
        output reg mem_sel,
        output reg [PC_WIDTH-1:0] PC
    );

    reg [15:0] instr;
    reg [3:0] opcode;
    reg [10:0] imm_addr;

    // State Machine
    reg [2:0] next_state;
    localparam [2:0] FETCH = 1, 
                    DECODE = 2, 
                    EXECUTE = 3, 
                    MEMORY = 4, 
                    WRITEBACK = 5, 
                    SET_FLAGS = 6,
                    STOP = 0;
    localparam [4:0] ADD = 4'b0000,
                    SUB = 4'b0001,
                    LSL = 4'b0010,
                    LSR = 4'b0011,
                    AND = 4'b0100,
                    OR = 4'b0101,
                    XOR = 4'b0110,
                    CMP = 4'b0111,
                    LD = 4'b1000,
                    ST = 4'b1001,
                    MOV = 4'b1010,
                    BEQ = 4'b1011,
                    BLT = 4'b1100,
                    BGT = 4'b1101,
                    J = 4'b1110,
                    NOP = 4'b1111;

    reg zero_flag_reg;
    reg pos_flag_reg;
    
    always @ (posedge clock) begin
        if (reset == 1) begin
            PC <= 0;
            next_state <= FETCH;
        end else case (next_state)
            FETCH: begin
                    mem_write <= 0; 
                    instr <= PM_data;
                    PC <= PC + 1;
                    if (PM_data[15:12] == NOP) begin
                        next_state <= FETCH;
                    end else begin
                        next_state <= DECODE;
                    end
                end
            DECODE: begin
                    rf_write <= 0; 
                    mem_write <= 0; 
                    mem_sel <= 0;
                    opcode <= instr[15:12];
                    imm_sel <= ~instr[11];
                    alu_sel <= instr[15:12];
                    if (instr[15] == 0) begin
                        // 3-input instruction and CMP
                        rd_addr <= instr[10:8];
                        rs_addr <= instr[7:5];
                        rt_addr <= instr[2:0];
                        imm_data <= instr[4:0];
                    end else begin
                        // 2-input instruction
                        rd_addr <= instr[10:8];
                        rs_addr <= instr[10:8];
                        rt_addr <= instr[2:0];
                        imm_data <= instr[7:0];
                        imm_addr <= instr[PC_WIDTH-1:0];
                    end
                    next_state <= EXECUTE;
                end
            EXECUTE: case(opcode)
                    LD: begin
                            mem_sel <= 1;
                            next_state <= MEMORY;
                            alu_sel <= opcode;
                        end
                    ST: begin
                            next_state <= MEMORY;
                            alu_sel <= opcode;
                        end
                    CMP: begin
                            alu_sel <= opcode;
                            next_state <= SET_FLAGS;
                        end
                    BEQ: begin
                            if (zero_flag_reg) begin
                                PC <= PC + imm_addr;
                            end  
                            next_state <= FETCH;
                        end
                    BLT: begin
                            if (~pos_flag_reg && ~zero_flag_reg) begin
                                PC <= PC + imm_addr;
                            end  
                            next_state <= FETCH;
                        end
                    BGT: begin
                            if (pos_flag_reg && ~zero_flag_reg) begin
                                PC <= PC + imm_addr;
                            end  
                            next_state <= FETCH;
                        end
                    J: begin
                            PC <= imm_addr;
                            next_state <= FETCH;
                        end
                    default: begin
                            // Arithmetic operations
                            alu_sel <= opcode;
                            next_state <= WRITEBACK;
                        end
                endcase
            MEMORY: begin
                    if (opcode == LD) begin
                        mem_write <= 0;
                        next_state <= WRITEBACK;
                    end else begin // ST
                        mem_write <= 1;
                        next_state <= FETCH;
                    end 
                end
            WRITEBACK: begin
                    rf_write <= 1;
                    mem_write <= 0; 
                    next_state <= FETCH;
                end
            SET_FLAGS: begin
                    pos_flag_reg <= pos_flag;
                    zero_flag_reg <= zero_flag;
                    next_state <= FETCH;
                end
            default: begin
                    rf_write <= 0; 
                    mem_write <= 0; 
                end
        endcase
    end
endmodule

