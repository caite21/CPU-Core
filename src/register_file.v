`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: register_file
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: 8 8-bit registers. Enable write to write to the register at the address, 
//              else will read/output the register at the address.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file(
    input clock,
    input [2:0] address,
    input write,
    input [7:0] in,
    output reg [7:0] out
    );
    
    reg [7:0] registers [0:7];
    
    always @ (posedge clock) begin
        if (write) 
            registers[address] <= in;
        else 
            out <= registers[address];
    end
endmodule
