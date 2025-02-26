module forwarding_unit(EX_MEM_RegWrite, MEM_WB_RegWrite, ID_EX_rs, ID_EX_rt, EX_MEM_rd, MEM_WB_rd, forwardA, forwardB);
    
    input EX_MEM_RegWrite, MEM_WB_RegWrite;
    input [4:0] ID_EX_rs, ID_EX_rt, EX_MEM_rd, MEM_WB_rd;
    output reg [1:0] forwardA, forwardB;

    always@(*)
    begin
        forwardA = 0;

        if(EX_MEM_RegWrite && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rs)
            forwardA = 2'b10;

        else if(MEM_WB_RegWrite && MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rs)
            forwardA = 2'b01;


        forwardB = 2'b00;

        if(EX_MEM_RegWrite && EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rt)
            forwardB = 2'b10;

        else if(MEM_WB_RegWrite && MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rt)
            forwardB = 2'b01;
    end
endmodule