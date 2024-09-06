`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input clock,
    input reset,
    input enter,
    inout [7:0] imm_data,
    input [7:0] branch_address,
    input positive_flag,
    input zero_flag,
    output [1:0] mux_select,
    output acc_enable,
    output rf_write,
    output [2:0] rf_address,
    output [0:0] alu_select,
    output output_enable,
    output [4:0] PC,
    output [1:0] alu_rotate,
    output [3:0] OPCODE,
    output done
    );
endmodule
