`timescale 1ns / 1ps

module forwarding_unit(

    input [4:0] rs1_ex,
    input [4:0] rs2_ex,

    input [4:0] rd_mem,
    input [4:0] rd_wb,

    input reg_w_mem,
    input reg_w_wb,

    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);

always @(*) begin

    // defaults

    forward_a = 2'b00;
    forward_b = 2'b00;

    // =========================
    // Forward A
    // =========================

    // EX/MEM forwarding has highest priority

    if(reg_w_mem &&
       (rd_mem != 5'b00000) &&
       (rd_mem == rs1_ex)) begin

        forward_a = 2'b10;

    end

    // MEM/WB forwarding

    else if(reg_w_wb &&
            (rd_wb != 5'b00000) &&
            (rd_wb == rs1_ex)) begin

        forward_a = 2'b01;

    end

    // =========================
    // Forward B
    // =========================

    // EX/MEM forwarding has highest priority

    if(reg_w_mem &&
       (rd_mem != 5'b00000) &&
       (rd_mem == rs2_ex)) begin

        forward_b = 2'b10;

    end

    // MEM/WB forwarding

    else if(reg_w_wb &&
            (rd_wb != 5'b00000) &&
            (rd_wb == rs2_ex)) begin

        forward_b = 2'b01;

    end

end

endmodule
