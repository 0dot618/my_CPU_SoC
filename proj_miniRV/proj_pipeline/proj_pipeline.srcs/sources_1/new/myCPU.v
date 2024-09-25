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
    wire [1:0] rf_wsel;
    wire rf_we;
    wire [2:0] sext_op;
    reg [24:0] sext_din;
    wire [31:0] sext_ext;
    wire [31:0] wb_value;
    
    reg [31:0] alua_rs1;
    reg [31:0] alua_pc;
    wire alua_sel;
    reg [31:0] alub_rs2;
    reg [31:0] alub_ext;
    wire alub_sel;
    wire [4:0] alu_op;
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
    
    wire [31:0] if_pc;
    wire [31:0] if_pc4;
    wire [31:0] id_pc;
    wire [31:0] id_pc4;
    wire [31:0] id_inst;
    wire [31:0] id_rD1;
    wire [31:0] id_rD2;
    wire [31:0] id_ext;
    wire id_pc_sel;
    wire [1:0] id_npc_op;
    wire id_rf_we;
    wire [1:0] id_rf_wsel;
    wire id_alub_sel;
    wire id_alua_sel;
    wire [4:0] id_alu_op;
    wire id_ram_we;
    wire [2:0] id_load_op;
    wire [1:0] id_store_op;
    
    wire [31:0] wb_writeData;
    wire wb_wen;
    wire [4:0] wb_writeRegister;
    reg [31:0] rf_rD1;
    reg [31:0] rf_rD2;
    
    
    wire if_id_keep;
    wire pc_keep;
    wire if_id_flush;
    wire id_ex_flush;
    
    wire [4:0] ex_writeRegister;
    wire [31:0] ex_pc;
    wire [31:0] ex_pc4;
    wire [31:0] ex_rD1;
    wire [31:0] ex_rD2_tmp;
    wire [31:0] ex_rD2;
    wire [31:0] ex_ext;
    wire ex_pc_sel;
    wire [1:0] ex_npc_op;
    wire ex_rf_we;
    wire [1:0] ex_rf_wsel;
    wire  ex_alua_sel;
    wire  ex_alub_sel;
    wire [4:0] ex_alu_op;
    wire  ex_ram_we;
    wire [2:0] ex_load_op;
    wire [1:0] ex_store_op;
    
    
    wire [4:0] id_ex_rR1;
    wire [4:0] id_ex_rR2;
    reg [4:0] ex_mem_wR;
    reg [4:0] mem_wb_wR;
    
    
    wire ex_alu_f;
    wire [31:0] ex_alu_C;
    
    wire [31:0] mem_alu_C;
    wire [31:0] mem_rD2;
    wire [31:0] mem_pc4;
    wire [31:0] mem_ext;
    wire [4:0] mem_writeRegister;
    wire mem_rf_we;
    wire [1:0] mem_rf_wsel;
    wire  mem_ram_we;
    wire [2:0] mem_load_op;
    wire [1:0] mem_store_op;
    
    wire [31:0] wb_rdo;
    wire [31:0] wb_pc4;
    wire [31:0] wb_ext;
    wire [31:0] wb_alu_C;
