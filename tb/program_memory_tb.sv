module program_memory_tb;
    logic [4:0] addr;
    logic [7:0] out;

    program_memory dut (addr, out);
    
    // Test retrieval of hardcoded PM instructions 
    initial begin
        // Test: first instruction
        addr = 0;
        #1;
        assert(out == 8'b0001_0000) else $fatal("Unexpected instruction: addr=%b out=%b", addr, out);
        #4;
        
        // Test: middle instruction
        addr = 8;
        #1;
        assert(out == 8'b0100_0011) else $fatal("Unexpected instruction: addr=%b out=%b", addr, out);
        #4;
        
        // Test: last (empty) instruction
        addr = 31;
        #1;
        assert(out == 8'b0) else $fatal("Unexpected instruction: addr=%b out=%b", addr, out);
        #4;
        
        // No fatal errors
        $display ("*** Program Memory Testbench Passed");
        $finish;
    end
endmodule
