`timescale 1ns / 1ps

module inst_mem #(parameter bit_width = 32,
parameter mem_width = 256)

(  input [bit_width-1:0] pc_out,
output  [bit_width-1:0] instruction
);
integer i;
reg [bit_width-1:0]mem[0:mem_width-1];

initial begin
    // Initialize entire memory with NOP
    for(i = 0; i < mem_width; i = i + 1)
        mem[i] = 32'h00000013;

    // Overwrite beginning with program
    $readmemh("program.mem", mem);
end



assign instruction = mem[(pc_out[31:2])];

endmodule
