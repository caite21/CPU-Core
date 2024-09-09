`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: alu
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: With 4 select signals and 2 inputs, can perform AND, OR, add,  
//              subtract, increment, decrement, rotate right, set less than, 
//              and output either input
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu(
    input [7:0] in0, // accumulator output
    input [7:0] in1, // register file output
    input [3:0] select,
    input [1:0] num_rotate,
    output reg [7:0] out
    );
    
    parameter [2:0] WIDTH = 8;
    
    always @ (*) begin
        case (select) 
            4'b0000: out <= in0;
            4'b0001: out <= in0 & in1;
            4'b0010: out <= in0 | in1;
            4'b0011: out <= in0 + in1;
            4'b0100: out <= in0 - in1;
            4'b0101: out <= in0 + 1'b1;
            4'b0110: out <= in0 - 1'b1;
            4'b0111: out <= (in0 >> num_rotate) | (in0 << (WIDTH - num_rotate));
            4'b1000: out <= (in0 < in1 ? 8'b1 : 8'b0); 
            4'b1001: out <= in1;
            default: out <= 8'b0;
        endcase
    end
endmodule
