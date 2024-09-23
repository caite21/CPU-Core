`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: cpu_core_tb
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Test register_file by writing to the first and last register
//              then read the registers and assert that the values read are 
//              correct.
// Dependencies: register_file
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_core_tb;
    logic clock;
    logic reset;
    logic [15:0] CPU_out;
    logic [15:0] read_data;
    logic [15:0] r7_data;
    logic [4:0] PC_out;
    logic done;
    
    logic [15:0] correct_r7 [0:15];
    integer i;
    
    cpu_core dut (
        .clock(clock),
        .reset(reset),
        .read_data(read_data),
        .r7_data(r7_data),
        .PC_out(PC_out)
    );
    
    always #5 clock = ~clock;
    
    initial begin
        // Fill expected test results
        correct_r7[0] = 6;
        correct_r7[1] = 1;
        correct_r7[2] = 15;
        correct_r7[3] = 9;
        correct_r7[4] = 3;
        correct_r7[5] = 4;
        correct_r7[6] = 13;
        correct_r7[7] = 9;
        correct_r7[8] = 1;
        correct_r7[9] = 0;
        correct_r7[10] = 6;
        correct_r7[11] = 7;
        correct_r7[12] = 64;
        correct_r7[13] = 16;
        correct_r7[14] = 1;
        correct_r7[15] = 4;
    
        // Start
        clock = 0;
        reset = 1;
        #10;
        reset = 0;
        
        // Fill R0-R6
        #255;
        
        // Test each ALU Function
        for (i = 0; i < 16; i = i + 1) begin
            if (r7_data == correct_r7[i]) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
            assert(r7_data == correct_r7[i]) else $fatal("R7=%d expected=%d PC=%d", r7_data, correct_r7[i], PC_out);
            #40;
        end
        
        #50;
        // No fatal errors
        $display ("*** CPU Core Testbench Passed");
        $finish;
    end
    
endmodule