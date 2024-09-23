`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: program_memory
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: program memory contains the 32 16-bit binary instruction to be 
//              executed by the CPU.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module program_memory (
    input wire [4:0] addr,
    output reg [15:0] data_out
);

    reg [15:0] PM [0:31];
    integer i;
    
    initial begin
        PM[0] = 16'b00010_010_000_00001; // ADD R2, R0, R1      R2=3
        PM[1] = 16'b00010_011_001_00010; // ADD R3, R1, R2      R3=5
        PM[2] = 16'b00001_100_011_00100; // ADDI R4, R3, #4     R4=9
        PM[3] = 16'b11000_101_00000100; // MOV R5, R4           R5=9
        PM[4] = 16'b10111_110_00000001; // MOVI R6, #1          R6=1
        
//        PM[0] = 16'b00101_000_00010000; // MOVI R0, #1         R0=1
//        PM[1] = 16'b00111_001_00000000; // MOV R1, R0          R1=1
//        PM[2] = 16'b10100_010_000_00001; // ADD R2, R0, R1      R2=2
//        PM[3] = 16'b0000_0000_0000_0000; // LSLI R3, R0, #3     R3=8
//        PM[4] = 16'b0000_0000_0000_0000; // OR R4, R3, R2       R4=10
//        PM[5] = 16'b0000_0000_0000_0000; // ANDI R5, R4, #15    R5=10
//        PM[6] = 16'b0000_0000_0000_0000; // CMP R4, R5
//        PM[7] = 16'b0000_0000_0000_0000; // BEQ #1              true
//        PM[8] = 16'b0000_0000_0000_0000; // MOVI R0, #7         skipped; R0 not=7
//        PM[9] = 16'b0000_0000_0000_0000; // CMP R2, R3          
//        PM[10] = 16'b0000_0000_0000_0000; // BLT #2             true
//        PM[11] = 16'b0000_0000_0000_0000; // MOVI R0, #6        skipped; R0 not=6
//        PM[12] = 16'b0000_0000_0000_0000; // MOVI R0, #5        skipped; R0 not=5
//        PM[13] = 16'b0000_0000_0000_0000; // MOVI R0, #4        R0=4
        
        // Fill rest of PM with 0
        for (i = 5; i < 32; i = i + 1) begin
            PM[i] = 16'b0000_0000_0000_0000;
        end
    end

    always @(*) begin
        data_out = PM[addr];
    end
endmodule
