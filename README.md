# CPU-Core



### Summary
This project implements a simple 16-bit CPU core in Verilog/SystemVerilog, featuring a 5-stage control unit and a datapath that consists of multiplexers, a register file (8 addresses), an ALU, and memory (2048 addresses).

***Previously: 8-bit 3-stage CPU Core***


### Versions
- V1: 8-bit 3-stage CPU with an accumulator for immediate values
- V2 (current): 16-bit 5-stage CPU, new ISA, no accumulator
- V3: Instruction pipelining
- V4: Implement UVM
- V5: Implement instruction-level parallelism 

### Custom Assembly Language and Machine Language

Opcode:

| 4-bit ALU opcode | 1-bit immediate value flag |

16-bit Instructions:

3-Inputs: ADD	SUB	MUL	DIV	AND	OR	XOR	LSL	LSR	LD	ST and each I version (ADDI, SUBI, etc.)

| 5-bit opcode | 3-bit destination register | 3-bit register operand 1 |
3-bit register or immediate operand 2 |

2-Inputs: MOVI	MOV	CMPI	CMP

| 5-bit opcode | 3-bit register or immediate operand 1 | 8-bit register or immediate operand 2 |

1-Input: BEQ	BLT	BGT	J

| 5-bit opcode | 11-bit immediate value |



### V1 Datapath RTL Design
![cpu_core_datapath](https://github.com/user-attachments/assets/c184e7a6-d7f9-404d-b45d-071533afea05)

### V1 Elaborated CPU Core Design
Using Xilinx Vivado
![elaborated_datapath](https://github.com/user-attachments/assets/cbeafbcb-c2d2-4590-b782-5b8e9ce44afb)

### V1 Top Testbench
Simulation of cpu_core_tb shows that the controller moves through the fetch, decode, and execute states. Program instructions 13 to 16 involve performing calculations and then storing results in registers 4 and 5. I also output the result with CPU_out for debugging.
![cpu_core_tb_sim1](https://github.com/user-attachments/assets/e33bd5ce-2b19-4e0e-b98a-338dbe66737a)

