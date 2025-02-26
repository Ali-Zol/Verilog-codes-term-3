module control_unit(opcode, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);

    input [5:0] opcode;
    output reg RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite;
    output reg Branch;
    output reg [1:0] ALUOp;


    always@(*)
    begin
        case(opcode)
            // R-type (add)
            6'b000000:
            begin
                RegDst = 1;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead = 0; 
                MemWrite = 0;
                Branch = 0;
                ALUOp = 2'b10;
            end

            // lw
            6'b100011:
            begin
                RegDst = 0;
                ALUSrc = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead = 1; 
                MemWrite = 0;
                Branch = 0;
                ALUOp = 0;
            end

            // sw
            6'b101011:
            begin
                RegDst = 1'bx;
                ALUSrc = 1;
                MemtoReg = 1'bx;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 1;
                Branch = 0;
                ALUOp = 0;
            end

            // addi
            6'b001000:
            begin
                RegDst = 0;
                ALUSrc = 1;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                ALUOp = 0;
            end

            // bne
            6'b000101:
            begin
                RegDst = 1'bx;
                ALUSrc = 0;
                MemtoReg = 1'bx;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 1;
                ALUOp = 2'b01;
            end

            // Default case (handle invalid opcodes)
            default:
            begin
                RegDst = 0;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                ALUOp = 0;
            end
        endcase
    end
endmodule