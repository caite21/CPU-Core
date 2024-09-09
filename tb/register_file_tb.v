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
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file_tb;
    reg clk;
    reg [2:0] addr;
    reg write;
    reg [7:0] data_store;
    wire [7:0] data_read;

    register_file rf (
        .clock(clk),
        .address(addr),
        .write(write),
        .in(data_store),
        .out(data_read)
    );
    
    // test variables
    reg [2:0] addr1 = 0;
    reg [2:0] addr2 = 7;
    reg [7:0] data1 = 1;
    reg [7:0] data2 = 8'hAB;
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        
        // write to register
        write = 1;
        addr = addr1;
        data_store = data1;
        #5;
        // read register
        #5 write = 0;
        #10 $display("%s", data_read == data1 ? "pass" : "fail");
        
        
        // write to register
        write = 1;
        addr = addr2;
        data_store = data2;
        #5;
        // read register
        #5 write = 0;
        #10 $display("%s", data_read == data2 ? "pass" : "fail");
        
        #25 $finish;
    end
endmodule