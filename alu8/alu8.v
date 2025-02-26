module alu8(a, b, op, z, cout, ov, sign);

    input [7:0] a, b;
    input [2:0] op;
    output reg [7:0] z = 8'd0;
    output reg cout = 0;
    output reg ov = 0;
    output sign;

    assign sign = z[7];

    always @(*)
    begin

        case(op)
            
            3'b000:

                {cout, z} = a + b;

            3'b001:

                {cout, z} = a - b;

            3'b010:

                z = a & b;

            3'b011:

                z = a | b;

            3'b100:

                z = a ^ b;

            3'b101:

                z = ~a;

            3'b110:

                z = a >> 1;

            3'b111:

                z = a << 1;

            default: 
            
                {cout, z} = 8'd0;

        endcase


        if(op == 3'b000)
        begin
            ov = (a[7] == b[7]) & (z[7] != a[7]);
        end
        else if(op == 3'b001)
        begin
            ov = (a[7] != b[7]) & (z[7] != a[7]);
        end
        else
        begin
            ov = 0;
            cout = 0;
        end

    end
    
endmodule