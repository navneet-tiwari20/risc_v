`timescale 1ns / 1ps

`include "alu_opcode.vh"
`include "riscv_opcode.vh"

module alu_control(

    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output reg [3:0] alu_control

);

always @(*)
begin
    alu_control = 0;

case(opcode)

    `R_type:
    begin
        case(funct3)

            3'b000:
            begin
                if(funct7 == 7'b0000000)
                    alu_control = `ALU_ADD;
                else if(funct7 == 7'b0100000)
                    alu_control = `ALU_SUB;
                else
                    alu_control = 0;
            end

            3'b111: alu_control = `ALU_AND;
            3'b110: alu_control = `ALU_OR;
            3'b100: alu_control = `ALU_XOR;
            3'b001: alu_control = `ALU_SLL;

            3'b101:
            begin
                if(funct7 == 7'b0000000)
                    alu_control = `ALU_SRL;
                else if(funct7 == 7'b0100000)
                    alu_control = `ALU_SRA;
                else
                    alu_control = 0;
            end

            3'b010: alu_control = `ALU_SLT;
            3'b011: alu_control = `ALU_SLTU;

            default: alu_control = 0;

        endcase
    end   

    `B_type:
    begin
        alu_control = `ALU_SUB;
    end

    default:
        alu_control = 0;

endcase

end

endmodule