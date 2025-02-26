module top(addr1, addr2, clk, result);

    input [3:0] addr1, addr2;
    input clk;
    output [7:0] result;

    wire [7:0] w[4:0];
    
    opcode_rom opcode_rom(addr1, clk, w[0]);
    data_rom data_rom(addr2, clk, w[1]);
    controller controller(w[0], w[1], clk, w[2], w[3], w[4]);
    alu8 alu8(w[2], w[3], w[4], result);
    
endmodule

module opcode_rom(addr, clk, data);

    input [3:0] addr;
    input clk;
    output reg [7:0] data;
    
    always@(negedge clk)
    begin
        case(addr)

            4'h0:   data = 8'h01; 
            4'h1:   data = 8'h05; 
            4'h2:   data = 8'h07; 
            4'h3:   data = 8'h04; 
            4'h4:   data = 8'h02; 
            4'h5:   data = 8'h06; 
            4'h6:   data = 8'h03;

            default:    data = 8'h00;
            
        endcase
    end
endmodule

module data_rom(addr, clk, data);

    input [3:0] addr;
    input clk;
    output reg [7:0] data;

    always@(negedge clk)
    begin
        case(addr)

            4'h0:    data = 8'h26; 
            4'h1:    data = 8'hc7; 
            4'h2:    data = 8'h9c; 
            4'h3:    data = 8'h8c; 
            4'h4:    data = 8'hbc; 
            4'h5:    data = 8'h7e; 
            4'h6:    data = 8'h30;
            4'h7:    data = 8'h78;
            4'h8:    data = 8'h42;
            4'h9:    data = 8'h25;
            4'ha:    data = 8'h1b;
            4'hb:    data = 8'he6;
            4'hc:    data = 8'hc6;
            4'hd:    data = 8'h3e;
            4'he:    data = 8'hf9;

            default:    data = 8'h00;
            
        endcase
    end

endmodule

module controller(data1, data2, clk, alu_input1, alu_input2, opcode);

    input [7:0] data1, data2;
    input clk;
    output reg [7:0] alu_input1 = 8'd0, alu_input2 = 8'd0, opcode = 8'd0;

    reg [7:0] prev_alu_input1 = 8'd0, prev_alu_input2 = 8'd0, prev_opcode = 8'd0;

    always@(posedge clk)
    begin
        if(opcode == 8'd0)
        begin
            if(prev_alu_input1 == 8'd0)
                prev_alu_input1 = data2;

            else if(prev_alu_input2 == 8'd0)
                prev_alu_input2 = data2;

            else if((prev_opcode == 8'd0) & (data1 != 8'd0) & (alu_input1 != prev_alu_input1) & (alu_input2 != prev_alu_input2))
                prev_opcode = data1;

            else if((prev_alu_input1 != 8'd0) & (prev_alu_input2 != 8'd0) & (prev_opcode != 8'd0))
            begin
                alu_input1 = prev_alu_input1;
                alu_input2 = prev_alu_input2;
                opcode = prev_opcode;
            end
            else if((alu_input1 != prev_alu_input1) & (alu_input2 != prev_alu_input2) & (prev_opcode == 8'd0))
            begin
                alu_input1 = prev_alu_input1;
                alu_input2 = prev_alu_input2;
            end
            else if((prev_opcode == 8'd0) & (data1 != 8'd0) & (alu_input1 == prev_alu_input1) & (alu_input2 == prev_alu_input2))
            begin
                prev_opcode = data1;
                opcode = prev_opcode;
            end
        end
        else
        begin
            if((prev_alu_input1 != data2) & (alu_input1 == prev_alu_input1) & (opcode == data1))
                prev_alu_input1 = data2;

            else if((prev_alu_input2 != data2) & (alu_input2 == prev_alu_input2) & (opcode == data1))
                prev_alu_input2 = data2;

            else if((prev_opcode != data1) & (alu_input1 != prev_alu_input1) & (alu_input2 != prev_alu_input2))
                prev_opcode = data1;

            else if((alu_input1 != prev_alu_input1) & (alu_input2 != prev_alu_input2) & (prev_opcode != opcode))
            begin
                alu_input1 = prev_alu_input1;
                alu_input2 = prev_alu_input2;
                opcode = prev_opcode;
            end
            else if((alu_input1 != prev_alu_input1) & (alu_input2 != prev_alu_input2) & (prev_opcode == opcode))
            begin
                alu_input1 = prev_alu_input1;
                alu_input2 = prev_alu_input2;
                opcode = 8'd8;
            end
            else if((opcode == 8'd8) & (prev_opcode != data1))
            begin
                prev_opcode = data1;
                opcode = prev_opcode;
            end
        end
    end
endmodule

module alu8(input1, input2, opcode, result);

    input [7:0] input1, input2;
    input [7:0] opcode;
    output reg [7:0] result = 8'hff;

    always@(opcode)
    begin
        case(opcode)
            
            8'd1:   result = input1 + input2; 
            8'd2:   result = input1 - input2;
            8'd3:   result = input1 & input2; 
            8'd4:   result = input1 | input2;
            8'd5:   result = ~input1;
            8'd6:   result = -input1;
            8'd7:   result = input1 < input2;
        endcase     
    end
endmodule