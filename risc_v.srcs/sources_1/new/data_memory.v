`timescale 1ns / 1ps


module data_memory#( parameter addr_width = 32, parameter addr_depth = 256)(
input [addr_width-1:0] address, write_data,
input memread , memwrite , clk,
output reg  [addr_width-1:0] read_data);
reg [addr_width-1:0]data[0:addr_depth-1];
always@(posedge clk)
       begin
       if (memwrite)
      data[address[addr_width-1:2]] <= write_data;
       end
       always @(*) begin
    if(memread)
        read_data = data[address[addr_width-1:2]];
    else
        read_data = 0;
end
endmodule
