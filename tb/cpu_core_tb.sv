`timescale 1ns / 1ps

module cpu_core_tb;
    logic clock;
    logic reset;
    logic [15:0] CPU_out;
    logic [15:0] read_data;
    logic [4:0] PC_out;
    logic [4:0] opcode_out;
    logic done;
    
    cpu_core dut (
        .clock(clock),
        .reset(reset),
        .read_data(read_data),
        .PC_out(PC_out),
        .opcode_out(opcode_out)
    );
    
    always #5 clock = ~clock;
    
    initial begin
        clock = 0;
        reset = 1;
        #10;
        reset = 0;
        #300;
        $finish;
    end
    
endmodule