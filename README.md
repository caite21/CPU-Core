# CPU-Core

## Design

This project implements a simple 16-bit CPU core in Verilog/SystemVerilog, featuring a 5-stage control unit and a datapath that consists of multiplexers, a register file (8 addresses), an ALU, and a main memory.

***Previously was an 8-bit 3-stage CPU Core (v1)***


### Datapath RTL Schematic
![cpu_core_datapath](https://github.com/caite21/CPU-Core/blob/main/img/cpu_datapath_v2.jpg)


### Elaborated CPU Core Schematic
Using Xilinx Vivado
![elaborated_cpu](https://github.com/caite21/CPU-Core/blob/main/img/cpu_schematic_v2.png)
![elaborated_datapath](https://github.com/caite21/CPU-Core/blob/main/img/datapath_schematic_v2.png)


### 16-Bit Custom Assembly and Machine Language

3-Inputs: ADD	SUB	MUL	DIV	AND	OR	XOR	LSL	LSR with register or immediate value (ADDI, SUBI, etc.)

| 4-bit opcode | 1-bit imm flag | 3-bit destination register | 3-bit register operand 1 | 5-bit imm or reg operand 2 |
|---|---|---|---|---|


2-Inputs: LD, ST, MOV, CMP with register or immediate value

| 4-bit opcode | 1-bit imm flag | 3-bit register operand 1 | 8-bit imm or reg operand 2 |
|---|---|---|---|

1-Input: BEQ BLT	BGT	J

| 4-bit opcode | 1-bit imm flag | 11-bit imm value |
|---|---|---|

<br>

## Simulation
The simulation demonstrates the operation of the control unit as it executes instructions through the following stages: fetch, decode, execute, memory access, and write-back.

In the simulation depicted below:

- The first set of instructions consists of arithmetic and logical operations, which store their results in register 7.
- Following these operations, a branch instruction is executed, which skips one instruction.
- Finally, the simulation showcases load and store commands interacting with the main memory.

### Waveform
![cpu_core_tb_sim](https://github.com/caite21/CPU-Core/blob/main/img/cpu_core_tb_sim.png?raw=true)

### Program

Where R2= 3, R3= 5, R4= 9, R5= 9, and R6= 8

| PC | Machine Instruction  | Assembly Instruction   |  Description  | Result         |
|---------|--------------------------|-------------------------|-------------|---------------------|
| PM[17]  | `0111_1_111_110_00010`    | LSL R7, R6, R2         | R7 = R6 << R2  | R7 = 64    |
| PM[18]  | `0111_0_111_110_00001`    | LSLI R7, R6, #1        | R7 = R6 << 1  | R7 = 16     |
| PM[19]  | `1000_1_111_110_00010`    | LSR R7, R6, R2         | R7 = R6 >> R2 | R7 = 1     |
| PM[20]  | `1000_0_111_110_00001`    | LSRI R7, R6, #1        |  R7 = R6 >> 1 | R7 = 4   |
| PM[21]  | `1100_1_100_00000101`    | CMP R4, R5              | Compare R4 and R5 | Are equal    |
| PM[22]  | `1101_0_00000000001`      | BEQ #1                 | Branch 1 if equal  | Skip 1 instruction   |
| PM[23]  | `1011_0_111_00000001`      | MOVI R7, #1           | Move 1 into R7 | Is skipped: R7 = 4   |
| PM[24]  | `1011_0_111_00000010`      | MOVI R7, #2           | Move 2 into R7 | R7 = 2    | 
| PM[25]  | `1010_1_110_00000011`      | ST R6, [R3]           |  Store #8 at mem 5   | Stored in mem |
| PM[26]  | `1001_1_111_00000011`      | LD R7, [R3]           |  Load mem 5 into R7     | R7=8 |
| PM[27]  | `1010_0_011_00001010`      | STI R3, [#10]         |  Store #5 at mem 10  | Stored in mem |
| PM[28]  | `1001_0_111_00001010`      | LDI R7, [#10]         |   Load mem 10 into R7     | R7=5 |

<br>

## Versions
- v1: 8-bit 3-stage CPU with an accumulator for immediate values
- **v2 (Current)**: 16-bit 5-stage CPU, new ISA, no accumulator
- v3: Implement instruction pipelining
- v4: Implement UVM
- v5: Implement instruction-level parallelism 

