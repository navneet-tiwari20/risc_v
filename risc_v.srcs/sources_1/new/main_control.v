`timescale 1ns / 1ps

`include "riscv_opcode.vh"
module main_control(
input  [6:0] opcode,
output  reg regwrite , ALUSrc,memread,memwrite,memtoreg,branch,jump );

always@(*)
begin 
regwrite =0;
 ALUSrc =0;
 memread=0;
 memwrite=0;
 memtoreg=0;
 branch=0;
 jump=0;
case(opcode)
`R_type: 
       regwrite = 1;
 `I_type:
         begin
         regwrite = 1;
         ALUSrc = 1;
         end 
 `load: begin
        regwrite = 1;
        memread = 1;
        memtoreg = 1;
        ALUSrc = 1;
        end
 `Store:begin
        memwrite = 1;
        ALUSrc = 1;
        end
        
 `Branch:
         branch = 1;
          
endcase
end
endmodule