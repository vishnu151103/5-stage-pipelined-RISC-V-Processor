`timescale 1ns / 1ps

module mem_wb(
    input clk,
    input rst,

    input [31:0] pc4_in,

    // data memory output
    input [31:0] data_out_in,

    // alu result
    input [31:0] result_in,

    // destination register
    input [4:0] rd_addr_in,

    // control signals
    input reg_w_in,
    input [1:0] result_src_in,

    output reg [31:0] pc4_out,

    // data memory output
    output reg [31:0] data_out_out,

    // alu result
    output reg [31:0] result_out,

    // destination register
    output reg [4:0] rd_addr_out,

    // control signals
    output reg reg_w_out,
    output reg [1:0] result_src_out
);

always @(posedge clk) begin

    if(rst) begin

        pc4_out <= 0;

        data_out_out <= 0;
        result_out <= 0;

        rd_addr_out <= 0;

        reg_w_out <= 0;
        result_src_out <= 0;

    end

    else begin

        pc4_out <= pc4_in;

        data_out_out <= data_out_in;
        result_out <= result_in;

        rd_addr_out <= rd_addr_in;

        reg_w_out <= reg_w_in;
        result_src_out <= result_src_in;

    end

end

endmodule

