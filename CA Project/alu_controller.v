module alu_controller(funct, alu_op, alu_control);

    input [5:0] funct;
    input [1:0] alu_op;
    output reg [3:0] alu_control;


    always@(*)
    begin
        case(alu_op)
            // lw/sw/addi: ALU adds
            2'b00: alu_control = 4'b0000; // ADD

            // bne: ALU subtracts
            2'b01: alu_control = 4'b0001; // SUB

            2'b10:
            begin
                case(funct)
                    6'b100000: alu_control = 4'b0000; // ADD
                    6'b100010: alu_control = 4'b0001; // SUB
                    default: alu_control = 4'b0000; // Default to ADD
                endcase
            end

            default: alu_control = 4'b0000;
        endcase
    end
endmodule