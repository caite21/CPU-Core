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
    logic [15:0] CPU_out;
    logic [15:0] read_data;
    logic [15:0] r7_data;
    logic [dut.PC_WIDTH-1:0] PC_out;
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
        
        // PM 0-4: fills R2-R6
        #255;
        
        // PM 5-20: Test each ALU Operation stored the correct value in R7 (ADD to LSR)
        assert(PC_out == 5+2) else $error("Sim timing is incorrect: PC=%d expected PC=%d", PC_out, 5+2);
        for (i = 0; i < 16; i = i + 1) begin
            if (r7_data == correct_r7[i]) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
            assert(r7_data == correct_r7[i]) else $fatal("Test %d: R7=%d expected=%d PC=%d", i, r7_data, correct_r7[i], PC_out);
            #40;
        end
        
        // PM 21-24: Test CMP and Branch Operations
        assert(PC_out == 21+2) else $error("Sim timing is incorrect: PC=%d expected PC=%d", PC_out, 21+2);
        #40;
        // Branch skipped setting R7 to #1; R7 stays #4
        if (r7_data == 4) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 4) else $fatal("Did not branch over: R7=%d expected=%d PC=%d", r7_data, 4, PC_out);
        #40;
        // Branch landed on setting R7 to #2
        if (r7_data == 2) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 2) else $fatal("Did not branch to: R7=%d expected=%d PC=%d", r7_data, 2, PC_out);
        #80;
        
        // Test LD and ST
        if (r7_data == 8) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 8) else $fatal("Load incorrect: R7=%d expected=%d PC=%d", r7_data, 8, PC_out);
        #80;
        if (r7_data == 5) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 5) else $fatal("Load I incorrect: R7=%d expected=%d PC=%d", r7_data, 5, PC_out);

        // Test BLT and BGT
        #160;
        if (r7_data == 5) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 5) else $fatal("BxT incorrect: R7=%d expected=%d PC=%d", r7_data, 5, PC_out);
        #40;
        if (r7_data == 2) $display("Pass: R7=%d PC=%d", r7_data, PC_out);
        assert(r7_data == 2) else $fatal("BxT incorrect: R7=%d expected=%d PC=%d", r7_data, 2, PC_out);
        
        #40;
        // No fatal errors
        $display ("*** CPU Core Testbench Passed");
        $finish;
    end
    
endmodule