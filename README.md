# CPU-Core

### Summary
This project implements a simple 16-bit CPU core in Verilog/SystemVerilog, featuring a 5-stage control unit and a datapath that consists of multiplexers, a register file (8 addresses), an ALU, and a main memory (32 addresses).

***Previously was an 8-bit 3-stage CPU Core (v1)***


### Datapath RTL Design
![cpu_core_datapath](https://github.com/caite21/CPU-Core/blob/main/img/cpu_datapath_v2.jpg)


### Elaborated CPU Core Design
Using Xilinx Vivado
![elaborated_cpu](https://github.com/caite21/CPU-Core/blob/main/img/cpu_schematic_v2.png)
![elaborated_datapath](https://github.com/caite21/CPU-Core/blob/main/img/datapath_schematic_v2.png)


### 16-Bit Custom Assembly and Machine Language

3-Inputs: ADD	SUB	MUL	DIV	AND	OR	XOR	LSL	LSR with register or immediate value (ADDI, SUBI, etc.)

| 4-bit opcode | 1-bit imm flag | 3-bit destination register | 3-bit register operand 1 | 5-bit register or imm operand 2 |
|---|---|---|---|---|


2-Inputs: LD, ST, MOV, CMP with register or immediate value

| 4-bit opcode | 1-bit imm flag | 3-bit register or imm operand 1 | 8-bit register or imm operand 2 |
|---|---|---|---|

1-Input: BEQ BLT	BGT	J

| 4-bit opcode | 1-bit imm flag | 11-bit imm value |
|---|---|---|


### v1 Top Testbench
Simulation of cpu_core_tb shows that the controller moves through the fetch, decode, and execute states. Program instructions 13 to 16 involve performing calculations and then storing results in registers 4 and 5. I also output the result with CPU_out for debugging.
![cpu_core_tb_sim1](https://github.com/user-attachments/assets/e33bd5ce-2b19-4e0e-b98a-338dbe66737a)


### Versions
- v1: 8-bit 3-stage CPU with an accumulator for immediate values
- **v2 (Current)**: 16-bit 5-stage CPU, new ISA, no accumulator
- v3: Implement instruction pipelining
- v4: Implement UVM
- v5: Implement instruction-level parallelism 

