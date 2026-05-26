`timescale 1ns / 1ps

module id_ex(
    input clk,rst,

    input control_flush,

    input [2:0] funct3_in,

    input [31:0] pc_in,
    input [31:0] pc4_in,

    input [31:0] rd1_in,rd2_in,imm_ext_in,

    input [4:0] rs1_addr_in,rs2_addr_in,rd_addr_in,
    input [4:0] alu_control_in,

    input jump_in,
    input mem_w_in,
    input alu_src_in,
    input reg_w_in,

    input [1:0] result_src_in,

    output reg [2:0] funct3_out,

    output reg [31:0] pc_out,
    output reg [31:0] pc4_out,

    output reg [31:0] rd1_out,rd2_out,imm_ext_out,

    output reg [4:0] rs1_addr_out,rs2_addr_out,rd_addr_out,
    output reg [4:0] alu_control_out,

    output reg jump_out,
    output reg mem_w_out,
    output reg alu_src_out,
    output reg reg_w_out,

    output reg [1:0] result_src_out
);

always @(posedge clk) begin

    if(rst) begin

        funct3_out <= 0;

        pc_out <= 0;
        pc4_out <= 0;

        rd1_out <= 0;
        rd2_out <= 0;
        imm_ext_out <= 0;

        rs1_addr_out <= 0;
        rs2_addr_out <= 0;
        rd_addr_out <= 0;

        alu_control_out <= 0;

        jump_out <= 0;
        mem_w_out <= 0;
        alu_src_out <= 0;
        reg_w_out <= 0;

        result_src_out <= 0;

    end

    else begin

        pc_out <= pc_in;
        pc4_out <= pc4_in;

        rd1_out <= rd1_in;
        rd2_out <= rd2_in;
        imm_ext_out <= imm_ext_in;

        rs1_addr_out <= rs1_addr_in;
        rs2_addr_out <= rs2_addr_in;
        rd_addr_out <= rd_addr_in;

        if(control_flush) begin

            funct3_out <= 0;

            alu_control_out <= 0;

            jump_out <= 0;
            mem_w_out <= 0;
            alu_src_out <= 0;
            reg_w_out <= 0;

            result_src_out <= 0;

        end

        else begin

            funct3_out <= funct3_in;

            alu_control_out <= alu_control_in;

            jump_out <= jump_in;
            mem_w_out <= mem_w_in;
            alu_src_out <= alu_src_in;
            reg_w_out <= reg_w_in;

            result_src_out <= result_src_in;

        end

    end

end

endmodule
