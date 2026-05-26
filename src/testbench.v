//testbench

`timescale 1ns / 1ps

module datapath_tb; 

    reg clk,rst;
    datapath dut (clk,rst); 
    always #5 clk = ~clk;
    initial begin
        clk=0;
        rst=1;
        #10 rst=0;
        #500;
        $display(" x1 = %0h\n x2 = %0h\n x3 = %0h\n x4 = %0h\n x5 = %0h\n x6 = %0h\n x7 = %0h\n x8 = %0h\n x9 = %0h\n x10 = %0h\n x11 = %0h\n x12 = %0h\n x13 = %0h\n x14 = %0h",
        dut.rg.reg_array[1],
        dut.rg.reg_array[2],
        dut.rg.reg_array[3],
        dut.rg.reg_array[4],
        dut.rg.reg_array[5],
        dut.rg.reg_array[6],
        dut.rg.reg_array[7],
        dut.rg.reg_array[8],
        dut.rg.reg_array[9],
        dut.rg.reg_array[10],
        dut.rg.reg_array[11],
        dut.rg.reg_array[12],
        dut.rg.reg_array[13],
        dut.rg.reg_array[14]);
        $finish;
    end
    
endmodule