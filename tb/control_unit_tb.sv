`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Design Name: 
// Module Name: control_unit_tb
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Asserts controls signals for MOVI R3, #5 in the program memory (#2)
// 
// Dependencies: control_unit
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Revision 2.1 - mux before rf data input; mem_sel instead of data_mem
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit_tb;
    logic clock;
    logic reset;
    logic zero_flag;
    logic pos_flag;
    logic rf_write;
    logic [2:0] rs_addr;
    logic [2:0] rt_addr;
    logic [2:0] rd_addr;
    logic [15:0] imm_data;
    logic [3:0] alu_sel;
    logic imm_sel;
    logic mem_write;
    logic mem_sel;
    logic [dut.PC_WIDTH-1:0] PC;
    
    control_unit dut (
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
        .PC(PC)
    );
    
    
    always #5 clock = ~clock;
    
    
    initial begin
        clock = 0;
        reset = 1;
        zero_flag = 0;
        pos_flag = 0;
        #10;
        reset = 0;
        
        // Wait for PC to reach MOVI R3, #5 instruction
        #50;
        // Fetch and read register file
        assert(PC == 1+1) else $fatal(1, "Expected: PC=%b Recevied PC=%b", 1+1, PC);
        assert(rf_write == 0) else $fatal(1, "Expected: rf_write=%b Recevied rf_write=%b", 0, rf_write);
        #10;
        // Decode
        assert(rd_addr == 3) else $fatal(1, "Expected: rd_addr=%b Recevied rd_addr=%b", 6, rd_addr);
        assert(alu_sel == 4'b1011) else $fatal(1, "Expected: alu_sel=%b Recevied alu_sel=%b", 4'b1011, alu_sel);
        #10;
        // Execute
        #10;
        // Write-Back
        assert(rf_write == 1) else $fatal(1, "Expected: rf_write=%b Recevied rf_write=%b", 1, rf_write);
        #40;
        
        // No fatal errors
        $display ("*** Control Unit Testbench Passed");
        $finish;
    end
endmodule