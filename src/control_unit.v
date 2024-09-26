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
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit
    #(
        PC_WIDTH = 6
    )(
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
        output reg mem_sel,
        output reg [PC_WIDTH-1:0] PC
    );

    // State Machine
    reg [2:0] next_state;
    localparam [2:0] FETCH = 1, 
                    DECODE = 2, 
                    EXECUTE = 3, 
                    MEMORY = 4, 
                    WRITEBACK = 5, 
                    STOP = 0;
    localparam [4:0] ADD = 4'b0000,
                    SUB = 4'b0001,
                    MUL = 4'b0010,
                    DIV = 4'b0011,
                    AND = 4'b0100,
                    OR = 4'b0101,
                    XOR = 4'b0110,
                    LSL = 4'b0111,
                    LSR = 4'b1000,
                    LD = 4'b1001,
                    ST = 4'b1010,
                    MOV = 4'b1011,
                    CMP = 4'b1100,
                    BEQ = 4'b1101,
                    BxT = 4'b1110, // BLT if imm_sel = 0 BGT if imm_sel = 1
                    J = 4'b1111;

    // For fetching and decoding instruction
    wire [15:0] PM_data;
    program_memory #(
        .ADDR_WIDTH(PC_WIDTH)
    ) PM (
        .addr(PC),
        .data_out(PM_data)
    );
    reg [15:0] instr;
    reg [3:0] opcode;
    reg [10:0] imm_addr;
    integer curr_PC = 0;
    
    
    always @ (posedge clock) begin
        if (PC == (1 << PC_WIDTH) - 1) begin
            next_state <= STOP;
        end
        else if (reset == 1) begin
            PC <= 0;
            instr <= 0;
            opcode <= 0;
            rf_write <= 0;
            rs_addr <= 0;
            rt_addr <= 0;
            rd_addr <= 0;
            imm_data <= 16'b0;
            alu_sel <= 4'b1111;
            mem_write <= 0;
            mem_sel <= 1'b0;
            imm_addr <= 11'b0;
            next_state <= FETCH;
        end
        else begin
            case (next_state)
                FETCH: begin
                        rf_write <= 0; 
                        mem_write <= 0; 
                        instr <= PM_data;
                        curr_PC <= PC;
                        PC <= PC + 1;
                        next_state <= DECODE;
                    end
                DECODE: begin
                        rf_write <= 0; 
                        mem_write <= 0; 
                        mem_sel <= 0;
                        opcode <= instr[15:12];
                        imm_sel <= ~instr[11];
                        if (instr[15:12] <= LSR) begin
                            // 3-input instruction
                            rd_addr <= instr[10:8];
                            rs_addr <= instr[7:5];
                            rt_addr <= instr[4:0];
                            imm_data <= instr[4:0];
                        end
                        else if (instr[15:12] <= CMP) begin
                            // 2-input instruction
                            rd_addr <= instr[10:8];
                            rs_addr <= instr[10:8];
                            rt_addr <= instr[2:0];
                            imm_data <= instr[7:0];
                        end
                        else begin
                            // 1-input instruction
                            imm_addr <= instr[PC_WIDTH-1:0];
                        end
                        next_state <= EXECUTE;
                    end
                EXECUTE: begin
                        rf_write <= 0; 
                        alu_sel <= opcode;
                        if (opcode <= LSR) begin
                            // ALU operations
                            next_state <= WRITEBACK;
                        end
                        else begin
                            case(opcode)
                                LD: begin
                                        mem_sel <= 1;
                                        next_state <= MEMORY;
                                    end
                                ST: begin
                                        next_state <= MEMORY;
                                    end
                                MOV: begin
                                        next_state <= WRITEBACK;
                                    end
                                CMP: begin
                                        next_state <= FETCH;
                                    end
                                BEQ: begin
                                        if (zero_flag == 0) begin
                                            PC <= PC + imm_addr;
                                        end  
                                        next_state <= FETCH;
                                    end
                                BxT: begin
                                        if ((imm_sel && ~pos_flag && ~zero_flag) || (~imm_sel && pos_flag && ~zero_flag)) begin
                                            // branch if opcode is BLT and it is less than and not equal; same for BGT
                                            PC <= PC + imm_addr;
                                        end  
                                        next_state <= FETCH;
                                    end
                                J: begin
                                    PC <= imm_addr;
                                    next_state <= FETCH;
                                end
                                default: begin
                                    rf_write <= 0;
                                    rs_addr <= 0;
                                    rt_addr <= 0;
                                    rd_addr <= 0;
                                    imm_data <= 16'b0;
                                    alu_sel <= 4'b1111;
                                    mem_write <= 0;
                                    mem_sel <= 1'b0;
                                    imm_addr <= 11'b0;
                                    next_state <= FETCH;
                                end
                            endcase
                        end
                    end
                MEMORY: begin
                        rf_write <= 0;
                        case(opcode)
                            LD: begin
                                    mem_write <= 0;
                                    next_state <= WRITEBACK;
                                end
                            ST: begin
                                    mem_write <= 1;
                                    next_state <= FETCH;
                                end
                        endcase
                    end
                WRITEBACK: begin
                        rf_write <= 1;
                        mem_write <= 0; 
                        next_state <= FETCH;
                    end
                default: begin
                        rf_write <= 0; 
                        mem_write <= 0; 
                        instr <= 0;
                        PC <= 0;
                        opcode <= 0;
                    end
            endcase
        end
    end
endmodule
