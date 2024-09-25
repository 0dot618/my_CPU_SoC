`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/18 23:32:40
// Module Name: NPC
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


module NPC#(
    parameter NPC_PC4 = 0,
    parameter NPC_B = 1,
    parameter NPC_JMP = 2
    )(
    input [31:0] pc,
    input [31:0] offset,
    input br,
    input [1:0] op,
    output reg [31:0] npc,
    input [31:0] pc4,
    output reg if_id_flush,
    output reg id_ex_flush
    );
    
//    assign pc4 = pc + 3'b100;
    reg flush;

    
    always @(pc4, pc, offset, br, op) begin
        case(op)
            NPC_PC4:begin
                    npc = pc4;
                    if_id_flush = 1'b0;
                    id_ex_flush = 1'b0;
                end
            NPC_B:begin
                    if(br == 1'b1) begin
                        npc = pc + offset;
                        if_id_flush = 1'b1;
                        id_ex_flush = 1'b1;
                    end
                    else begin
                        npc = pc4;
                        if_id_flush = 1'b0;
                        id_ex_flush = 1'b0;
                    end
                end
            NPC_JMP:begin
                    npc = pc + offset;
                    if_id_flush = 1'b1;
                    id_ex_flush = 1'b1;
                end
            default:begin
                    npc = pc4;
                    if_id_flush = 1'b0;
                    id_ex_flush = 1'b0;
                end
        endcase
    end
    
endmodule
