`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: clock_divider
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Slows clock. Change divider value to adjust output frequency.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_divider(
    input clock,
    output reg clock_div = 1'b0
    );
    
    reg [3:0] divider = 2;
    reg [3:0] count = 1;
    
    always @ (posedge clock) begin
        if (count < divider)
            count <= count + 1;
        else begin
            clock_div <= ~clock_div;
            count <= 1;
        end
    end
endmodule
