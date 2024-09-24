`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: main_memory
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: 32 addresses for 16-bit data
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module main_memory(
    input clock,
    input write,
    input [4:0] addr,
    input [15:0] write_data,
    output reg [15:0] read_data
    );
    
    reg [15:0] data [31:0];
    
    always @ (posedge clock) begin
        if (write) begin
            data[addr] <= write_data;
        end
        else begin
            read_data <= data[addr];
        end
    end
endmodule
