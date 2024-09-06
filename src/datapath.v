`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: datapath
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
    input clock,
    input reset,
    input [1:0] mux_select,
    input [7:0] imm_data,
    input [7:0] user_in,
    input acc_enable,
    input [2:0] rf_address,
    input rf_write,
    input [3:0] alu_select,
    input [1:0] alu_rotate,
    input output_enable,
    output [7:0] datapath_out,
    output zero_flag_out,
    output positive_flag_out,
    output [7:0] branch_address_out
    );
    
    wire [7:0] acc_in;
    wire [7:0] acc_out;
    wire [7:0] alu_in;
    wire [7:0] alu_out;
    
    multiplexer mux (
        .in0(alu_out),
        .in1(alu_in),
        .in2(imm_data),
        .in3(user_in),
        .select(mux_select),
        .out(acc_in)
    );
    
    accumulator acc (
        .clock(clock),
        .reset(reset),
        .enable(acc_enable),
        .in(acc_in),
        .out(acc_out)
    );
    
    register_file rf (
        .clock(clock),
        .address(rf_address),
        .write(rf_write),
        .in(acc_out),
        .out(alu_in)
    );
    
    alu alu (
        .in0(acc_out),
        .in1(alu_in),
        .select(alu_select),
        .rotate(alu_rotate),
        .out(alu_out)
    );
    
    tri_state_buffer tsbuffer (
        .in(acc_out),
        .enable(output_enable),
        .out(datapath_out)
    );
    
    assign zero_flag_out = ~( |acc_in );  // reduction OR: |array
    assign positive_flag_out = ~acc_in[7];
    assign branch_address_out = alu_out;
endmodule
