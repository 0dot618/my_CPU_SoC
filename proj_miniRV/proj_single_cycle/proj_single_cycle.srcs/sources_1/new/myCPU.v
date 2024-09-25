`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
`ifdef RUN_TRACE
    output wire [15:0]  inst_addr,
`else
    output wire [13:0]  inst_addr,
`endif
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_we,
    output wire [31:0]  Bus_wdata,
    
    output wire [2:0] load_op,
    output wire [1:0] store_op

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // TODO: 完成你自己的单周期CPU设计
    //
    
    reg [31:0] npc_pc;
    reg [31:0] npc_offset;
    reg npc_br;
    wire [1:0] npc_op;
    reg [31:0] npc_npc;
    wire [31:0] npc_pc4;
    reg [31:0] pc_alu;
    wire pc_sel;
//    wire [31:0] irom_inst;
    wire [31:0] pc_pc;
    
    reg [4:0] rf_rR1;
    reg [4:0] rf_rR2;
    reg [4:0] rf_wR;
    reg [31:0] wb_alu;
    reg [31:0] wb_dram;
    reg [31:0] wb_pc4;
    reg [31:0] wb_ext;
    wire [1:0] rf_wsel;
    wire rf_we;
    wire [2:0] sext_op;
    reg [24:0] sext_din;
    wire [31:0] rf_rD1;
    wire [31:0] rf_rD2;
    wire [31:0] sext_ext;
    wire [31:0] wb_value;
    
    reg [31:0] alua_rs1;
    reg [31:0] alua_pc;
    wire alua_sel;
    reg [31:0] alub_rs2;
    reg [31:0] alub_ext;
    wire alub_sel;
    wire [3:0] alu_op;
    wire alu_f;
    wire [31:0] alu_C;
    
    reg clk;
    wire ram_we;
    wire [31:0] mem_rdo;
    wire [31:0] rdata_to_cpu;
    
    wire         rst_to_dram;
    wire         clk_to_dram;
    wire [31:0]  addr_to_dram;
    wire         we_to_dram;
    wire [31:0]  wdata_to_dram;
    
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
//    reg pc_sel;
//    reg [1:0] npc_op;
//    reg rf_we;
//    reg [1:0] rf_wsel;
//    reg [2:0] sext_op;
//    reg alub_sel;
//    reg alua_sel;
//    reg [3:0] alu_op;
//    reg ram_we;
//    reg load_op;
//    reg store_op;
    
    assign  Bus_addr = alu_C;
    assign  Bus_we   = ram_we;
    assign  Bus_wdata= rf_rD2;

    assign inst_addr = pc_pc[15:2];
    
    ifetch U_ifetch(
        .clk        (cpu_clk),
        .npc_pc     (pc_pc),
        .npc_offset (sext_ext),
        .npc_br     (alu_f),
        .npc_op     (npc_op),
        .reset      (cpu_rst),
        .pc_alu     (alu_C),
        .pc_sel     (pc_sel),
        .npc_pc4    (npc_pc4),
//        .inst       (irom_inst),
        .pc_pc      (pc_pc)
    );
    
    idecode U_idecode(
        .clk        (cpu_clk),
        .rf_rR1     ({inst[19:15]}),
        .rf_rR2     ({inst[24:20]}),
        .rf_wR      ({inst[11:7]}),
        .wb_alu     (alu_C),
        .wb_dram    (Bus_rdata),
        .wb_pc4     (npc_pc4),
        .wb_ext     (sext_ext),
        .rf_wsel    (rf_wsel),
        .rf_we      (rf_we),
        .sext_op    (sext_op),
        .sext_din   ({inst[31:7]}),
        .rf_rD1     (rf_rD1),
        .rf_rD2     (rf_rD2),
        .sext_ext   (sext_ext),
        .wb_value   (wb_value)
    );
    
    execute U_execute(
        .alua_rs1   (rf_rD1),
        .alua_pc    (pc_pc),
        .alua_sel   (alua_sel),
        .alub_rs2   (rf_rD2),
        .alub_ext   (sext_ext),
        .alub_sel   (alub_sel),
        .alu_op     (alu_op),
        .f          (alu_f),
        .C          (alu_C)
    );
    
//    mem U_mem(
//        .clk        (clk_to_dram),
//        .adr        (addr_to_dram),
//        .wdin       (wdata_to_dram),
//        .we         (we_to_dram),
//        .load_op    (load_op),
//        .store_op   (store_op),
//        .rdo        (mem_rdo)
//    );
    
//    Bridge U_Bridge(
//        .rst_from_cpu   (cpu_rst),
//        .clk_from_cpu   (cpu_clk),
//        .addr_from_cpu  (alu_C),
//        .we_from_cpu    (ram_we),
//        .wdata_from_cpu (rf_rD2),
//        .rdata_to_cpu   (rdata_to_cpu),
        
////        .rst_to_dram    (rst_to_dram),
//        .clk_to_dram    (clk_to_dram),
//        .addr_to_dram   (addr_to_dram),
//        .rdata_from_dram(Bus_rdata),
//        .we_to_dram     (we_to_dram),
//        .wdata_to_dram  (wdata_to_dram)
//    );
    
    control U_control(
        .reset      (cpu_rst),
        .opcode     ({inst[6:0]}),
        .funct3     ({inst[14:12]}),
        .funct7     ({inst[31:25]}),
        .pc_sel     (pc_sel),
        .npc_op     (npc_op),
        .rf_we      (rf_we),
        .rf_wsel    (rf_wsel),
        .sext_op    (sext_op),
        .alub_sel   (alub_sel),
        .alua_sel   (alua_sel),
        .alu_op     (alu_op),
        .ram_we     (ram_we),
        .load_op    (load_op),
        .store_op   (store_op)
    );

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1'b1/* TODO */;
    assign debug_wb_pc        = debug_wb_have_inst?pc_pc:32'b0/* TODO */;
    assign debug_wb_ena       = debug_wb_have_inst?rf_we:1'b0/* TODO */;
    assign debug_wb_reg       = (debug_wb_have_inst & debug_wb_ena)?{inst[11:7]}:5'b0/* TODO */;
    assign debug_wb_value     = (debug_wb_have_inst & debug_wb_ena)?wb_value:32'b0/* TODO */;
`endif

endmodule