//    reg [4:0]  wb_writeRegister;
    wire [1:0]  wb_rf_wsel;
    wire wb_rf_we;
    
    wire [31:0] wb_rf_wD;
    
    wire if_have_inst;
    wire id_have_inst;
    wire ex_have_inst;
    wire mem_have_inst;
    wire wb_have_inst;
    
    assign  Bus_addr = mem_alu_C;
    assign  Bus_we   = mem_ram_we;
    assign  Bus_wdata= mem_rD2;
    assign  load_op  = mem_load_op;
    assign  store_op = mem_store_op;

    assign inst_addr = if_pc[15:2];
    
    wire if_id_flush_jalr;
    wire id_ex_flush_jalr;
    
    ifetch U_ifetch(
        .clk        (cpu_clk),
        .reset      (cpu_rst),
        .pc_keep    (pc_keep),
        .npc_pc     (ex_pc),
        .npc_offset (ex_ext),
        .npc_br     (ex_alu_f),
        .npc_op     (ex_npc_op),
        .pc_alu     (ex_alu_C),
        .pc_sel     (ex_pc_sel),
        .npc_pc4    (if_pc4),
        .if_have_inst       (if_have_inst),
        .pc_pc      (if_pc),
        .if_id_flush(if_id_flush),
        .id_ex_flush(id_ex_flush),
        .if_id_flush_jalr   (if_id_flush_jalr),
        .id_ex_flush_jalr   (id_ex_flush_jalr)
    );
    
    if_id U_if_id(
        .clk    (cpu_clk),
        .rst    (cpu_rst),
//        .rst    (cpu_rst | if_id_flush),
        .if_id_keep (if_id_keep),
        .if_id_flush(if_id_flush),
        .if_id_flush_jalr   (if_id_flush_jalr),
        .if_pc  (if_pc),
        .if_pc4 (if_pc4),
        .if_inst(inst),
        .if_have_inst   (if_have_inst),
        .id_pc  (id_pc),
        .id_pc4 (id_pc4),
        .id_inst(id_inst),
        .id_have_inst   (id_have_inst)
    );
    
    
    assign wb_wen = wb_rf_we;
    assign wb_writeData = wb_rf_wD;
    
    idecode U_idecode(
        .clk        (cpu_clk),
        .rf_rR1     ({id_inst[19:15]}),
        .rf_rR2     ({id_inst[24:20]}),
        .rf_wR      ({id_inst[11:7]}),
        .reset      (cpu_rst),
        .opcode     ({id_inst[6:0]}),
        .funct3     ({id_inst[14:12]}),
        .funct7     ({id_inst[31:25]}),
        .wb_writeData   (wb_writeData),
        .wb_wen     (wb_wen),
        .wb_wR      (wb_writeRegister),
        .sext_din   ({id_inst[31:7]}),
        .rf_rD1     (id_rD1),
        .rf_rD2     (id_rD2),
        .sext_ext   (id_ext),
        .pc_sel     (id_pc_sel),
        .npc_op     (id_npc_op),
        .rf_we      (id_rf_we),
        .rf_wsel    (id_rf_wsel),
        .alub_sel   (id_alub_sel),
        .alua_sel   (id_alua_sel),
        .alu_op     (id_alu_op),
        .ram_we     (id_ram_we),
        .load_op    (id_load_op),
        .store_op   (id_store_op),
        .wb_value   (wb_value),
        
        .id_ex_memRead  (ex_rf_wsel),
        .id_ex_wR       (ex_writeRegister),
        .if_id_rR1      (id_inst[19:15]),
        .if_id_rR2      (id_inst[24:20]),
        .if_id_keep     (if_id_keep),
        .if_pc_keep     (pc_keep)
    );
    
    
    id_ex U_id_ex(
        .rst        (cpu_rst),
        .clk        (cpu_clk),
//        .rst        (cpu_rst | id_ex_flush),
        .id_ex_flush(id_ex_flush),
        .id_ex_flush_jalr   (id_ex_flush_jalr),
//        .id_ex_flush    (0),
        .id_pc      (id_pc),
        .id_pc4     (id_pc4),
        .id_rD1     (id_rD1),
        .id_rD2     (id_rD2),
        .id_ext     (id_ext),
        .id_rR1     (id_inst[19:15]),
        .id_rR2     (id_inst[24:20]),
        .id_pc_sel  (id_pc_sel),
        .id_npc_op  (id_npc_op),
        .id_rf_we   (id_rf_we),
        .id_rf_wsel (id_rf_wsel),
        .id_alua_sel(id_alua_sel),
        .id_alub_sel(id_alub_sel),
        .id_alu_op  (id_alu_op),
        .id_ram_we  (id_ram_we),
        .id_load_op (id_load_op),
        .id_store_op(id_store_op),
        .id_have_inst   (id_have_inst),
        .id_writeRegister      (id_inst[11:7]),
        .ex_writeRegister      (ex_writeRegister),
        .ex_pc      (ex_pc),
        .ex_pc4     (ex_pc4),
        .ex_rD1     (ex_rD1),
        .ex_rD2     (ex_rD2_tmp),
        .ex_ext     (ex_ext),
        .ex_rR1     (id_ex_rR1),
        .ex_rR2     (id_ex_rR2),
        .ex_pc_sel  (ex_pc_sel),
        .ex_npc_op  (ex_npc_op),
        .ex_rf_we   (ex_rf_we),
        .ex_rf_wsel (ex_rf_wsel),
        .ex_alua_sel(ex_alua_sel),
        .ex_alub_sel(ex_alub_sel),
        .ex_alu_op  (ex_alu_op),
        .ex_ram_we  (ex_ram_we),
        .ex_load_op (ex_load_op),
        .ex_store_op(ex_store_op),
        .ex_have_inst   (ex_have_inst),
        .if_pc_keep     (pc_keep)
    );
    
    execute U_execute(
        .id_ex_rR1  (id_ex_rR1),
        .id_ex_rR2  (id_ex_rR2),
        .ex_mem_wR  (mem_writeRegister),   
        .ex_mem_rf_we   (mem_rf_we),
        .mem_wb_wR  (wb_writeRegister),   
        .mem_wb_rf_we   (wb_rf_we),
        .mem_alu_C  (mem_alu_C),
        .wb_rf_wD   (wb_rf_wD),
        
        .alua_rs1   (ex_rD1),
        .alua_pc    (ex_pc),
        .alua_sel   (ex_alua_sel),
        .alub_rs2   (ex_rD2_tmp),
        .alub_ext   (ex_ext),
        .alub_sel   (ex_alub_sel),
        .alu_op     (ex_alu_op),
        .ex_rD2     (ex_rD2),
        .f          (ex_alu_f),
        .C          (ex_alu_C)
    );
    
    wire [31:0] mem_pc;
    wire [31:0] wb_pc;
    
    ex_mem U_ex_mem(
        .clk        (cpu_clk),
        .rst        (cpu_rst),
        .ex_alu_C   (ex_alu_C),
        .ex_rD2     (ex_rD2),
        .ex_pc4     (ex_pc4),
        .ex_ext     (ex_ext),
        .ex_writeRegister   (ex_writeRegister),   
        .ex_rf_we   (ex_rf_we),
        .ex_rf_wsel (ex_rf_wsel),
        .ex_ram_we  (ex_ram_we),
        .ex_load_op (ex_load_op),
        .ex_store_op(ex_store_op),
        .ex_pc      (ex_pc),
        .ex_have_inst   (ex_have_inst),
        .mem_alu_C   (mem_alu_C),
        .mem_rD2     (mem_rD2),
        .mem_pc4     (mem_pc4),
        .mem_ext     (mem_ext),
        .mem_writeRegister   (mem_writeRegister),   
        .mem_rf_we   (mem_rf_we),
        .mem_rf_wsel (mem_rf_wsel),
        .mem_ram_we  (mem_ram_we),
        .mem_load_op (mem_load_op),
        .mem_store_op(mem_store_op),
        .mem_pc      (mem_pc),
        .mem_have_inst   (mem_have_inst)
    );
    
    mem_wb U_mem_wb(
        .clk        (cpu_clk),
        .rst        (cpu_rst),
        .mem_rdo    (Bus_rdata),
        .mem_pc4    (mem_pc4),
        .mem_ext    (mem_ext),
        .mem_alu_C  (mem_alu_C),
        .mem_writeRegister  (mem_writeRegister),
        .mem_rf_we  (mem_rf_we),
        .mem_rf_wsel(mem_rf_wsel),
        .mem_pc      (mem_pc),
        .mem_have_inst   (mem_have_inst),
        
        .wb_rdo    (wb_rdo),
        .wb_pc4    (wb_pc4),
        .wb_ext    (wb_ext),
        .wb_alu_C  (wb_alu_C),
        .wb_writeRegister  (wb_writeRegister),
        .wb_rf_we  (wb_rf_we),
        .wb_rf_wsel(wb_rf_wsel),
        .wb_pc      (wb_pc),
        .wb_have_inst   (wb_have_inst)
    );
    
    writeBack U_writeBack(
        .wb_alu     (wb_alu_C),
        .wb_dram    (wb_rdo),
        .wb_ext     (wb_ext),
        .wb_pc4     (wb_pc4),
        .rf_wsel    (wb_rf_wsel),
        .rf_wD      (wb_rf_wD)
    );
    
//    control U_control(
//        .reset      (cpu_rst),
//        .opcode     ({id_inst[6:0]}),
//        .funct3     ({id_inst[14:12]}),
//        .funct7     ({id_inst[31:25]}),
//        .pc_sel     (pc_sel),
//        .npc_op     (npc_op),
//        .rf_we      (rf_we),
//        .rf_wsel    (rf_wsel),
//        .sext_op    (sext_op),
//        .alub_sel   (alub_sel),
//        .alua_sel   (alua_sel),
//        .alu_op     (alu_op),
//        .ram_we     (ram_we),
//        .load_op    (load_op),
//        .store_op   (store_op)
//    );
    
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

`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = wb_have_inst/* TODO */;
    assign debug_wb_pc        = debug_wb_have_inst?wb_pc:32'b0/* TODO */;
    assign debug_wb_ena       = debug_wb_have_inst?wb_wen:1'b0/* TODO */;
    assign debug_wb_reg       = (debug_wb_have_inst & debug_wb_ena)?wb_writeRegister:5'b0/* TODO */;
    assign debug_wb_value     = (debug_wb_have_inst & debug_wb_ena)?wb_writeData:32'b0/* TODO */;
`endif

endmodule
