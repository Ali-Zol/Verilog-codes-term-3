`include "control_unit.v"
`include "forwarding_unit.v"
`include "alu_controller.v"
`include "alu.v"

module mips(clk);

    input clk;

    // IF/ID Register
    reg [31:0] IF_ID_pc = 0, IF_ID_instr = 0, pc = 0;

    // ID/EX Register
    reg [31:0] ID_EX_pc = 0, ID_EX_read_data1 = 0, ID_EX_read_data2 = 0, ID_EX_sign_extend = 0;
    reg [4:0] ID_EX_rs = 0, ID_EX_rt = 0, ID_EX_rd = 0;
    reg ID_EX_RegWrite = 0, ID_EX_MemtoReg = 0, ID_EX_MemRead = 0, ID_EX_MemWrite = 0, ID_EX_ALUSrc = 0, ID_EX_RegDst = 0, ID_EX_Branch = 0;
    reg [1:0] ID_EX_ALUOp = 0;
    
    // EX/MEM Register
    reg [31:0] EX_MEM_alu_result = 0, EX_MEM_read_data2 = 0;
    reg [4:0] EX_MEM_rd = 0;
    reg EX_MEM_RegWrite = 0, EX_MEM_MemtoReg = 0, EX_MEM_MemRead = 0, EX_MEM_MemWrite = 0;

    // MEM/WB Register
    reg [31:0] MEM_WB_alu_result = 0, MEM_WB_read_data = 0;
    reg [4:0] MEM_WB_rd = 0;
    reg MEM_WB_RegWrite = 0, MEM_WB_MemtoReg = 0;


    // IF Stage
    wire branch_taken;
    wire [31:0] branch_target;

    wire stall = (ID_EX_MemRead && (ID_EX_rt == rs || ID_EX_rt == rt));

    always@(posedge clk)
    begin
        if(branch)
        begin
            pc <= branch_target;
            IF_ID_pc <= 0;
            IF_ID_instr <= 0;
        end
        else if(!stall)
        begin
            pc <= pc + 4;
            IF_ID_pc <= pc;
            IF_ID_instr <= instr_mem[pc[9:2]];
        end
        else
        begin
            IF_ID_instr <= IF_ID_instr;
            IF_ID_pc <= IF_ID_pc;
        end
    end


    // ID Stage
    reg [31:0] instr_mem [0:255];

    wire [5:0] opcode = IF_ID_instr[31:26];
    wire [4:0] rs = IF_ID_instr[25:21];
    wire [4:0] rt = IF_ID_instr[20:16];
    wire [4:0] rd = IF_ID_instr[15:11];
    wire [15:0] imm = IF_ID_instr[15:0];

    // Control Unit
    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch;
    wire [1:0] alu_op;
    control_unit controller(opcode, reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op);


    reg [31:0] reg_file [0:31];

    initial
    begin
        for(integer i = 0; i < 32; i = i + 1)
            reg_file[i] = 0;
    end

    wire [31:0] read_data1 = (MEM_WB_RegWrite && (MEM_WB_rd == rs) && (MEM_WB_rd != 0)) ? write_back_data : reg_file[rs];
    wire [31:0] read_data2 = (MEM_WB_RegWrite && (MEM_WB_rd == rt) && (MEM_WB_rd != 0)) ? write_back_data : reg_file[rt];

    wire [31:0] sign_extended_imm = {{16{imm[15]}}, imm};

    // Update ID/EX Register
    always@(posedge clk)
    begin
        if(stall)
        begin
            ID_EX_RegWrite <= 0;
            ID_EX_MemtoReg <= 0;
            ID_EX_MemRead <= 0;
            ID_EX_MemWrite <= 0;
            ID_EX_ALUSrc <= 0;
            ID_EX_RegDst <= 0;
            ID_EX_Branch <= 0;
            ID_EX_ALUOp <= 0;
        end
        else
        begin
            ID_EX_pc <= IF_ID_pc;
            ID_EX_read_data1 <= read_data1;
            ID_EX_read_data2 <= read_data2;
            ID_EX_sign_extend <= sign_extended_imm;
            ID_EX_rs <= rs;
            ID_EX_rt <= rt;
            ID_EX_rd <= rd;
            ID_EX_RegWrite <= reg_write;
            ID_EX_MemtoReg <= mem_to_reg;
            ID_EX_MemRead <= mem_read;
            ID_EX_MemWrite <= mem_write;
            ID_EX_ALUSrc <= alu_src;
            ID_EX_RegDst <= reg_dst;
            ID_EX_Branch <= branch;
            ID_EX_ALUOp <= alu_op;
        end
    end


    // EX Stage
    wire [1:0] forwardA, forwardB;
    forwarding_unit forwarding_unit(EX_MEM_RegWrite, MEM_WB_RegWrite, ID_EX_rs, ID_EX_rt, EX_MEM_rd, MEM_WB_rd, forwardA, forwardB);

    wire [31:0] alu_operandA = (forwardA == 2'b10) ? EX_MEM_alu_result : (forwardA == 2'b01) ? MEM_WB_alu_result : ID_EX_read_data1;
    wire [31:0] alu_operandB = (forwardB == 2'b10) ? EX_MEM_alu_result : (forwardB == 2'b01) ? MEM_WB_alu_result : (ID_EX_ALUSrc) ? ID_EX_sign_extend : ID_EX_read_data2;

    wire [3:0] alu_control;
    alu_controller alu_controller(ID_EX_sign_extend[5:0], ID_EX_ALUOp, alu_control);

    wire [31:0] alu_result;
    wire alu_zero;
    alu alu(alu_operandA, alu_operandB, alu_control, alu_result, alu_zero);

    assign branch_target = (ID_EX_pc + 4) + (sign_extended_imm << 2);
    assign branch_taken = ID_EX_Branch && !alu_zero;

    // Update EX/MEM Register
    always@(posedge clk)
    begin
        EX_MEM_alu_result <= alu_result;
        EX_MEM_read_data2 <= alu_operandB;
        EX_MEM_rd <= (ID_EX_RegDst) ? ID_EX_rd : ID_EX_rt;
        EX_MEM_RegWrite <= ID_EX_RegWrite;
        EX_MEM_MemtoReg <= ID_EX_MemtoReg;
        EX_MEM_MemRead <= ID_EX_MemRead;
        EX_MEM_MemWrite <= ID_EX_MemWrite;
    end


    // MEM Stage
    reg [31:0] data_mem [0:255];
    reg [31:0] mem_read_data;

    always@(posedge clk)
    begin
        if(EX_MEM_MemWrite)
            data_mem[EX_MEM_alu_result >> 2] <= EX_MEM_read_data2;
    end

    always@(*)
    begin
        if(EX_MEM_MemRead)
            mem_read_data = data_mem[EX_MEM_alu_result >> 2];

        else
            mem_read_data = 0;
    end


    // Update MEM/WB Register
    always@(posedge clk)
    begin
        MEM_WB_alu_result <= EX_MEM_alu_result;
        MEM_WB_read_data <= mem_read_data;
        MEM_WB_rd <= EX_MEM_rd;
        MEM_WB_RegWrite <= EX_MEM_RegWrite;
        MEM_WB_MemtoReg <= EX_MEM_MemtoReg;
    end


    // WB Stage
    wire [31:0] write_back_data = (MEM_WB_MemtoReg) ? MEM_WB_read_data : MEM_WB_alu_result;

    always@(posedge clk)
    begin
        if(MEM_WB_RegWrite && MEM_WB_rd != 0)
            reg_file[MEM_WB_rd] <= write_back_data;
    end
endmodule