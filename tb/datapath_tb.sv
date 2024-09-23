`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: datapath_tb
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

module datapath_tb;
    reg clock, reset, rf_write, mem_write, imm_sel;
    reg [2:0] rs_addr, rt_addr, rd_addr;
    reg [15:0] imm_data;
    reg [3:0] alu_sel;
    reg [15:0] mem_data;
    wire [15:0] read_data;
    wire zero_flag, pos_flag;

    datapath dut (
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
    
    reg [15:0] correct_regs [0:7];

    always #5 clock = ~clock;

    initial begin
        // Initialize signals
        clock = 0;
        reset = 1;
        rf_write = 0;
        mem_write = 0;
        rs_addr = 3'b000;
        rt_addr = 3'b000;
        rd_addr = 3'b000;
        imm_data = 16'b00000000;
        alu_sel = 4'b0000;
        imm_sel = 0;
        mem_data = 16'b0;
        
        correct_regs[0] <= 16'd1;
        correct_regs[1] <= 16'd2;
        
        #10 reset = 0;
        #10; 
        
        // Decode: Read rf
        rs_addr = 3'b000; 
        rt_addr = 3'b001; 
        #10;
        
        // Execute: Add registers
        rf_write = 0; 
        alu_sel = 4'b0010;
        #10; 
        
        // Write-Back: Write alu output to rf
        rd_addr = 3'b010; 
        rf_write = 1; 
        imm_sel = 0;
        correct_regs[rd_addr] = 16'd3;
        #10; 
        
        // Execute: Output imm value
        rf_write = 0; 
        imm_data = 15'hFF; 
        imm_sel = 1;
        alu_sel = 4'b0001;
        #10; 
        // alu_out should = FF
        
        // Write-Back: Write imm value to rf
        rd_addr = 3'b011; 
        rf_write = 1; 
        correct_regs[rd_addr] = imm_data;
        #10; 

        // Finish simulation
        #50 $finish;
    end
endmodule


