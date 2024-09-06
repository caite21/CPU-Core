`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: accumulator
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: If enabled, pass input to output on rising clock edge. 
//              Asynch reset to 0.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module accumulator(
    input clock,
    input reset,
    input enable,
    input [7:0] in,
    output reg [7:0] out
    );
    
    always @ (posedge clock or posedge reset) begin
        if (reset) 
            out <= 8'b0;
        else if (enable) 
            out <= in;
    end
endmodule
