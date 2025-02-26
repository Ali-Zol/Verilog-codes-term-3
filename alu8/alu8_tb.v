`timescale 1ns/1ns
`include "alu8.v"

module alu8_tb;

    reg [7:0] a, b;
    reg [2:0] op;
    wire [7:0] z;
    wire cout, ov, sign;

    alu8 uut(a, b, op, z, cout, ov, sign);

    initial begin
        
        $dumpfile("alu8_tb.vcd");
        $dumpvars(0, alu8_tb);

        a = 8'd100;
        b = 8'd124;

        op = 3'b000;

        #20;

        op = 3'b001;

        #20;

        op = 3'b010;

        #20;

        op = 3'b011;

        #20;

        op = 3'b100;

        #20;

        op = 3'b101;

        #20;

        op = 3'b110;

        #20;

        op = 3'b111;

        #20;


        a = 8'd110;
        b = 8'd200;

        op = 3'b000;

        #20;

        op = 3'b001;

        #20;

        op = 3'b010;

        #20;

        op = 3'b011;

        #20;

        op = 3'b100;

        #20;

        op = 3'b101;

        #20;

        op = 3'b110;

        #20;

        op = 3'b111;

        #20;

    end
    
endmodule