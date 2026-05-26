module alu_decoder (
    input  [2:0] funct3,
    input  [6:0] funct7,
    input  [1:0] alu_op,
    input  [4:0] rs2,
    output reg [4:0] alu_control
);
always @(*) begin
    case (alu_op)
        2'b00: alu_control = 5'b00000; // ADD (Load, Store)
        2'b01: begin // Branch instructions
            case (funct3)
                3'b000: alu_control = 5'b01010; // BEQ
                3'b001: alu_control = 5'b01011; // BNE
                3'b100: alu_control = 5'b01100; // BLT
                3'b101: alu_control = 5'b01101; // BGE
                3'b110: alu_control = 5'b01110; // BLTU
                3'b111: alu_control = 5'b01111; // BGEU
                default: alu_control = 5'b00000;
            endcase
        end
        2'b10: begin // R-type
            case ({funct7, funct3})
                10'b0000000_000: alu_control = 5'b00000; // ADD
                10'b0100000_000: alu_control = 5'b00001; // SUB
                10'b0000000_111: alu_control = 5'b00010; // AND
                10'b0000000_110: alu_control = 5'b00011; // OR
                10'b0000000_100: alu_control = 5'b00100; // XOR
                10'b0000000_001: alu_control = 5'b00101; // SLL
                10'b0000000_101: alu_control = 5'b00110; // SRL
                10'b0100000_101: alu_control = 5'b00111; // SRA
                10'b0000000_010: alu_control = 5'b01000; // SLT
                10'b0000000_011: alu_control = 5'b01001; // SLTU
                
                //Bit Instructions
                10'b0100000_111: alu_control = 5'b10000; // ANDN
                10'b0100000_110: alu_control = 5'b10001; // ORN
                10'b0100000_100: alu_control = 5'b10010; // XNOR
                10'b0000101_110: alu_control = 5'b10011; // MAX
                10'b0000101_111: alu_control = 5'b10100; // MAXU
                10'b0000101_100: alu_control = 5'b10101; // MIN
                10'b0000101_101: alu_control = 5'b10110; // MINU
                10'b0110000_101: alu_control = 5'b10111; // ROR
                10'b0110000_001: alu_control = 5'b11011; // ROL
                10'b0000100_100: alu_control = 5'b11100; //PACK
                10'b0000100_111: alu_control = 5'b11101; //PACKH
                default:  alu_control = 5'b00000;
            endcase
        end
        2'b11 : begin // I-type
            case(funct3)
                3'b000: alu_control = 5'b00000; //ADDI
                3'b010: alu_control = 5'b01000; //SLTI
                3'b011: alu_control = 5'b01001; //SLTIU
                3'b100: alu_control = 5'b00100; //XORI
                3'b110: alu_control = 5'b00011; //ORI
                3'b111: alu_control = 5'b00010; //ANDI
                3'b001: begin
                    if(funct7 == 7'b0000000) alu_control = 5'b00101; //SLLI
                    else begin
                        case (rs2)
                            5'b00000: alu_control = 5'b11000; //CLZ
                            5'b00001: alu_control = 5'b11001; //CTZ
                            5'b00010: alu_control = 5'b11010; //CPOP
                            default:  alu_control = 5'b00000;
                        endcase
                    end
                end
                3'b101: begin
                     case(funct7)
                        7'b0000000 : alu_control = 5'b00110; //SRLI
                        7'b0100000 : alu_control = 5'b00111; //SRAI
                        7'b0110000 : alu_control = 5'b10111; //RORI
                        7'b0110100 : begin
                            case(rs2)
                                5'b11000 : alu_control = 5'b11110; //REV8
                                5'b00111 : alu_control = 5'b11111; //BREV8
                                default : alu_control = 5'b00000;
                            endcase
                        end
                        default : alu_control = 5'b00000;
                     endcase
                end
                default: alu_control = 5'b00000; 
            endcase
        end
        default: alu_control = 5'b00000;
    endcase
end
endmodule