`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: multiplexer
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: 4-to-1 MUX
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiplexer(
    input [7:0] in0,
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [1:0] select,
    output reg [7:0] out
    );
    
    always @ (*) begin 
        case (select)
            2'b00: out <= in0;
            2'b01: out <= in1;
            2'b10: out <= in2;
            2'b11: out <= in3;
            default: out <= 8'bx;
        endcase
    end
endmodule
