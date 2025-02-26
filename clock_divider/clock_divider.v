module clock_divider(div_fact, clk_ref, clk_in, rst, clk_out);
    
    input [31:0] div_fact;
    input clk_ref, clk_in, rst;
    output reg clk_out = 0;

    reg [31:0] counter = 32'd0;

    always@(posedge clk_ref, posedge rst)
    begin
        
        if(rst)
        begin
            counter <= 0;
            clk_out <= 0;
        end
        else if(counter >= div_fact - 32'd1)
        begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
        else
            counter <= counter + 32'd1;

    end
endmodule