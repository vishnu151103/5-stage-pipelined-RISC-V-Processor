`timescale 1ns / 1ps

module reg_file(
input clk, rst, wr_en,
input [4:0] rs1_addr, rs2_addr, rd_addr,
input [31:0] write_data,
output [31:0] rd1, rd2
);

reg [31:0] reg_array [31:0];
integer i;
always @(posedge clk) begin
    if (rst) begin
	    for (i=0; i<32; i=i+1) begin
	    	reg_array[i] <= 32'd0;
		end
	end
    else if (wr_en == 1'b1 && rd_addr != 5'd0) begin
        reg_array[rd_addr] <= write_data;
    end
end

assign rd1 = (rs1_addr == 5'd0) ? 32'd0 : ((wr_en) && (rd_addr != 5'd0) &&
        (rd_addr == rs1_addr)) ? write_data : reg_array[rs1_addr];
assign rd2 = (rs2_addr == 5'd0) ? 32'd0 : ((wr_en) && (rd_addr != 5'd0)) && 
        (rd_addr == rs2_addr) ? write_data : reg_array[rs2_addr];

endmodule
