module multiplexer_tb;
    logic [7:0] in0, in1, in2, in3;
    logic [1:0] sel;
    logic [7:0] out;

    multiplexer dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .select(sel),
        .out(out)
    );
    
    // Assertions
    always @ (*) begin
        #1; // Delay to allow simulator to process the change
        case(sel)
            2'b00: assert(out == in0) else $fatal("Output error: expected in0");
            2'b01: assert(out == in1) else $fatal("Output error: expected in1");
            2'b10: assert(out == in2) else $fatal("Output error: expected in2");
            2'b11: assert(out == in3) else $fatal("Output error: expected in3");
        endcase
    end

    // Randomized stimulus generation
    initial begin
        for (int i = 0; i < 20; i++) begin
            // Randomized inputs
            in0 = $urandom_range(8'b0,8'b1111_1111);
            in1 = $urandom_range(8'b0,8'b1111_1111);
            in2 = $urandom_range(8'b0,8'b1111_1111);
            in3 = $urandom_range(8'b0,8'b1111_1111);
            sel = $urandom_range(2'b0,2'b11);
            
            // Time between each test
            #10;
        end
        
        // No fatal errors
        $display ("*** Multiplexer Testbench Passed");
        $finish;
    end
endmodule
