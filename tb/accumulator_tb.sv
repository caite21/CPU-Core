module accumulator_tb;
    logic clk;
    logic reset;
    logic enable;
    logic [7:0] in;
    logic [7:0] out;
    
    // Test values
    logic [7:0] in1;
    logic [7:0] in2;

    accumulator dut (
        .clock(clk),
        .reset(reset),
        .enable(enable),
        .in(in),
        .out(out)
    );
    
    initial begin 
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Assert enable works
    always @ (posedge clk) begin
        #1; // Delay to allow simulator to process the change
        if (~reset && enable)
            assert(out == in) else $fatal("Out expected in: in=%b en=%b out=%b rst=%b", in, enable, out, reset);
    end
    
    // Assert asynchronous reset works
    always @ (posedge reset) begin
        #1; // Delay to allow simulator to process the change
        assert(out == 8'b0) else $fatal("Out expected 0: in=%b en=%b out=%b rst=%b", in, enable, out, reset);
    end

    // Stimulus
    initial begin
        enable  = 1;
        reset = 0;
        in1 = $urandom_range(8'b0,8'b1111_1111);
        in2 = $urandom_range(8'b0,8'b1111_1111);
        // ensure random in1 and in2 are different
        while (in1 == in2) begin
            in1 = $urandom_range(8'b0,8'b1111_1111);
            in2 = $urandom_range(8'b0,8'b1111_1111);
        end
        
        in = in1;
        #5; // rising clock edge
        // Test 1: enable and not reset
        #1 assert(out == in1) else $fatal("Test 1 Failed: in=%b en=%b out=%b rst=%b", in, enable, out, reset);
        
        #4;
        enable = 0;
        in = in2;
        
        #5; // rising clock edge
        // Test 2: not enable; hold old value
        #1 assert(out == in1) else $fatal("Test 2 Failed: in=%b en=%b out=%b rst=%b", in, enable, out, reset);
        
        #4;
        enable = 1;
        #5; // rising clock edge
        // Test 3: enable; now change to new value
        #1 assert(out == in2) else $fatal("Test 3 Failed: in=%b en=%b out=%b rst=%b", in, enable, out, reset);
                
        #4;
        reset = 1;
        #5; // rising clock edge
        // Test 4: check synchronous reset response
        #1 assert(out == 0) else $fatal("Test 4 Failed: in=%b en=%b out=%b rst=%b", in, enable, out, reset);
        #4;
        
        enable = 0;
        #5; // rising clock edge
        // Test 5: not enable and reset (redundant test); still 0 
        #1 assert(out == 0) else $fatal("Test 5 Failed: in=%b en=%b out=%b rst=%b", in, enable, out, reset);
        #4;
        
        // No fatal errors
        $display ("*** Accumulator Testbench Passed");
        $finish;
    end
endmodule
