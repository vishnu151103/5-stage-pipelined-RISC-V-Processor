module main_decoder (
    input  [6:0] opcode,
    output reg reg_w, mem_w, alu_src, jump,
    output reg [1:0] alu_op,
    output reg [1:0] imm_src,result_src
);
always @(*) begin
    reg_w   = 0;
    mem_w   = 0;
    alu_src = 0;
    jump    = 0;
    alu_op  = 2'b00;
    imm_src = 2'b00;
    result_src =2'b00;
    case (opcode)
        7'b0110011: begin // R-type
            reg_w   = 1;
            alu_op  = 2'b10;
        end
        7'b0010011: begin // I-type
            reg_w   = 1;
            alu_src = 1;
            alu_op  = 2'b11;
        end
        7'b0000011: begin // Load
            reg_w   = 1;
            alu_src = 1;
            imm_src = 2'b01;
            result_src =2'b01;
        end
        7'b0100011: begin // Store
            mem_w   = 1;
            alu_src = 1;
            imm_src = 2'b01;
        end
        7'b1100011: begin // Branch
            alu_op  = 2'b01;
            imm_src = 2'b10;
        end
        7'b1101111: begin // Jump
            reg_w   = 1;
            jump    = 1;
            alu_src = 1;
            imm_src = 2'b11;
            result_src =2'b10;
        end
        7'b0110111: begin // LUI
            reg_w   = 1;
            imm_src = 2'b11;
            alu_src = 1;
        end
        default: begin
            reg_w   = 0;
            mem_w   = 0;
            alu_src = 0;
            jump    = 0;
            alu_op  = 2'b00;
            imm_src = 2'b00;
            result_src =2'b00;
        end
    endcase
end
endmodule
