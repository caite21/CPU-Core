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
//              memory access, and write-back. Also contains instruction definitions. 
// 
// Dependencies: program_memory
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
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
    output reg [15:0] mem_data,
    output reg [4:0] PC
    );

    // State Machine
    localparam [2:0] FETCH = 1, 
                    DECODE = 2, 
                    EXECUTE = 3, 
                    MEMORY = 4, 
                    WRITEBACK = 5, 
                    STOP = 0;
    reg [2:0] next_state;
    localparam [4:0] ADDI = 5'b00000,
                    ADD = 5'b00001,
                    SUBI = 5'b00010,
                    SUB = 5'b00011,
                    MULI = 5'b00100,
                    MUL = 5'b00101,
                    DIVI = 5'b00110,
                    DIV = 5'b00111,
                    ANDI = 5'b01000,
                    AND = 5'b01001,
                    ORI = 5'b01010,
                    OR = 5'b01011,
                    XORI = 5'b01100,
                    XOR = 5'b01101,
                    LSLI = 5'b01110,
                    LSL = 5'b01111,
                    LSRI = 5'b10000,
                    LSR = 5'b10001,
                    LDI = 5'b10010,
                    LD = 5'b10011,
                    STI = 5'b10100,
                    ST = 5'b10101,
                    MOVI = 5'b10110,
                    MOV = 5'b10111,
                    CMPI = 5'b11000,
                    CMP = 5'b11001,
                    BEQ = 5'b11010,
                    BLT = 5'b11011,
                    BGT = 5'b11100,
                    J = 5'b11101;

    reg [15:0] instr;
    reg [4:0] opcode;
    wire [15:0] PM_data;
    program_memory PM (
        .addr(PC),
        .data_out(PM_data)
    );
    reg [10:0] imm_addr;
    
    
    always @ (posedge clock) begin
        if (PC == 5'b11111) begin
            next_state <= STOP;
        end
        else if (reset == 1) begin
            PC <= 0;
            next_state <= FETCH;
        end
        else begin
            case (next_state)
                FETCH: begin
                        rf_write <= 0; 
                        instr <= PM_data;
                        PC <= PC + 1;
                        next_state <= DECODE;
                    end
                DECODE: begin
                        rf_write <= 0; 
                        opcode <= instr[15:11];
                        if (instr[15:11] < 5'b10110) begin
                            // 3-input instruction
                            rd_addr <= instr[10:8];
                            rs_addr <= instr[7:5];
                            rt_addr <= instr[4:0];
                            imm_sel <= ~instr[11];
                            imm_data <= instr[4:0];
                        end
                        else if (instr[15:11] < 5'b11010) begin
                            // 2-input instruction
                            rd_addr <= instr[10:8];
                            rs_addr <= instr[7:0];
                            imm_sel <= ~instr[11];
                            imm_data <= instr[7:0];
                        end
                        else begin
                            // 1-input instruction
                            imm_addr <= instr[10:0];
                        end
                        next_state <= EXECUTE;
                    end
                EXECUTE: begin
                        if (opcode < 5'b11000) begin // ADDI to MOV
                            // ALU operations
                            rf_write <= 0; 
                            alu_sel <= opcode[4:1];
                            next_state <= WRITEBACK;
                        end
                        else begin
                            rf_write <= 0;
                            rs_addr <= 0;
                            rt_addr <= 0;
                            rd_addr <= 0;
                            imm_data <= 16'b0;
                            alu_sel <= 4'b1111;
                            mem_write <= 0;
                            mem_data <= 16'b0;
                            imm_addr <= 11'b0;
                            next_state <= FETCH;
                        end
                    end
                MEMORY: begin
                        rf_write = 0; 
                        next_state <= WRITEBACK;
                    end
                WRITEBACK: begin
                        rf_write <= 1; 
                        next_state <= FETCH;
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
endmodule
