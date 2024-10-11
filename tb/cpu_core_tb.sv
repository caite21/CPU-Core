`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: cpu_core_tb
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Assert instructions in program memory execute correctly.
// Dependencies: cpu_core
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
    logic [5:0] PC_out;
    logic [15:0] r7_data;
    
    localparam int correct_r7[0:15] = '{6, 1, 15, 9, 3, 4, 13, 9, 1, 0, 6, 7, 64, 16, 1, 4};
    integer i;
    
    localparam clk_T = 10;
    
    cpu_core dut (
        .clock(clock),
        .reset(reset),
        .PC_out(PC_out),
        .r7_data(r7_data)
    );
    
    always #(clk_T/2) clock = ~clock;
    
    initial begin
        // Reset and delay
        clock = 0;
        reset = 1;
        #(clk_T*10);
        reset = 0;
        #(clk_T); // Start sampling just after clk edge
        
        // PM 0-4: 5 arithemtic instructions each with 4 stages (fills R2-R6)
        #(clk_T*4*5);
        
        assert(PC_out == 5+1) else $error("Sim timing is incorrect: PC=%d expected PC=%d", PC_out, 5+2);
        
        // PM 5-20: Test each instruction stores the correct value in R7 (ADD to LSR)
        for (i = 0; i < 16; i = i + 1) begin
            #(clk_T*4);
            if (r7_data == correct_r7[i]) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
            assert(r7_data == correct_r7[i]) else $error("Test %d: R7=%d expected=%d PC=%d", i, r7_data, correct_r7[i], PC_out);
        end
        
        // PM 21-24: Test CMP and Branch
        assert(PC_out == 21+1) else $error("Sim timing is incorrect: PC=%d expected PC=%d", PC_out, 21+2);

        #(clk_T*3); // CMP is 3 stages
        #(clk_T*3); // B is 3 stages
        
        // MOVI is skipped; R7 stays #4
        if (r7_data == 4) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 4) else $error("Did not branch over: R7=%d expected=%d PC=%d", r7_data, 4, PC_out);

        #(clk_T*4); // MOVI
        if (r7_data == 2) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 2) else $fatal("Did not branch to: R7=%d expected=%d PC=%d", r7_data, 2, PC_out);
        
        
        // PM 25-28: Test ST and LD
        #(clk_T*4 + clk_T*5); // ST, LD
        if (r7_data == 8) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 8) else $fatal("Load incorrect: R7=%d expected=%d PC=%d", r7_data, 8, PC_out);
        
        #(clk_T*4 + clk_T*5); // STI, LDI
        if (r7_data == 5) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 5) else $fatal("Load I incorrect: R7=%d expected=%d PC=%d", r7_data, 5, PC_out);


        // PM 29-34: Test BLT and BGT
        #(clk_T*4 + clk_T*3 + clk_T*3 + clk_T*3); // ADD, CMP, BLT, BGT, skip
        if (r7_data == 5) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 5) else $fatal("BxT incorrect: R7=%d expected=%d PC=%d", r7_data, 5, PC_out);

        #(clk_T*4); // MOVI
        if (r7_data == 2) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 2) else $fatal("BxT incorrect: R7=%d expected=%d PC=%d", r7_data, 2, PC_out);
        
        
        // PM 35-39: Test J
        #(clk_T*4 + clk_T*3 + clk_T*3 + clk_T*3); // SUBI, CMP, BLT, J
        // Jumps back to instruction 30
        #(clk_T*3 + clk_T*3 + clk_T*4); // CMP, BLT, skip, MOVI
        if (r7_data == 1) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 1) else $fatal("J or BGT incorrect: R7=%d expected=%d PC=%d", r7_data, 1, PC_out);
        // Doesn't jump
        #(clk_T*4 + clk_T*4 + clk_T*3 + clk_T*3 + clk_T*3 + clk_T*4); // MOVI, SUBI, CMP, BLT, J, MOVI
        if (r7_data == 3) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 3) else $fatal("J incorrect: R7=%d expected=%d PC=%d", r7_data, 3, PC_out);
        
        #100;
        // No fatal errors
        $display ("*** CPU Core Testbench Passed");
        $finish;
    end
    
endmodule