`timescale 1ns / 1ps

module risc_top_tb;

reg clk;
reg reset;

risc_top dut(
    .clk(clk),
    .reset(reset)
);

// Clock Generation
always #5 clk = ~clk;

initial
begin
    clk = 0;
    reset = 1;

    #20;
    reset = 0;

    #200;

    $finish;
end

endmodule