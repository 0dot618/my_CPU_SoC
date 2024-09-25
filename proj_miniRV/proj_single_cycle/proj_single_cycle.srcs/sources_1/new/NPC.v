`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/13 13:51:56
// Design Name: 
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
    output [31:0] pc4
    );
    
    assign pc4 = pc + 3'b100;
    
    always @(pc, offset, br, op) begin
        case(op)
            NPC_PC4:npc = pc + 3'b100;
            NPC_B:begin
                    if(br == 1'b1)  npc = pc + offset;
                    else    npc = pc + 3'b100;
                end
            NPC_JMP:npc = pc + offset;
            default:npc = pc + 3'b100;
        endcase
    end
    
endmodule
