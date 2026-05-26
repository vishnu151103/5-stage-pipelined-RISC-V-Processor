module alu (
    input  [31:0] a, b,
    input  [4:0]  alu_control,
    output reg [31:0] result,
    output reg branch
);
always @(*) begin
    result = 32'b0;
    branch = 1'b0;
    case (alu_control)
        5'b00000: result = a + b;                          // ADD
        5'b00001: result = a - b;                          // SUB
        5'b00010: result = a & b;                          // AND
        5'b00011: result = a | b;                          // OR
        5'b00100: result = a ^ b;                          // XOR
        5'b00101: result = a << b[4:0];                    // SLL
        5'b00110: result = a >> b[4:0];                    // SRL
        5'b00111: result = $signed(a) >>> b[4:0];          // SRA
        5'b01000: result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; // SLT
        5'b01001: result = (a < b) ? 32'b1 : 32'b0;        // SLTU
        //Branch
        5'b01010: branch = (a == b);                 // BEQ
        5'b01011: branch = (a != b);                 // BNE
        5'b01100: branch = ($signed(a) < $signed(b)); // BLT
        5'b01101: branch = ($signed(a) >= $signed(b)); // BGE
        5'b01110: branch = (a < b);                  // BLTU
        5'b01111: branch = (a >= b);                 // BGEU
        //Bit manipulation
        5'b10000: result = a & (~b);                  // ANDN
        5'b10001: result = a | (~b);                  // ORN
        5'b10010: result = ~(a ^ b);                  // XNOR
        5'b10011: result = ($signed(a) > $signed(b)) ? a : b; // MAX
        5'b10100: result = (a > b) ? a : b;           // MAXU
        5'b10101: result = ($signed(a) < $signed(b)) ? a : b; // MIN
        5'b10110: result = (a < b) ? a : b;           // MINU
        5'b10111: result = (a >> b[4:0]) | (a << (32 - b[4:0])); // ROR
        5'b11000: result = clz_func(a);               // CLZ
        5'b11001: result = ctz_func(a);               // CTZ
        5'b11010: result = cpop_func(a);              // CPOP
        5'b11011: result = (a << b[4:0]) | (a >> (32 - b[4:0])); // ROL
        5'b11100: result = {b[15:0], a[15:0]}; // PACK
        5'b11101: result = {16'b0, b[7:0], a[7:0]}; // PACKH
        5'b11110: result = {a[7:0], a[15:8], a[23:16], a[31:24]}; // REV8
        5'b11111: result =  brev8(a);//BREV8
        default: result = 32'b0;
    endcase
end

// Count Leading Zeros
function [31:0] clz_func;
    input [31:0] val;
    integer i;
    reg found;
    begin
        clz_func = 32;   // default if val == 0
        found = 0;
        for (i = 31; i >= 0; i = i - 1) begin
            if (!found && val[i]) begin
                clz_func = 31 - i;
                found = 1;
            end
        end
    end
endfunction

// Count Trailing Zeros
function [31:0] ctz_func;
    input [31:0] val;
    integer i;
    reg found;
    begin
        ctz_func = 32;   // default if val == 0
        found = 0;
        for (i = 0; i < 32; i = i + 1) begin
            if (!found && val[i]) begin
                ctz_func = i;
                found = 1;
            end
        end
    end
endfunction

// Population Count
function [31:0] cpop_func;
    input [31:0] val;
    integer i;
    begin
        cpop_func = 0;
        for (i = 0; i < 32; i = i + 1)
            cpop_func = cpop_func + val[i];
    end
endfunction

//BREV8 - Reverses each bit in each byte
function [31:0] brev8;
    input [31:0] rs1;
    reg [7:0] b0, b1, b2, b3;
    begin
    // extract bytes
    b0 = rs1[7:0];
    b1 = rs1[15:8];
    b2 = rs1[23:16];
    b3 = rs1[31:24];

    // reverse bits in each byte
    brev8 = {
        {b3[0], b3[1], b3[2], b3[3], b3[4], b3[5], b3[6], b3[7]},
        {b2[0], b2[1], b2[2], b2[3], b2[4], b2[5], b2[6], b2[7]},
        {b1[0], b1[1], b1[2], b1[3], b1[4], b1[5], b1[6], b1[7]},
        {b0[0], b0[1], b0[2], b0[3], b0[4], b0[5], b0[6], b0[7]}
    };
    end
endfunction

endmodule
