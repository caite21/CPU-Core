`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: cpu_core_tb
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Tests that the instruction in the program memory execute as 
//              expected. Prints PC and what values are stored in registers
//              and will output "ALL PASS" if cpu core design is correct.
// 
// Dependencies: cpu_core
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module cpu_core_tb;

reg clk;
reg reset;
reg enter;
reg [7:0] user_in;
wire [7:0] CPU_out;
wire [4:0] PC_out;
wire [3:0] OPCODE_out;
wire done;

// expected stored results
reg [7:0] es [0:7];
reg [2:0] es_index = 0;
// expected output results
reg [7:0] os [0:1];
reg [1:0] os_index = 0;

reg [3:0] num_tests = 0;
reg [3:0] pass_count = 0;
    
cpu_core dut (
    .clock(clk),
    .reset(reset),
    .enter(enter),
    .user_in(user_in),
    .CPU_out(CPU_out),
    .PC_out(PC_out),
    .OPCODE_out(OPCODE_out),
    .done(done)
);

always #5 clk = ~clk;

always @(CPU_out) begin
    if (CPU_out !== 8'bz) begin
        if (OPCODE_out == 4'b0100) begin // opcode for store in register
            $display("Time = %0t: Store = %0d, Test = %s", $time, CPU_out, CPU_out == es[es_index] ? "pass" : "FAIL");
            if (CPU_out == es[es_index]) 
                pass_count = pass_count + 1;
            es_index = es_index + 1;
        end else begin
            $display("Time = %0t: Output = %d, Test = %s", $time, CPU_out, CPU_out == os[os_index] ? "pass" : "FAIL");
            if (CPU_out == os[os_index]) 
                pass_count = pass_count + 1;
            os_index = os_index + 1;
        end
    end
end

always @ (posedge done) begin
    if (pass_count == num_tests)
        $display("---- ALL PASS");
    else
        $display("---- FAILURE OCCURED");
end

initial begin
    $display("CPU Core Testbench:");
    es[0] = 4;
    es[1] = 1;
    es[2] = 5;
    es[3] = 6;
    es[4] = 8;
    es[5] = 4;
    es[6] = 3;
    es[7] = 2; 
    os[0] = 1;
    os[1] = 0;
    pass_count = 0;
    num_tests = 10;
    clk = 0;
    reset = 1;
    enter = 1;
    user_in = 8'b00000100;
    #160;
    reset = 0;
    
    $monitor("Time = %0t: PC = %d", $time, PC_out);
    $monitor("Time = %0t: done = %b", $time, done);
    
//    #200;
//    reset = 1;
//    #10 reset = 0;
end

endmodule
