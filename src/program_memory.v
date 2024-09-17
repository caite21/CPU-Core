`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: program_memory
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: program memory contains the 32 8-bit binary instruction to be 
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
    output reg [7:0] data_out
);

    reg [7:0] PM [0:31];
    integer i;
    
    initial begin
        PM[0] = 8'b0001_0000; // load input in acc
        PM[1] = 8'b0100_0001; // store acc in R1         R1=4
        PM[2] = 8'b0010_0000; // load next val into acc
        PM[3] = 8'b0000_0001; // val is 1
        PM[4] = 8'b0100_0000; // store acc in R0         R0=1
        PM[5] = 8'b0101_0001; // acc = acc + R1
        PM[6] = 8'b0100_0010; // store acc in R2         R2=5
        PM[7] = 8'b1001_0000; // increment acc
        PM[8] = 8'b0100_0011; // store acc in R3         R3=6
        PM[9] = 8'b0010_0000; // load next val into acc
        PM[10] = 9;
        PM[11] = 8'b1010_0000; // decrement acc
        PM[12] = 8'b0100_0100; // store acc in R4        R4=8
        PM[13] = 8'b1000_0001; // rotate acc right 1
        PM[14] = 8'b0100_0101; // store acc in R5        R5=4
        PM[15] = 8'b0110_0000; // acc = acc - R0 = 3
        PM[16] = 8'b0100_0110; // store acc in R6        R6=3
        PM[17] = 8'b0010_0000; // load next val into acc
        PM[18] = 8'b0000_1010; // val is 10
        PM[19] = 8'b1011_0110; // acc = acc AND R6 = 1010 AND 0011 = 0010
        PM[20] = 8'b0100_0111; // store acc in R7        R7=2
        PM[21] = 8'b0101_0010; // acc = acc + R2 = 7
        PM[22] = 8'b1100_0011; // 7 < R3 ? = 0
        PM[23] = 8'b1101_0000; // jmp if 0 to line of next val
        PM[24] = 8'b0001_0101; // line 21 (jumps first time, passes second)
        PM[25] = 8'b1110_0000; // output acc = 1
        PM[26] = 8'b1011_0100; // 1 AND R4 = 0001 AND 1000 = 0
        PM[27] = 8'b0111_0111; // if zero, branch forward amount in R7 = jump to 29
        PM[28] = 8'b0001_0000; // load 4 into acc (skipped)
        PM[29] = 8'b1110_0000; // output acc = 0
        
        // Fill rest of PM with 0
        for (i = 30; i < 32; i = i + 1) begin
            PM[i] = 8'b0000_0000; 
        end
    end

    always @(*) begin
        data_out = PM[addr];
    end
endmodule
