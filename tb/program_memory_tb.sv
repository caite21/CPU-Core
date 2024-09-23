`timescale 1ns / 1ps
module program_memory_tb;
    logic [4:0] addr;
    logic [15:0] out;

    program_memory dut (addr, out);
    
    // Test retrieval of hardcoded PM instructions 
    initial begin
        // Test: first instruction
        addr = 0;
        #1;
        assert(out == 16'b00101_000_00010000) else $fatal(1, "Unexpected instruction: addr=%b out=%b", addr, out);
        #4;
        
        // Test: middle instruction
        addr = 1;
        #1;
        assert(out == 16'b00111_001_00000000) else $fatal(1, "Unexpected instruction: addr=%b out=%b", addr, out);
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