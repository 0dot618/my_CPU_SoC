`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/12 23:20:26
// Design Name: 
// Module Name: control
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


module control#(
    parameter R_opcode = 7'b0110011,
    parameter I_opcode_i = 7'b0010011,
    parameter I_opcode_l = 7'b0000011,
    parameter I_opcode_jalr = 7'b1100111,
    parameter S_opcode = 7'b0100011,
    parameter B_opcode = 7'b1100011,
    parameter U_opcode_lui = 7'b0110111,
    parameter U_opcode_auipc = 7'b0010111,
    parameter J_opcode = 7'b1101111,
    
    parameter PC_NPC = 0,
    parameter PC_ALU = 1,
    
    parameter NPC_PC4 = 0,
    parameter NPC_B = 1,
    parameter NPC_JMP = 2,
    
    parameter WB_ALU = 0,
    parameter WB_DRAM = 1,
    parameter WB_PC4 = 2,
    parameter WB_EXT = 3,
    
    parameter EXT_I = 0,
    parameter EXT_SI = 1,
    parameter EXT_S = 2,
    parameter EXT_B = 3,
    parameter EXT_U = 4,
    parameter EXT_J = 5,
    
    parameter ALUA_RS1 = 0,
    parameter ALUA_PC = 1,
    
    parameter ALUB_RS2 = 0,
    parameter ALUB_EXT = 1,
    
    parameter ALU_ADD = 0,
    parameter ALU_SUB = 1,
    parameter ALU_AND = 2,
    parameter ALU_OR = 3,
    parameter ALU_XOR = 4,
    parameter ALU_SLL = 5,
    parameter ALU_SRL = 6,
    parameter ALU_SRA = 7,
    parameter ALU_SLT = 8,
    parameter ALU_SLTU = 9,
    parameter ALU_EQ = 10,
    parameter ALU_NE = 11,
    parameter ALU_LT = 12,
    parameter ALU_LTU = 13,
    parameter ALU_GE = 14,
    parameter ALU_GEU = 15,
    
    parameter LOAD_B = 0,
    parameter LOAD_BU = 1,
    parameter LOAD_H = 2,
    parameter LOAD_HU = 3,
    parameter LOAD_W = 4,
    
    parameter STORE_B = 0,
    parameter STORE_H = 1,
    parameter STORE_W = 2
    )(
    input reset,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg pc_sel,
    output reg [1:0] npc_op,
    output reg rf_we,
    output reg [1:0] rf_wsel,
    output reg [2:0] sext_op,
    output reg alub_sel,
    output reg alua_sel,
    output reg [3:0] alu_op,
    output reg ram_we,
    output reg [2:0] load_op,
    output reg [1:0] store_op
    );
    
    always @(opcode, funct3, funct7, reset) begin
        if(reset ==1 ) begin
            pc_sel = 0;
            npc_op = 0;
            rf_we = 0;
            rf_wsel = 0;
            sext_op = 0;
            alub_sel = 0;
            alua_sel = 0;
            alu_op = 0;
            ram_we = 0;
            load_op = 0;
            store_op = 0;
        end
        else begin
                case(opcode)
                    R_opcode:begin
                                pc_sel = PC_NPC;
                                npc_op = NPC_PC4;
                                rf_we = 1;
                                rf_wsel = WB_ALU;
                                sext_op = EXT_I;
                                alua_sel = ALUA_RS1;
                                alub_sel = ALUB_RS2;
                                ram_we = 0;
                                load_op = LOAD_B;
                                store_op = STORE_B;
                                case(funct3)
                                    3'b000: begin
                                                if(funct7 == 7'b0000000) alu_op = ALU_ADD;
                                                else alu_op = ALU_SUB;
                                            end
                                    3'b111: alu_op = ALU_AND;
                                    3'b110: alu_op = ALU_OR;
                                    3'b100: alu_op = ALU_XOR;
                                    3'b001: alu_op = ALU_SLL;
                                    3'b101: begin
                                                if(funct7 == 7'b0000000) alu_op = ALU_SRL;
                                                else alu_op = ALU_SRA;
                                            end
                                    3'b010: alu_op = ALU_SLT;
                                    3'b011: alu_op = ALU_SLTU;
                                    default:alu_op = ALU_ADD;
                                endcase
                            end
                    
                    I_opcode_i:begin
                                pc_sel = PC_NPC;
                                npc_op = NPC_PC4;
                                rf_we = 1;
                                rf_wsel = WB_ALU;
                                alua_sel = ALUA_RS1;
                                alub_sel = ALUB_EXT;
                                ram_we = 0;
                                load_op = LOAD_B;
                                store_op = STORE_B;
                                case(funct3)
                                    3'b000: begin
                                                alu_op = ALU_ADD;
                                                sext_op = EXT_I;
                                            end
                                    3'b111: begin
                                                alu_op = ALU_AND;
                                                sext_op = EXT_I;
                                            end
                                    3'b110: begin
                                                alu_op = ALU_OR;
                                                sext_op = EXT_I;
                                            end
                                    3'b100: begin
                                                alu_op = ALU_XOR;
                                                sext_op = EXT_I;
                                            end
                                    3'b001: begin
                                                alu_op = ALU_SLL;
                                                sext_op = EXT_SI;
                                            end
                                    3'b101: begin
                                                if(funct7 == 7'b0000000) alu_op = ALU_SRL;
                                                else alu_op = ALU_SRA;
                                                sext_op = EXT_SI;
                                            end
                                    3'b010: begin
                                                alu_op = ALU_SLT;
                                                sext_op = EXT_I;
                                            end
                                    3'b011: begin
                                                alu_op = ALU_SLTU;
                                                sext_op = EXT_I;
                                            end
                                    default: begin
                                                alu_op = ALU_ADD;
                                                sext_op = EXT_I;
                                            end
                                endcase
                            end
                    
                    I_opcode_l:begin
                                pc_sel = PC_NPC;
                                npc_op = NPC_PC4;
                                rf_we = 1;
                                rf_wsel = WB_DRAM;
                                sext_op = EXT_I;
                                alua_sel = ALUA_RS1;
                                alub_sel = ALUB_EXT;
                                alu_op = ALU_ADD;
                                ram_we = 0;
                                store_op = STORE_B;
                                case(funct3)
                                    3'b000: begin
                                                load_op = LOAD_B;
                                            end
                                    3'b100: begin
                                                load_op = LOAD_BU;
                                            end
                                    3'b001: begin
                                                load_op = LOAD_H;
                                            end
                                    3'b101: begin
                                                load_op = LOAD_HU;
                                            end
                                    3'b010: begin
                                                load_op = LOAD_W;
                                            end
                                    default: begin
                                                load_op = LOAD_B;
                                            end
                                endcase
                            end
                            
                    I_opcode_jalr:begin
                                pc_sel = PC_ALU;
                                npc_op = NPC_PC4;
                                rf_we = 1;
                                rf_wsel = WB_PC4;
                                sext_op = EXT_I;
                                alua_sel = ALUA_RS1;
                                alub_sel = ALUB_EXT;
                                alu_op = ALU_ADD;
                                ram_we = 0;
                                load_op = LOAD_B;
                                store_op = STORE_B;
                            end
                            
                    S_opcode:begin
                                pc_sel = PC_NPC;
                                npc_op = NPC_PC4;
                                rf_we = 0;
                                rf_wsel = WB_ALU;
                                sext_op = EXT_S;
                                alua_sel = ALUA_RS1;
                                alub_sel = ALUB_EXT;
                                alu_op = ALU_ADD;
                                ram_we = 1;
                                load_op = LOAD_B;
                                case(funct3)
                                    3'b000: begin
                                                store_op = STORE_B;
                                            end
                                    3'b001: begin
                                                store_op = STORE_H;
                                            end
                                    3'b010: begin
                                                store_op = STORE_W;
                                            end
                                    default: begin
                                                store_op = STORE_B;
                                            end
                                endcase
                            end
                            
                    B_opcode:begin
                                pc_sel = PC_NPC;
                                npc_op = NPC_B;
                                rf_we = 0;
                                rf_wsel = WB_ALU;
                                sext_op = EXT_B;
                                alua_sel = ALUA_RS1;
                                alub_sel = ALUB_RS2;
                                ram_we = 0;
                                load_op = LOAD_B;
                                store_op = STORE_B;
                                case(funct3)
                                    3'b000: begin
                                                alu_op = ALU_EQ;
                                            end
                                    3'b001: begin
                                                alu_op = ALU_NE;
                                            end
                                    3'b100: begin
                                                alu_op = ALU_LT;
                                            end
                                    3'b110: begin
                                                alu_op = ALU_LTU;
                                            end
                                    3'b101: begin
                                                alu_op = ALU_GE;
                                            end
                                    3'b111: begin
                                                alu_op = ALU_GEU;
                                            end
                                    default: begin
                                                alu_op = ALU_ADD;
                                            end
                                endcase
                            end
                            
                    U_opcode_lui:begin
                                pc_sel = PC_NPC;
                                npc_op = NPC_PC4;
                                rf_we = 1;
                                rf_wsel = WB_EXT;
                                sext_op = EXT_U;
                                alua_sel = ALUA_RS1;
                                alub_sel = ALUB_RS2;
                                alu_op = ALU_ADD;
                                ram_we = 0;
                                load_op = LOAD_B;
                                store_op = STORE_B;
                            end
                            
                    U_opcode_auipc:begin
                                pc_sel = PC_NPC;
                                npc_op = NPC_PC4;
                                rf_we = 1;
                                rf_wsel = WB_ALU;
                                sext_op = EXT_U;
                                alua_sel = ALUA_PC;
                                alub_sel = ALUB_EXT;
                                alu_op = ALU_ADD;
                                ram_we = 0;
                                load_op = LOAD_B;
                                store_op = STORE_B;
                            end
                            
                    J_opcode:begin
                                pc_sel = PC_NPC;
                                npc_op = NPC_JMP;
                                rf_we = 1;
                                rf_wsel = WB_PC4;
                                sext_op = EXT_J;
                                alua_sel = ALUA_RS1;
                                alub_sel = ALUB_RS2;
                                alu_op = ALU_ADD;
                                ram_we = 0;
                                load_op = LOAD_B;
                                store_op = STORE_B;
                            end
                            
                    default:begin
                                pc_sel = PC_NPC;
                                npc_op = NPC_PC4;
                                rf_we = 0;
                                rf_wsel = 0;
                                sext_op = 0;
                                alub_sel = 0;
                                alua_sel = 0;
                                alu_op = 0;
                                ram_we = 0;
                                load_op = 0;
                                store_op = 0;
                            end
                endcase
        end
    end
    
endmodule
