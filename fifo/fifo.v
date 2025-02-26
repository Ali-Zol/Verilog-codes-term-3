module fifo(in, rst, rd_en, wr_en, clk, empty, full, out);

    input [7:0] in;
    input rst, rd_en, wr_en, clk;
    output empty, full;
    output reg [7:0] out;


    reg [7:0] mem [0:127];
    reg [6:0] rd_ptr;
    reg [6:0] wr_ptr;
    reg [6:0] count;


    assign full  = (count == 127);
    assign empty = (count == 0);


    always@(posedge clk, posedge rst)
    begin
        if(rst)
        begin
            rd_ptr <= 0;
            wr_ptr <= 0;
            count <= 0;
            out <= 0;
        end
        else if(rd_en && !empty)    //Read operation
        begin
            out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end

        if(wr_en && !full && !rst)  //Write operation
        begin
            mem[wr_ptr] <= in;
            wr_ptr <= wr_ptr + 1;
        end

        if(!rst)
        begin
            case({wr_en && !full, rd_en && !empty})

                2'b10: count <= count + 1;
                2'b01: count <= count - 1;
            endcase
        end
    end

    
endmodule