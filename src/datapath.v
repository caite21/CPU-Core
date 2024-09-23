`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: datapath
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Structural design connecting a multiplexer, register 
//              file, arithmetic logic unit. 
// 
// Dependencies: mux_2to1, register_file, alu
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
    input clock,
    input reset,
    input rf_write,
    input [2:0] rs_addr,
    input [2:0] rt_addr,
    input [2:0] rd_addr,
    input [15:0] imm_data,
    input [3:0] alu_sel,
    input imm_sel,
    input mem_write,
    input [15:0] mem_data,
    output [15:0] r7_data,
    output [15:0] read_data,
    output zero_flag,
    output pos_flag
    );
    
    wire [15:0] rs_data; // connects rf and alu
    wire [15:0] rt_data; // connects rf and alu
    wire [15:0] alu_in1; // connects rf and alu
    wire [15:0] alu_out; // connects alu to mem and rf data
    
    mux_2to1 imm_mux_alu (
        .in0(rt_data),
        .in1(imm_data),
        .sel(imm_sel),
        .out(alu_in1)
    );
    
    register_file rf (
        .clock(clock),
        .write(rf_write),
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
        .data(alu_out),
        .rs_data(rs_data),
        .rt_data(rt_data),
        .r7_data(r7_data)
    );
    
    alu alu (
        .in0(rs_data),
        .in1(alu_in1),
        .select(alu_sel),
        .out(alu_out)
    );
    
    // todo
//    memory mem (
//        .addr(alu_out),
//        .write_data(mem_data),
//        .write(mem_write),
//        .read_data(read_data)
//    );
    
    // todo
    assign read_data = 0;
    assign zero_flag = ~( |alu_out );  // reduction OR: |array
    assign pos_flag = ~alu_out[15];
endmodule
