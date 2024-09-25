`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/12 23:20:26
// Design Name: 
// Module Name: idecode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module idecode#(
    parameter WB_ALU = 0,
    parameter WB_DRAM = 1,
    parameter WB_PC4 = 2,
    parameter WB_EXT = 3
    )(
    input clk,
    input [4:0] rf_rR1,
    input [4:0] rf_rR2,
    input [4:0] rf_wR,
    input reset,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0] wb_writeData,
    input wb_wen,
    input [4:0] wb_wR,
    input [24:0] sext_din,
    output wire pc_sel,
    output wire [1:0] npc_op,
    output wire [31:0] rf_rD1,
    output wire [31:0] rf_rD2,
    output wire [31:0] sext_ext,
    output wire [1:0] rf_wsel,
    output wire rf_we,
    output wire alub_sel,
    output wire alua_sel,
    output wire [4:0] alu_op,
    output wire ram_we,
    output wire [2:0] load_op,
    output wire [1:0] store_op,
    output wire [31:0] wb_value,
    
    input [1:0] id_ex_memRead,
    input [4:0] id_ex_wR,
    input [4:0] if_id_rR1,
    input [4:0] if_id_rR2,
    output reg if_id_keep,
    output reg if_pc_keep
    );
        
    reg ctrl_rst = 0;
    
    wire [3:0] sext_op;
    
//    always @(wb_alu, wb_dram, wb_pc4, wb_ext, rf_wsel) begin
//        case(rf_wsel)
//            WB_ALU: rf_wD = wb_alu;
//            WB_DRAM:rf_wD = wb_dram;
//            WB_PC4: rf_wD = wb_pc4;
//            WB_EXT: rf_wD = wb_ext;
//            default:rf_wD = rf_wsel;
//        endcase
//    end
        
//    assign id_writeRegister = rf_wR;
    
    always @(*) begin
        if(id_ex_memRead == WB_DRAM && ((id_ex_wR == if_id_rR1) || (id_ex_wR == if_id_rR2))) begin
            ctrl_rst = 1;
            if_id_keep = 1;
            if_pc_keep = 1;
        end
        else begin
            ctrl_rst = 0;
            if_id_keep = 0;
            if_pc_keep = 0;
        end
    end
    
    RF U_RF (
        .rR1    (rf_rR1),
        .rR2    (rf_rR2),
        .wR     (wb_wR),
        .wD     (wb_writeData),
        .rf_we  (wb_wen),
        .clk    (clk),
        .rD1    (rf_rD1),
        .rD2    (rf_rD2),
        .wb_value (wb_value)
    );
    
    control U_control(
        .reset      (reset | ctrl_rst),
        .opcode     (opcode),
        .funct3     (funct3),
        .funct7     (funct7),
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
    
    SEXT U_SEXT (
        .op     (sext_op),
        .din    (sext_din),
        .ext    (sext_ext)
    );
    
endmodule
