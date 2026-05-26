module extend(
input [31:0]inst,
input [1:0]imm_src,
output reg [31:0]imm_ext);
always@(*)begin
    case(imm_src)
        2'b00 : begin
            if(inst[14:12]==3'b001 || inst[14:12]==3'b101)
                imm_ext = {27'b0, inst[24:20]}; // Shamt
            else
                imm_ext = {{20{inst[31]}}, inst[31:20]}; // Imm
        end
        2'b01 : begin
            if(inst[6:0]==7'b0100011)
                imm_ext = {{20{inst[31]}}, inst[31:25], inst[11:7]}; // Store
            else
                imm_ext = {{20{inst[31]}}, inst[31:20]}; // Load
        end
        2'b10 : imm_ext = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}; // Branch
        2'b11: begin
            if (inst[6:0] == 7'b1101111) // JAL
                imm_ext = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
            else // LUI
                imm_ext = {inst[31:12], 12'b0};
        end
        default: imm_ext = 32'b0;
    endcase
end
endmodule