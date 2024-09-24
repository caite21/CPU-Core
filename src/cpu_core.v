`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: cpu_core
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Top level structural design connecting the control unit and datapath
//              into the cpu core. 
// 
// Dependencies: control_unit, datapath
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Revision 2.1 - mux before rf data input; mem_sel instead of data_mem
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_core(
    input clock,
    input reset,
    output [15:0] read_data,
    output [4:0] PC_out,
    output [15:0] r7_data
    );
    
    wire rf_write;
    wire [2:0] rs_addr;
    wire [2:0] rt_addr;
    wire [2:0] rd_addr;
    wire [15:0] imm_data;
    wire [3:0] alu_sel;
    wire imm_sel;
    wire mem_write;
    wire mem_sel;
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
        .mem_sel(mem_sel),
        .PC(PC_out)
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
        .mem_sel(mem_sel),
        .read_data(read_data),
        .zero_flag(zero_flag),
        .pos_flag(pos_flag),
        .r7_data(r7_data)
    );
endmodule
