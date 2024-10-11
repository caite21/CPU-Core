`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Caite Sklar
// 
// Module Name: register_file_tb
// Project Name: CPU-Core
// Target Devices: 
// Tool Versions: 
// Description: Test register_file by writing to the first and last register
//              then read the registers and assert that the values read are 
//              correct.
// Dependencies: register_file
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - 8-bit width
// Revision 2.0 - 16-bit width
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file_tb;
    reg clock;
    reg write;
    reg [2:0] rs_addr;
    reg [2:0] rt_addr;
    reg [2:0] rd_addr;
    reg [15:0] data;
    wire [15:0] rs_data;
    wire [15:0] rt_data;

    register_file RF (
        .clock(clock),
        .write(write),
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
        .data(data),
        .rs_data(rs_data),
        .rt_data(rt_data)
    );
    
    // test variables
    reg [2:0] addr1 = 0;
    reg [2:0] addr2 = 7;
    reg [15:0] data1 = 1;
    reg [15:0] data2 = 8'hAB;
    
    always #5 clock = ~clock;
    
    initial begin
        clock = 0;
        
        // write data1
        write = 1;
        rd_addr = addr1;
        rs_addr = addr1;
        data = data1;
        #10;
        
        // write data2
        rd_addr = addr2;
        rt_addr = addr2;
        data = data2;
        #5;
        
        // read registers
        #5 write = 0;
        #10;
        assert(rs_data == data1) else $fatal(1, "Test 1: Fail");
        assert(rt_data == data2) else $fatal(1, "Test 2: Fail");
        #10;
        
        // No fatal errors
        $display ("*** Register File Testbench Passed");
        $finish;
    end
endmodule