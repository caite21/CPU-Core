//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: alu_tb
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Tests all 7 alu operations.
// 
// Dependencies: alu
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module alu_tb;
    reg [7:0] a;
    reg [7:0] b;
    reg [3:0] sel;
    reg [1:0] num_rotate;
    wire [7:0] out;
    
    alu alu (
        .in0(a),
        .in1(b),
        .select(sel),
        .num_rotate(num_rotate),
        .out(out)
    );
    
    initial begin
        a = 2;
        b = 1;
        num_rotate = 0;
        sel = 0;
        #2 $display("%s", out == a ? "pass" : "fail");
        #5 sel = 1;
        #2 $display("%s", out == (a & b) ? "pass" : "fail");
        #5 sel = 4;
        #2 $display("%s", out == (a + b) ? "pass" : "fail");
        #5 sel = 5;
        #2 $display("%s", out == (a - b) ? "pass" : "fail");
        #5 sel = 6;
        #2 $display("%s", out == (a + 1) ? "pass" : "fail");
        #5 sel = 7;
        #2 $display("%s", out == (a - 1) ? "pass" : "fail");
        
        #2;
        a = 8'b10000001;
        num_rotate = 2;
        #5 sel = 2;  // rot left by 2
        #2 $display("%s", out == 8'b00000110 ? "pass" : "fail");
        #5 sel = 3;  // rot right by 2
        #2 $display("%s", out == 8'b01100000 ? "pass" : "fail");
        
        #5 $finish;
    end

endmodule