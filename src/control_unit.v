`timescale 1ns / 1ps

module control_unit (

    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    input [4:0] rs2,

    output jump,
    output mem_w,
    output alu_src,
    output reg_w,

    output [4:0] alu_control,

    output [1:0] imm_src,
    output [1:0] result_src
);

wire [1:0] alu_op;

main_decoder md(
    opcode,
    reg_w,
    mem_w,
    alu_src,
    jump,
    alu_op,
    imm_src,
    result_src
);

alu_decoder ad(
    funct3,
    funct7,
    alu_op,
    rs2,
    alu_control
);

endmodule
