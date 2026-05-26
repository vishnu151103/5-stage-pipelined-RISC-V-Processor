`timescale 1ns / 1ps

module datapath(
    input clk,
    input rst
);
//====================================================
// Control Signals
//====================================================

wire jump;
wire jump_ex;
wire pc_src;
wire mem_w;
wire alu_src;
wire reg_w;
wire branch;
wire [4:0] alu_control;
wire [1:0] imm_src;
wire [1:0] result_src;

//====================================================
// IF Stage
//====================================================

wire [31:0] pc;
wire [31:0] pc_next;
wire [31:0] inst;
wire [31:0] pc4;

//====================================================
// IF/ID Stage
//====================================================

wire [31:0] pc_id;
wire [31:0] inst_id;
wire [31:0] pc4_id;

//====================================================
// ID Stage
//====================================================

wire [31:0] rd1;
wire [31:0] rd2;
wire [31:0] imm_ext;

//====================================================
// Hazard Signals
//====================================================

wire pc_write;
wire ifid_write;
wire control_flush;

//====================================================
// ID/EX Stage
//====================================================

wire [2:0] funct3_ex;
wire [31:0] pc_ex;
wire [31:0] pc4_ex;
wire [31:0] rd1_ex;
wire [31:0] rd2_ex;
wire [31:0] imm_ext_ex;
wire [4:0] rs1_addr_ex;
wire [4:0] rs2_addr_ex;
wire [4:0] rd_addr_ex;
wire [4:0] alu_control_ex;
wire mem_w_ex;
wire alu_src_ex;
wire reg_w_ex;
wire [1:0] result_src_ex;

//====================================================
// EX Stage
//====================================================

wire [1:0] forward_a;
wire [1:0] forward_b;
wire [31:0] alu_in1;
wire [31:0] forward_b_data;
wire [31:0] alu_in2;
wire [31:0] alu_result;
wire [31:0] pc_target;

//====================================================
// EX/MEM Stage
//====================================================

wire [2:0] funct3_mem;
wire [31:0] pc4_mem;
wire [31:0] alu_result_mem;
wire [31:0] forward_b_data_mem;
wire [4:0] rd_addr_mem;
wire mem_w_mem;
wire reg_w_mem;
wire [1:0] result_src_mem;

//====================================================
// MEM Stage
//====================================================

wire [31:0] rd;

//====================================================
// MEM/WB Stage
//====================================================

wire [31:0] pc4_wb;
wire [31:0] rd_wb;
wire [31:0] alu_result_wb;
wire [4:0] rd_addr_wb;
wire reg_w_wb;
wire [1:0] result_src_wb;

//====================================================
// WB Stage
//====================================================

wire [31:0] result;

assign pc_src = jump_ex | branch;

//====================================================
// Program Counter
//====================================================

program_counter prog_c(
    clk,
    rst,
    pc_write,
    pc_next,
    pc
);

//====================================================
// Instruction Memory
//====================================================
inst_mem in(
    pc[31:2],
    inst
);

//====================================================
// PC + 4
//====================================================
adder ad2(
    pc,
    32'd4,
    pc4
);

//====================================================
// IF/ID Register
//====================================================

if_id ifid(
    clk,
    rst,
    ifid_write,
    pc_src,
    pc,
    inst,
    pc4,
    pc_id,
    inst_id,
    pc4_id
);

//====================================================
// Control Unit
//====================================================

control_unit cu(
    .opcode(inst_id[6:0]),
    .funct3(inst_id[14:12]),
    .funct7(inst_id[31:25]),
    .rs2(inst_id[24:20]),
    .jump(jump),
    .mem_w(mem_w),
    .alu_src(alu_src),
    .reg_w(reg_w),
    .alu_control(alu_control),
    .imm_src(imm_src),
    .result_src(result_src)
);

//====================================================
// Register File
//====================================================

reg_file rg(
    clk,
    rst,
    reg_w_wb,
    inst_id[19:15],
    inst_id[24:20],
    rd_addr_wb,
    result,
    rd1,
    rd2
);

//====================================================
// Immediate Extend
//====================================================
extend e(
    inst_id,
    imm_src,
    imm_ext
);

//====================================================
// Hazard Unit
//====================================================

hazard_unit hu(
    inst_id[19:15],
    inst_id[24:20],
    rd_addr_ex,
    result_src_ex,
    pc_src,
    pc_write,
    ifid_write,
    control_flush
);

//====================================================
// ID/EX Register
//====================================================

id_ex idex(
    clk,
    rst,
    control_flush,
    inst_id[14:12],
    pc_id,
    pc4_id,
    rd1,
    rd2,
    imm_ext,
    inst_id[19:15],
    inst_id[24:20],
    inst_id[11:7],
    alu_control,
    jump,
    mem_w,
    alu_src,
    reg_w,
    result_src,
    funct3_ex,
    pc_ex,
    pc4_ex,
    rd1_ex,
    rd2_ex,
    imm_ext_ex,
    rs1_addr_ex,
    rs2_addr_ex,
    rd_addr_ex,
    alu_control_ex,
    jump_ex,
    mem_w_ex,
    alu_src_ex,
    reg_w_ex,
    result_src_ex
);

//====================================================
// Forwarding Unit
//====================================================

forwarding_unit fu(
    rs1_addr_ex,
    rs2_addr_ex,
    rd_addr_mem,
    rd_addr_wb,
    reg_w_mem,
    reg_w_wb,
    forward_a,
    forward_b
);

//====================================================
// Forwarding Mux A
//====================================================

mux3 fwd_mux_a(
    rd1_ex,
    result,
    alu_result_mem,
    forward_a,
    alu_in1
);

//====================================================
// Forwarding Mux B
//====================================================

mux3 fwd_mux_b(
    rd2_ex,
    result,
    alu_result_mem,
    forward_b,
    forward_b_data
);

//====================================================
// ALU Source Select Mux
//====================================================

mux m1(
    forward_b_data,
    imm_ext_ex,
    alu_src_ex,
    alu_in2
);

//====================================================
// ALU
//====================================================

alu a1(
    alu_in1,
    alu_in2,
    alu_control_ex,
    alu_result,
    branch
);

//====================================================
// Branch Target Adder
//====================================================
adder ad1(
    pc_ex,
    imm_ext_ex,
    pc_target
);

//====================================================
// EX/MEM Register
//====================================================

ex_mem exmem(
    .clk(clk),
    .rst(rst),
    .funct3_in(funct3_ex),
    .pc4_in(pc4_ex),
    .result_in(alu_result),
    .rs2_in(forward_b_data),
    .rd_addr_in(rd_addr_ex),
    .mem_w_in(mem_w_ex),
    .reg_w_in(reg_w_ex),
    .result_src_in(result_src_ex),
    .funct3_out(funct3_mem),
    .pc4_out(pc4_mem),
    .result_out(alu_result_mem),
    .rs2_out(forward_b_data_mem),
    .rd_addr_out(rd_addr_mem),
    .mem_w_out(mem_w_mem),
    .reg_w_out(reg_w_mem),
    .result_src_out(result_src_mem)
);


//====================================================
// Data Memory
//====================================================

data_memory dm(
    clk,
    mem_w_mem,
    funct3_mem,
    alu_result_mem,
    forward_b_data_mem,
    rd
);


//====================================================
// MEM/WB Register
//====================================================

mem_wb memwb(
    clk,
    rst,
    pc4_mem,
    rd,
    alu_result_mem,
    rd_addr_mem,
    reg_w_mem,
    result_src_mem,
    pc4_wb,
    rd_wb,
    alu_result_wb,
    rd_addr_wb,
    reg_w_wb,
    result_src_wb
);

//====================================================
// Writeback Mux
//====================================================

mux3 wb_mux(
    alu_result_wb,
    rd_wb,
    pc4_wb,
    result_src_wb,
    result
);

//====================================================
// Next PC Mux
//====================================================

mux m2(
    pc4,
    pc_target,
    pc_src,
    pc_next
);

endmodule
