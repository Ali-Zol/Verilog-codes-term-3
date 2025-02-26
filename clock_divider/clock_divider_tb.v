`timescale 1ns/1ns
`include "clock_divider.v"

module clock_divider_tb;

    reg [31:0] div_fact;
    reg clk_ref = 1, clk_in = 0, rst;
    wire clk_out;

    clock_divider uut(div_fact, clk_ref, clk_in, rst, clk_out);

    always begin
        #5;
        clk_ref = ~clk_ref;
        #5;
        clk_in = ~clk_in;
        clk_ref = ~clk_ref;
    end


    initial begin
        
        $dumpfile("clock_divider_tb.vcd");
        $dumpvars(0, clock_divider_tb);

        div_fact = 32'd2;
        rst = 0;

        #80;

        div_fact = 32'd5;

        #150;

        rst = 1;

        #10;

        $finish;

    end 
endmodule