`include "main.v"

module fibo_tb();

    reg clk;
    mips uut(clk);

    always #5 clk = ~clk;

    initial
    begin
        uut.data_mem[0] = 32'd0;   // Fib[0] = 0
        uut.data_mem[1] = 32'd1;   // Fib[1] = 1

        $dumpfile("fibo_tb.vcd");
        $dumpvars(0, fibo_tb);

        clk = 0;

        $readmemb("fibo.bin", uut.instr_mem);
        
        #1000;

        $display("Data Memory Contents:");

        for(integer i = 0; i <= 11; i = i + 1)
            $display("Address %d: %d", i*4, uut.data_mem[i]);

        $finish;
    end
endmodule