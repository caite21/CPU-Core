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
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Additional Comments:
//    - Current issue is that BLT and BGT need the ALU to subtract again redundantly
//      to hold the value and also the imm bit needs to be 1 to keep from changing
//      the alu to an imm value
//    - Solution is to make B ops 3 operands
//////////////////////////////////////////////////////////////////////////////////


module program_memory #(
        parameter ADDR_WIDTH = 6
    )(
        input wire [ADDR_WIDTH-1:0] addr,
        output reg [15:0] data_out
    );

    localparam SIZE = 1 << ADDR_WIDTH;
    reg [15:0] PM [0:SIZE-1];
    integer i;
    integer last_instr = 0;
    
    initial begin 
        // Fill R2-R6
        PM[0] = 16'b10100_010_00000011; // MOVI R2, #3          R2=3
        PM[1] = 16'b10100_011_00000101; // MOVI R3, #5          R3=5
        PM[2] = 16'b00000_100_011_00100; // ADDI R4, R3, #4     R4=9
        PM[3] = 16'b10101_101_00000100; // MOV R5, R4           R5=9
        PM[4] = 16'b00001_110_010_00011; // ADD R6, R2, R3      R6=8
        // Do nothing
        PM[5] = 16'hFFFF;
        PM[6] = 16'hFFFF; 
        PM[7] = 16'hFFFF; 
        PM[8] = 16'hFFFF; 
        // Store result of arithemtic/logical instructions in R7
        PM[9] = 16'b00011_111_101_00010; // SUB R7, R5, R2      R7=6
        PM[10] = 16'b00010_111_101_01000; // SUBI R7, R5, #8    R7=1
        PM[11] = 16'b01011_111_110_00011; // OR R7, R6, R3      R7=13
        PM[12] = 16'b01010_111_101_00001; // ORI R7, R5, #1     R7=9
        PM[13] = 16'b01001_111_101_00011; // AND R7, R5, R3     R7=1
        PM[14] = 16'b01000_111_101_00100; // ANDI R7, R5, #4    R7=0
        PM[15] = 16'b01101_111_010_00011; // XOR R7, R2, R3     R7=6
        PM[16] = 16'b01100_111_011_00010; // XORI R7, R3, #2    R7=7
        PM[17] = 16'b00101_111_110_00010; // LSL R7, R6, R2     R7=64
        PM[18] = 16'b00100_111_110_00001; // LSLI R7, R6, #1    R7=16
        PM[19] = 16'b00111_111_110_00010; // LSR R7, R6, R2     R7=1
        PM[20] = 16'b00110_111_110_00001; // LSRI R7, R6, #1    R7=4
        // Compare and branch
        PM[21] = 16'b01111_000_100_00101; // CMP R4, R5         equal
        PM[22] = 16'b10111_00000000001; // BEQ #1               jump over 1 instr
        PM[23] = 16'b10100_111_00000001; // MOVI R7, #1         skip; R7=4
        PM[24] = 16'b10100_111_00000010; // MOVI R7, #2         R7=2
        // Load and store
        PM[25] = 16'b10011_110_00000_011; // ST R6, [R3]        Store #8 at mem 5
        PM[26] = 16'b10001_111_00000_011; // LD R7, [R3]        Load #8 into R7
        PM[27] = 16'b10010_011_00001010; // STI R3, [#10]       Store #5 at mem 10
        PM[28] = 16'b10000_111_00001010; // LDI R7, [#10]       Load #5 into R7
        // Branch less than and greater than
        PM[29] = 16'b00001_000_111_00011; // ADD R0, R7, R3     R0=10
        PM[30] = 16'b01111_000_000_00100; // CMP R0, R4         greater
        PM[31] = 16'b11001_00000000001; // BLT #1               false first time
        PM[32] = 16'b11011_00000000001; // BGT #1               jump over 1 instr
        PM[33] = 16'b10100_111_00000001; // MOVI R7, #1         skip first time; R7=5
        PM[34] = 16'b10100_111_00000010; // MOVI R7, #2         R7=2
        // Jump
        PM[35] = 16'b00010_000_000_00101; // SUBI R0, R0, #5     R0=5
        PM[36] = 16'b01111_000_000_00011; //  CMP R0, R3        (R3=5)
        PM[37] = 16'b11001_00000000001; // BLT #1
        PM[38] = 16'b11100_00000011110; // J #30                jumps back once
        PM[39] = 16'b10100_111_00000011; // MOVI R7, #3         R7=3
        last_instr = 39;

        // Fill rest of PM with 0
        for (i = last_instr+1; i < SIZE; i = i + 1) begin
            PM[i] = 16'hFFFF; 
        end
    end

    always @(*) begin
        data_out = PM[addr];
    end
endmodule
