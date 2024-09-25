`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/18 23:32:40
// Design Name: 
// Module Name: ifetch
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


module ifetch#(
    parameter PC_NPC = 0,
    parameter PC_ALU = 1
    )(
    input clk,
    input pc_keep,
    input [31:0] npc_pc,
    input [31:0] npc_offset,
    input npc_br,
    input [1:0] npc_op,
    input reset,
    input [31:0] pc_alu,
    input pc_sel,
    output [31:0] npc_pc4,
//    output [31:0] inst,
    output wire if_have_inst,
    output [31:0] pc_pc,
    output wire if_id_flush,
    output wire id_ex_flush,
    output reg if_id_flush_jalr,
    output reg id_ex_flush_jalr
    );
    
//    wire [31:0] npc_pc4;
    
    wire [31:0] npc_npc;
    reg [31:0] pc_din;
//    reg flush;
    
    always @(npc_npc, pc_alu, pc_sel) begin
        if(pc_sel == PC_NPC)    pc_din = npc_npc;
//        else if(pc_keep == 1'b1) pc_din = pc_pc;
        else    pc_din = pc_alu;
    end
    
    always @(*) begin
        if(pc_sel == PC_ALU) begin
            if_id_flush_jalr = 1'b1;
            id_ex_flush_jalr = 1'b1;
        end
        else begin
            if_id_flush_jalr = 1'b0;
            id_ex_flush_jalr = 1'b0;
        end
    end
    
    NPC U_NPC(
        .pc     (npc_pc),
        .offset (npc_offset),
        .br     (npc_br),
        .op     (npc_op),
        .npc    (npc_npc),
        .pc4    (npc_pc4),
        .if_id_flush(if_id_flush),
        .id_ex_flush(id_ex_flush)
    );
    
    
    assign npc_pc4 = pc_pc + 32'h00000004;
    
    PC U_PC(
        .clk    (clk),
        .rst    (reset),
        .din    (pc_din),
        .pc     (pc_pc),
        .if_have_inst   (if_have_inst),
        .pc_keep    (pc_keep)
    );
    
    
    
//    IROM Mem_IROM (
//        .a      (pc_pc[15:2]),
//        .spo    (inst)
//    );
    
endmodule
