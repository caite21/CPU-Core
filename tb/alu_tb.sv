`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: alu_tb
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Tests each ALU operation.
// 
// Dependencies: alu
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module alu_tb;
    reg [15:0] a;
    reg [15:0] b;
    reg [3:0] sel;
    wire [15:0] out;
    
    alu alu (
        .in0(a),
        .in1(b),
        .select(sel),
        .out(out)
    );

    initial begin
        a = 13;
        b = 4;
        
        sel = 4'b0000;
        #2 assert(out == (a + b)) else $fatal(1, "Unexpected result: sel=%b a=%b b=%b out=%b", sel, a, b, out);

        #5 sel = 4'b0001;
        #2 assert(out == (a - b)) else $fatal(1, "Unexpected result: sel=%b a=%b b=%b out=%b", sel, a, b, out);

        #5 sel = 4'b0010;
        #2 assert(out == (a << b)) else $fatal(1, "Unexpected result: sel=%b a=%b b=%b out=%b", sel, a, b, out);

        #5 sel = 4'b0011;
        #2 assert(out == (a >> b)) else $fatal(1, "Unexpected result: sel=%b a=%b b=%b out=%b", sel, a, b, out);

        #5 sel = 4'b0100;
        #2 assert(out == (a & b)) else $fatal(1, "Unexpected result: sel=%b a=%b b=%b out=%b", sel, a, b, out);

        #5 sel = 4'b0101;
        #2 assert(out == (a | b)) else $fatal(1, "Unexpected result: sel=%b a=%b b=%b out=%b", sel, a, b, out);

        #5 sel = 4'b0110;
        #2 assert(out == (a ^ b)) else $fatal(1, "Unexpected result: sel=%b a=%b b=%b out=%b", sel, a, b, out);

        #5 sel = 4'b0111;
        #2 assert(out == (a - b)) else $fatal(1, "Unexpected result: sel=%b a=%b b=%b out=%b", sel, a, b, out);

        #5 sel = 4'b1000;
        #2 assert(out == b) else $fatal(1, "Unexpected result: sel=%b a=%b b=%b out=%b", sel, a, b, out);

        #5 sel = 4'b1111;
        #2 assert(out == b) else $fatal(1, "Unexpected result: sel=%b a=%b b=%b out=%b", sel, a, b, out);
 
        #5;
        
         // No fatal errors
        $display ("\n--- Testbench Result: %m Passed\n");
        $finish;
    end

endmodule