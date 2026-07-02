`timescale 1ns / 1ps


module register_file #(parameter register_width = 32)
( input[4:0] read_addr_1,
 input [4:0]  read_addr_2,
 input [4:0] write_addr,
 input   [register_width-1:0] write_data,
 input regwrite,clk,
 output [register_width-1:0] read_data_1,
 output [register_width-1:0] read_data_2
);
integer i;
initial begin
  for (i = 0; i < 32; i = i + 1)
    register[i] = 0;
end
  reg [register_width-1:0]register[0:31];
  
  assign read_data_1 = (read_addr_1 == 5'd0) ? 0 : register[read_addr_1];
  assign read_data_2 = (read_addr_2 == 5'd0) ? 0 : register[read_addr_2];
  always@(posedge clk)
  begin
  if(regwrite ==1 && write_addr !=0)
   register[write_addr] <= write_data;
  end
  
endmodule
