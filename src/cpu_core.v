`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: cpu_core
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Top level structural design connecting the control unit and datapath
//              into the cpu core with a divided clock siganl. 
// 
// Dependencies: control_unit, datapath, clock_divider
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_core(
    input clock,
    input reset,
    output [15:0] read_data,
    output [4:0] PC_out,
    output [4:0] opcode_out
    );
    
    wire rf_write;
    wire [2:0] rs_addr;
    wire [2:0] rt_addr;
    wire [2:0] rd_addr;
    wire [15:0] imm_data;
    wire [3:0] alu_sel;
    wire imm_sel;
    wire mem_write;
    wire [15:0] mem_data;
    wire zero_flag;
    wire pos_flag;
    
    control_unit CU (
        .clock(clock),
        .reset(reset),
        .zero_flag(zero_flag),
        .pos_flag(pos_flag),
        .rf_write(rf_write),
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
        .imm_data(imm_data),
        .alu_sel(alu_sel),
        .imm_sel(imm_sel),
        .mem_write(mem_write),
        .mem_data(mem_data)
    );
    
    datapath DP (
        .clock(clock),
        .reset(reset),
        .rf_write(rf_write),
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
        .imm_data(imm_data),
        .alu_sel(alu_sel),
        .imm_sel(imm_sel),
        .mem_write(mem_write),
        .mem_data(mem_data),
        .read_data(read_data),
        .zero_flag(zero_flag),
        .pos_flag(pos_flag)
    );
    
    assign PC_out = 0;
    assign opcode_out = 0;
endmodule
