`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: multiplexer
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: 2-to-1 MUX
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_2to1 (
    input [15:0] in0,
    input [15:0] in1,
    input sel,
    output reg [15:0] out
    );
    
    // Combinational logic
    always @ (*) begin 
        case (sel)
            1'b0: out = in0;
            1'b1: out = in1;
        endcase
    end
endmodule
