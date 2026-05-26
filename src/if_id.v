`timescale 1ns / 1ps

module if_id(
    input clk,rst,
    input ifid_write,
    input flush,

    input [31:0] pc_in,inst_in,pc4_in,

    output reg [31:0] pc_out,inst_out,pc4_out
);

always @(posedge clk) begin

    if(rst || flush) begin

        pc_out <= 32'd0;
        pc4_out <= 32'd0;
        inst_out <= 32'h00000013;

    end

    else if(ifid_write) begin

        pc_out <= pc_in;
        inst_out <= inst_in;
        pc4_out <= pc4_in;

    end

end

endmodule
