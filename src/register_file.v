`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: register_file
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: 8 16-bit registers. Enable write to write to the register at the address, 
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
    input write,
    input [2:0] rs_addr,
    input [2:0] rt_addr,
    input [2:0] rd_addr,
    input [15:0] data,
    output reg [15:0] rs_data,
    output reg [15:0] rt_data
    );
    
    reg [15:0] registers [0:7];
    
    initial begin
        registers[0] <= 16'd1;
        registers[1] <= 16'd2;
    end
    
    always @ (posedge clock) begin
        if (write) 
            registers[rd_addr] <= data;
        else begin
            rs_data <= registers[rs_addr];
            rt_data <= registers[rt_addr];
        end
    end
endmodule
