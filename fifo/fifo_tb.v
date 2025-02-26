`timescale 1ns/1ns
`include "fifo.v"

module fifo_tb;

    reg [7:0] in;
    reg rst, rd_en, wr_en, clk = 0;
    wire empty, full;
    wire [7:0] out;

    fifo uut(in, rst, rd_en, wr_en, clk, empty, full, out);

    always begin
        #5;
        clk = ~clk;
    end

    initial begin
        
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, fifo_tb);

        wr_en = 0;
        rd_en = 0;
        in = 0;

        #10;

        rst = 1;

        #10;

        rst = 0;

        #10;

        wr_en = 1;
        in = 8'd1;     #10;
        in = 8'd2;     #10;
        in = 8'd3;     #10;


        wr_en = 0;
        rd_en = 1;

        #10;
        #10;


        rd_en = 0;

        #10;

        rst = 1;

        #10;

        $finish;
    end    
endmodule