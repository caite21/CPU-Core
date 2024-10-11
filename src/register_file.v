`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: register_file
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: 8 16-bit registers. Enable write to write at the address, 
//              else will read/output at the address.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file(
    input clock,
    input reset,
    input write,
    input [2:0] rs_addr,
    input [2:0] rt_addr,
    input [2:0] rd_addr,
    input [15:0] data,
    output reg [15:0] rs_data,
    output reg [15:0] rt_data,
    output [15:0] r7_data
    );
    
    reg [15:0] registers [0:7];
    
    assign r7_data = registers[7];
    
    always @ (posedge clock) begin
        if (reset) begin
            registers[0] <= 0;
            registers[1] <= 0;
            registers[2] <= 0;
            registers[3] <= 0;
            registers[4] <= 0;
            registers[5] <= 0;
            registers[6] <= 0;
            registers[7] <= 0;
        end
        else if (write) begin
            registers[rd_addr] <= data;
        end
        else begin
            rs_data <= registers[rs_addr];
            rt_data <= registers[rt_addr];
        end
    end
endmodule
