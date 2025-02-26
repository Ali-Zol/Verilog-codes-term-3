`timescale 1ns/1ns
`include "ram.v"

module ram_tb();
    reg [7:0] in;
    reg [6:0] addr;
    reg rst, en, we, clk = 0;
    wire [7:0] out;

    ram uut(in, addr, rst, en, we, clk, out);

    always begin
        #5;
        clk = ~clk;
    end

    initial begin

        $dumpfile("ram_tb.vcd");
        $dumpvars(0, ram_tb);

        rst = 1;
        en = 0;
        we = 0;
        addr = 0;
        in = 0;
        #10;

        rst = 0;
        #10;

        en = 1;
        we = 1;
        addr = 7'd2;
        in = 8'd55;
        #10;

        addr = 7'd5;
        in = 8'd14;
        #10;

        addr = 7'd19;
        in = 8'd42;
        #10;

        we = 0;
        addr = 7'd5;
        #10;

        addr = 7'd2;
        #10;

        en = 0;
        addr = 7'd19;
        #10;

        rst = 1;
        #10;

        $finish;
    end
endmodule