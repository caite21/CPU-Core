`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: cpu_core
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


module cpu_core(
    input clock,
    input reset,
    input enter,
    input [7:0] user_in,
    output [7:0] CPU_out,
    output [4:0] PC_out,
    output [3:0] OPCODE_out,
    output done
    );
    
    wire clock_div;
    wire [1:0] mux_select;
    wire [7:0] imm_data;
    wire acc_enable;
    wire [2:0] rf_address;
    wire rf_write;
    wire [3:0] alu_select;
    wire output_enable;
    wire zero_flag;
    wire positive_flag;
    wire [1:0] alu_rotate;
    wire [7:0] branch_address;

    
    control_unit cu (
        .clock(clock),
        .reset(reset),
        .enter(enter),
        .imm_data(imm_data),
        .branch_address(branch_address),
        .positive_flag(positive_flag),
        .zero_flag(zero_flag),
        .mux_select(mux_select),
        .acc_enable(acc_enable),
        .rf_write(rf_write),
        .rf_address(rf_address),
        .alu_select(alu_select),
        .output_enable(output_enable),
        .PC(PC_out),
        .alu_rotate(alu_rotate),
        .OPCODE(OPCODE_out),
        .done(done)
    );
    
    datapath dp (
        .clock(clock),
        .reset(reset),
        .mux_select(mux_select),
        .imm_data(imm_data),
        .user_in(user_in),
        .acc_enable(acc_enable),
        .rf_address(rf_address),
        .rf_write(rf_write),
        .alu_select(alu_select),
        .alu_rotate(alu_rotate),
        .output_enable(output_enable),
        .datapath_out(CPU_out),
        .zero_flag_out(zero_flag),
        .positive_flag_out(positive_flag),
        .branch_address_out(branch_address)
    );

endmodule
