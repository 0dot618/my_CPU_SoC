`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/12 23:20:26
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
    input [31:0] npc_pc,
    input [31:0] npc_offset,
    input npc_br,
    input [1:0] npc_op,
    input reset,
    input [31:0] pc_alu,
    input pc_sel,
    output [31:0] npc_pc4,
//    output [31:0] inst,
    output [31:0] pc_pc
    );
    
    wire [31:0] npc_npc;
    reg [31:0] pc_din;
    
    always @(npc_npc, pc_alu, pc_sel) begin
        if(pc_sel == PC_NPC)    pc_din = npc_npc;
        else    pc_din = pc_alu;
    end
    
    NPC U_NPC(
        .pc     (pc_pc),
        .offset (npc_offset),
        .br     (npc_br),
        .op     (npc_op),
        .npc    (npc_npc),
        .pc4    (npc_pc4)
    );
    
    PC U_PC(
        .clk    (clk),
        .rst    (reset),
        .din    (pc_din),
        .pc     (pc_pc)
    );
    
//    IROM Mem_IROM (
//        .a      (pc_pc[15:2]),
//        .spo    (inst)
//    );
    
endmodule
