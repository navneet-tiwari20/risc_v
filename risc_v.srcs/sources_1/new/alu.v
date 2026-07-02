`timescale 1ns / 1ps
`include "alu_opcode.vh"

module alu #(parameter width = 32)
(
    input  [width-1:0] a,
    input  [width-1:0] b,
    input  [3:0] alu_control,

    output reg [width-1:0] result,
    output zero
);

always @(*)
begin
    result = 0;

    case(alu_control)

        `ALU_ADD  : result = a + b;
        `ALU_SUB  : result = a - b;
        `ALU_AND  : result = a & b;
        `ALU_OR   : result = a | b;
        `ALU_XOR  : result = a ^ b;
        `ALU_SLL  : result = a << b[4:0];
        `ALU_SRL  : result = a >> b[4:0];
        `ALU_SRA  : result = $signed(a) >>> b[4:0];
        `ALU_SLT  : result = ($signed(a) < $signed(b)) ? 1 : 0;
        `ALU_SLTU : result = (a < b) ? 1 : 0;

        default : result = 0;

    endcase
end

assign zero = (result == 0);

endmodule