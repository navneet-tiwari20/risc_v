`timescale 1ns / 1ps

module risc_top(
input clk,reset);
wire [31:0]pc,pc_next;
wire[31:0] instruction,immediate_value;
wire [6:0] opcode;
wire [4:0] rd;
wire [2:0] funct3;
wire [4:0] rs1;
wire [4:0] rs2;
wire [6:0] funct7;
wire [3:0] alu_control;
wire [31:0] read_data_1;
wire [31:0] read_data_2,read_data_b;
wire [31:0] alu_result;
wire [31:0] write_data;
wire [31:0] memory_data;
wire zero;
wire [31:0] branch_target;
wire pc_src;
wire regwrite , ALUSrc,memread,memwrite,memtoreg,branch,jump ;

assign branch_target = pc + immediate_value;
assign pc_src = branch & zero;
assign pc_next = (pc_src) ? branch_target : (pc + 32'd4);
//assign pc_next = pc+32'd4;

pc #(.WIDTH(32))
pc_inst
(   .clk(clk),
    .reset(reset),
    .pc(pc_next),
    .pc_out(pc)
);
inst_mem#(.bit_width(32), .mem_width(256))
inst_mem_inst
(
    .pc_out(pc),
    .instruction(instruction)
 );
 instruction_field_extractor#( .instruction_width(32))
 instruction_field_extractor_inst
 (
    .instruction(instruction),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
  );
 immediate_generator#( .inst_width(32))
 immediate_generator_inst
 ( .instruction(instruction),
   .immediate_value(immediate_value)
 );
 main_control
 main_control_inst
 ( .opcode(opcode),
   .regwrite(regwrite), .ALUSrc(ALUSrc),
   .memread(memread), .memwrite(memwrite),
   .memtoreg(memtoreg), .branch(branch),
   .jump(jump)
 );
 alu_control 
 alu_control_inst
 ( .opcode(opcode),
   .funct3(funct3),
   .funct7(funct7),
   .alu_control(alu_control)
 );
 register_file#(.register_width(32))
 register_file_inst
 ( .read_addr_1(rs1),
   .read_addr_2(rs2),
   .write_addr(rd),
   .write_data(write_data),
   .regwrite(regwrite),
   .clk(clk),
   .read_data_1(read_data_1),
   .read_data_2(read_data_2)
 );   
 assign read_data_b = (ALUSrc) ? immediate_value:read_data_2;
 alu#( .width(32))
 alu_inst
 ( .a(read_data_1),
   .b(read_data_b),
   .alu_control(alu_control),
   .result(alu_result),
   .zero(zero)
 );
 data_memory#( .addr_width(32), .addr_depth(256))
data_memory_inst
(
    .address(alu_result),
    .write_data(read_data_2),
    .memread(memread),
    .memwrite(memwrite),
    .clk(clk),
    .read_data(memory_data)
);
assign write_data = (memtoreg) ? memory_data : alu_result;
endmodule

