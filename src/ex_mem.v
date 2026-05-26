`timescale 1ns / 1ps

module ex_mem(

    input clk,
    input rst,
    input [2:0] funct3_in,
    input [31:0] pc4_in,

    // alu output
    input [31:0] result_in,

    // rs2 value for store instructions
    input [31:0] rs2_in,

    // destination register
    input [4:0] rd_addr_in,

    // control signals
    input mem_w_in,
    input reg_w_in,
    input [1:0] result_src_in,

    output reg [2:0] funct3_out,
    output reg [31:0] pc4_out,

    // alu output
    output reg [31:0] result_out,

    // rs2 value for data memory write
    output reg [31:0] rs2_out,

    // destination register
    output reg [4:0] rd_addr_out,

    // control signals
    output reg mem_w_out,
    output reg reg_w_out,
    output reg [1:0] result_src_out
);

always @(posedge clk) begin

    if(rst) begin
        funct3_out <= 0;
        pc4_out <= 0;
        result_out <= 0;
        rs2_out <= 0;
        rd_addr_out <= 0;
        mem_w_out <= 0;
        reg_w_out <= 0;
        result_src_out <= 0;
    end

    else begin
        funct3_out <= funct3_in;
        pc4_out <= pc4_in;
        result_out <= result_in;
        rs2_out <= rs2_in;
        rd_addr_out <= rd_addr_in;
        mem_w_out <= mem_w_in;
        reg_w_out <= reg_w_in;
        result_src_out <= result_src_in;
    end
end
endmodule