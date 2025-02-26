module alu(operandA, operandB, alu_control, result, zero);

    input [31:0] operandA, operandB;
    input [3:0] alu_control;
    output reg [31:0] result;
    output zero;

    parameter
        ALU_ADD  = 4'b0000,   // Add
        ALU_SUB  = 4'b0001,   // Subtract
        ALU_AND  = 4'b0010,   // Bitwise AND
        ALU_OR   = 4'b0011,   // Bitwise OR
        ALU_XOR  = 4'b0100,   // Bitwise XOR
        ALU_NOR  = 4'b0101,   // Bitwise NOR
        ALU_SLT  = 4'b0110;   // Set Less Than (signed)


    // Compute ALU result
    always@(*)
    begin
        case(alu_control)
            ALU_ADD: result = operandA + operandB;       // ADD
            ALU_SUB: result = operandA - operandB;       // SUB
            ALU_AND: result = operandA & operandB;       // AND
            ALU_OR: result = operandA | operandB;        // OR
            ALU_XOR: result = operandA ^ operandB;       // XOR
            ALU_NOR: result = ~(operandA | operandB);    // NOR
            ALU_SLT: result = ($signed(operandA) < $signed(operandB)) ? 32'd1 : 0;  // SLT
            default: result = 0;                         // Default to 0
        endcase
    end

    assign zero = (result == 0);

endmodule