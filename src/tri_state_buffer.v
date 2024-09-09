`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
//  
// Module Name: tri_state_buffer
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Input passed to output when enabled, else high impedance.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tri_state_buffer(
    input [7:0] in,
    input enable,
    output [7:0] out
    );
    
    assign out = (enable ? in : 8'bz);
endmodule
