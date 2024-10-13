`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: datapath_tb
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Tests the instruction MOVI R7, #8 
// 
// Dependencies: datapath
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Revision 2.1 - mux before rf data input; mem_sel instead of data_mem
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module datapath_tb;
    reg clock, rf_write, mem_write, imm_sel, mem_sel;
    reg [2:0] rs_addr, rt_addr, rd_addr;
    reg [15:0] imm_data, r7_data;
    reg [3:0] alu_sel;
    wire zero_flag, pos_flag;

    datapath dut (
        .clock(clock),
        .rf_write(rf_write),
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
        .imm_data(imm_data),
        .alu_sel(alu_sel),
        .imm_sel(imm_sel),
        .mem_write(mem_write),
        .mem_sel(mem_sel),
        .zero_flag(zero_flag),
        .pos_flag(pos_flag),
        .r7_data(r7_data)
    );

    always #5 clock = ~clock;

    initial begin
        // Initialize signals
        clock = 0;
        rf_write = 0;
        mem_write = 0;
        rs_addr = 3'b000;
        rt_addr = 3'b000;
        rd_addr = 3'b000;
        imm_data = 16'b0;
        alu_sel = 4'b0000;
        imm_sel = 0;
        mem_sel = 1'b0;
        #20; 
        
        // Instruction: 16'b10110_111_00001000; // MOVI R7, #8 
        // Decode
        rf_write = 0;
        rs_addr = 8'b00001000; 
        imm_sel = 1;
        imm_data = 16'd5; 
        #10;
        // Execute
        rf_write = 0; 
        alu_sel = 4'b1011;
        #10; 
        // Write-Back
        rd_addr = 3'b111; 
        rf_write = 1; 
        #50; 
        // Test 
        assert(r7_data == 16'd5) else $fatal(1, "Fail");

        #50;
        // No fatal errors
        $display ("\n--- Testbench Result: %m Passed\n");
        $finish;
    end
endmodule


