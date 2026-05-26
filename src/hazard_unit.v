`timescale 1ns / 1ps

module hazard_unit(

    input [4:0] rs1_id,
    input [4:0] rs2_id,
    input [4:0] rd_ex,
    input [1:0] result_src_ex,
    input pc_src,

    output reg pc_write,
    output reg ifid_write,
    output reg control_flush
);

always @(*) begin

    // default values
    pc_write     = 1'b1;
    ifid_write   = 1'b1;
    control_flush = 1'b0;
    
    if(pc_src) begin
        control_flush = 1'b1;
    end

    // load-use hazard detection
    if((result_src_ex == 2'b01) &&
       (rd_ex != 5'b00000) &&
       (((rd_ex == rs1_id) && (rs1_id != 0)) ||
        ((rd_ex == rs2_id) && (rs2_id != 0)))) begin

        // stall pipeline
        pc_write      = 1'b0;
        ifid_write    = 1'b0;
        // insert bubble into EX stage
        control_flush = 1'b1;
    end
end
endmodule
