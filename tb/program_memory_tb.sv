`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: program_memory_tb
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Tests that 3 instructions are received correctly.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module program_memory_tb;
    logic [4:0] addr;
    logic [15:0] out;

    program_memory dut (addr, out);
    
    // Test retrieval of hardcoded PM instructions 
    initial begin
        // Test: first instruction
        addr = 0;
        #1;
        assert(out == 16'b00001_010_000_00001) else $fatal(1, "Unexpected instruction: addr=%b out=%b", addr, out);
        #4;
        
        // Test: middle instruction
        addr = 1;
        #1;
        assert(out == 16'b00001_011_001_00010) else $fatal(1, "Unexpected instruction: addr=%b out=%b", addr, out);
        #4;
        
        // Test: last (empty) instruction
        addr = 31;
        #1;
        assert(out == 16'b0) else $fatal(1, "Unexpected instruction: addr=%b out=%b", addr, out);
        #4;
        
        // No fatal errors
        $display ("*** Program Memory Testbench Passed");
        $finish;
    end
endmodule