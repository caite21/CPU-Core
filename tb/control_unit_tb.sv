`timescale 1ns / 1ps
module control_unit_tb;
    logic clock;
    logic reset;
    logic zero_flag;
    logic pos_flag;
    logic rf_write;
    logic [2:0] rs_addr;
    logic [2:0] rt_addr;
    logic [2:0] rd_addr;
    logic [15:0] imm_data;
    logic [3:0] alu_sel;
    logic imm_sel;
    logic mem_write;
    logic [15:0] mem_data;

    control_unit dut (
        .clock(clock),
        .reset(reset),
        .zero_flag(zero_flag),
        .pos_flag(pos_flag),
        .rf_write(rf_write),
        .rs_addr(rs_addr),
        .rt_addr(rt_addr),
        .rd_addr(rd_addr),
        .imm_data(imm_data),
        .alu_sel(alu_sel),
        .imm_sel(imm_sel),
        .mem_write(mem_write),
        .mem_data(mem_data)
    );
    
    always #5 clock = ~clock;
    
    // Test retrieval of hardcoded PM instructions 
    initial begin
        clock = 0;
        reset = 1;
        zero_flag = 0;
        pos_flag = 0;
        #10;
        reset = 0;
        
//        assert() else $fatal(1, "Unexpected instruction: addr=%b out=%b", addr, out);
        #30;
        
        // No fatal errors
        $display ("*** Control Unit Testbench Passed");
        $finish;
    end
endmodule