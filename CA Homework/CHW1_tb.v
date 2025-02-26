`timescale 1ns/1ns
`include "CHW1.v"

module CHW1_tb;

    reg [3:0] addr1, addr2;
    reg clk = 0;
    wire [7:0] result;

    top uut(addr1, addr2, clk, result);

    always begin
        #10;
        clk = ~clk;
    end

    initial begin

        $dumpfile("CHW1_tb.vcd");
        $dumpvars(0, CHW1_tb);

        #40;

        addr2 = 4'h0; #20;
        addr2 = 4'h7; #20;
        #40;
        addr1 = 4'h0; #20;


        addr2 = 4'h1; #20;
        addr2 = 4'h6; #20;
        #20;
        addr1 = 4'h1; #20;


        addr2 = 4'h4; #20;
        addr2 = 4'hc; #20;
        addr1 = 4'h2; #20;
        #20;


        addr2 = 4'h2; #20;
        addr2 = 4'hb; #20;
        #40;
        addr1 = 4'h3; #20;


        addr2 = 4'he; #20;
        addr2 = 4'h3; #20;
        #20;
        addr1 = 4'h4; #20;


        addr2 = 4'hd; #20;
        addr2 = 4'h5; #20;
        addr1 = 4'h5; #20;
        #20;


        addr2 = 4'h8; #20;
        addr2 = 4'ha; #20;
        #60;
        addr1 = 4'h6; #20;
        #40;

        $finish;
    end

endmodule