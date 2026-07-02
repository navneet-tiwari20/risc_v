`timescale 1ns / 1ps

module pc #(
    parameter WIDTH = 32
)(
    input   clk,
    input   reset,
    input   [WIDTH-1:0]  pc,
    output reg  [WIDTH-1:0]  pc_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc_out <= {WIDTH{1'b0}};
    else
        pc_out <= pc ;
end

endmodule