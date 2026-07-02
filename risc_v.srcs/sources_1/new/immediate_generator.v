`timescale 1ns / 1ps

module immediate_generator
#(parameter inst_width = 32)
(
    input [inst_width-1:0] instruction,
    output reg [inst_width-1:0] immediate_value
);

always @(*) begin

    case(instruction[6:0])

    // I-Type (ADDI, LW, JALR)
    7'b0010011,
    7'b0000011,
    7'b1100111:
        immediate_value = {{20{instruction[31]}}, instruction[31:20]};

    // S-Type (SW)
    7'b0100011:
        immediate_value = {{20{instruction[31]}},
                           instruction[31:25],
                           instruction[11:7]};

    // B-Type (BEQ)
    7'b1100011:
        immediate_value = {{19{instruction[31]}},
                           instruction[31],
                           instruction[7],
                           instruction[30:25],
                           instruction[11:8],
                           1'b0};

    // U-Type (LUI, AUIPC)
    7'b0110111,
    7'b0010111:
        immediate_value = {instruction[31:12],12'b0};

    // J-Type (JAL)
    7'b1101111:
        immediate_value = {{11{instruction[31]}},
                           instruction[31],
                           instruction[19:12],
                           instruction[20],
                           instruction[30:21],
                           1'b0};

    default:
        immediate_value = 32'd0;

    endcase

end

endmodule