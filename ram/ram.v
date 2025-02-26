module ram(in, addr, rst, en, we, clk, out);

    input [7:0] in;
    input [6:0] addr;
    input rst, en, we, clk;
    output reg [7:0] out;

    reg [7:0] mem [0:127];

    always@(posedge clk)
    begin
        if(rst)
            out <= 0;

        else if(en)
        begin
            if(we)
                mem[addr] <= in;

            else
                out <= mem[addr];
        end
    end

endmodule