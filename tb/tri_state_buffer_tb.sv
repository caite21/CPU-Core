module tri_state_buffer_tb;
    logic [7:0] in;
    logic enable;
    logic [7:0] out;

    tri_state_buffer dut (in, enable, out);
    
    // Assertions
    always @ (*) begin
        #1; // Delay to allow simulator to process the change
        case(enable)
            1'b0: assert(out === 8'bz) else $fatal("Out expected Z: in=%b en=%b out=%b", in, enable, out);
            1'b1: assert(out == in) else $fatal("Out expected in: in=%b en=%b out=%b", in, enable, out);
        endcase
    end

    // Randomized stimulus generation
    initial begin
        for (int i = 0; i < 10; i++) begin
            // Randomized inputs
            in = $urandom_range(8'b0,8'b1111_1111);
            enable = $urandom_range(1'b0,1'b1);
                   
            // Time between each test
            #10;
        end
        
        // No fatal errors
        $display ("*** Tri-State Buffer Testbench Passed");
        $finish;
    end
endmodule
