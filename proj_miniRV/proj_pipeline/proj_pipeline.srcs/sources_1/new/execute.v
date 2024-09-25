`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/12 23:20:26
// Design Name: 
// Module Name: execute
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


module execute#(
    parameter A_rD1 = 0,
    parameter A_mem_alu_C = 1,
    parameter A_wb_rf_wD = 2,
    
    parameter B_rD2 = 0,
    parameter B_mem_alu_C = 1,
    parameter B_wb_rf_wD = 2,
    
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
    parameter ALU_EXT = 16
    )(
    input [4:0] id_ex_rR1,
    input [4:0] id_ex_rR2,
    input [4:0] ex_mem_wR,
    input ex_mem_rf_we,
    input [4:0] mem_wb_wR, 
    input mem_wb_rf_we,
    input [31:0] mem_alu_C,
    input [31:0] wb_rf_wD,
    
    input [31:0] alua_rs1,
    input [31:0] alua_pc,
    input alua_sel,
    input [31:0] alub_rs2,
    input [31:0] alub_ext,
    input alub_sel,
    input [4:0] alu_op,
    output reg [31:0] ex_rD2,
    output reg f,
    output reg [31:0] C
    );
    
    reg [1:0] forwardingA;
    reg [1:0] forwardingB;
    
    reg [31:0] ex_rD1;
//    reg [31:0] ex_rD2;
    
    reg [31:0] A;
    reg [31:0] B;
    
    always @(*) begin
        if(ex_mem_rf_we == 1'b1 && ex_mem_wR != 5'b0 && ex_mem_wR == id_ex_rR1) begin
            forwardingA = A_mem_alu_C;
        end
        else if(mem_wb_rf_we == 1'b1 && mem_wb_wR != 5'b0 && mem_wb_wR == id_ex_rR1) begin
            forwardingA = A_wb_rf_wD;
        end
        else begin
            forwardingA = A_rD1;
        end
    end
    
    always @(*) begin
        if(ex_mem_rf_we == 1'b1 && ex_mem_wR != 5'b0 && ex_mem_wR == id_ex_rR2) begin
            forwardingB = B_mem_alu_C;
        end
        else if(mem_wb_rf_we == 1'b1 && mem_wb_wR != 5'b0 && mem_wb_wR == id_ex_rR2) begin
            forwardingB = B_wb_rf_wD;
        end
        else begin
            forwardingB = B_rD2;
        end
    end
    
    always @(*) begin
        case(forwardingA)
            A_rD1:      ex_rD1 = alua_rs1;
            A_mem_alu_C:ex_rD1 = mem_alu_C;
            A_wb_rf_wD: ex_rD1 = wb_rf_wD;
            default:   ex_rD1 = alua_rs1;
        endcase
    end
    
    always @(*) begin
        case(forwardingB)
            B_rD2:      ex_rD2 = alub_rs2;
            B_mem_alu_C:ex_rD2 = mem_alu_C;
            B_wb_rf_wD: ex_rD2 = wb_rf_wD;
            default:   ex_rD2 = alub_rs2;
        endcase
    end
    
    always @(ex_rD1, alua_pc, alua_sel) begin
        if(alua_sel == ALUA_RS1) A = ex_rD1;
        else A = alua_pc;
    end
    
    always @(ex_rD2, alub_ext, alub_sel) begin
        if(alub_sel == ALUB_RS2) B = ex_rD2;
        else B = alub_ext;
    end
    
    always @(A, B, alu_op) begin
        case(alu_op)
             ALU_ADD:begin
                        C = A + B;
                        f = 0;
                    end
             ALU_SUB:begin
                        C = A - B;
                        f = 0;
                    end
             ALU_AND:begin
                        C = A & B;
                        f = 0;
                    end
             ALU_OR:begin
                        C = A | B;
                        f = 0;
                    end
             ALU_XOR:begin
                        C = A ^ B;
                        f = 0;
                    end
             ALU_SLL:begin
                        C = A << B[4:0];
                        f = 0;
                    end
             ALU_SRL:begin
                        C = A >> B[4:0];
                        f = 0;
                    end
             ALU_SRA:begin
                        C = ($signed(A)) >>> B[4:0];
                        f = 0;
                    end
             ALU_SLT:begin
                        if(A[31] != B[31]) begin
                            if(A[31] == 1)  C = 1;
                            else    C = 0;
                        end
                        else begin
                            if(A[30:0] < B[30:0])   C = 1;
                            else    C = 0;
                        end
                        f = 0;
                    end
             ALU_SLTU:begin
                        if(A < B) C = 1;
                        else C = 0;
                        f = 0;
                    end
             ALU_EQ:begin
                        C = 32'b0;
                        if(A == B) f = 1;
                        else f = 0;
                    end
             ALU_NE:begin
                        C = 32'b0;
                        if(A != B) f = 1;
                        else f = 0;
                    end
             ALU_LT:begin
                        C = 32'b0;
                        if(A[31] != B[31]) begin
                            if(A[31] == 1)  f = 1;
                            else    f = 0;
                        end
                        else begin
                            if(A[30:0] < B[30:0])   f = 1;
                            else    f = 0;
                        end
                    end
             ALU_LTU:begin
                        C = 32'b0;
                        if(A < B) f = 1;
                        else f = 0;
                    end
             ALU_GE:begin
                        C = 32'b0;
                        if(A[31] != B[31]) begin
                            if(A[31] == 0)  f = 1;
                            else    f = 0;
                        end
                        else begin
                            if(A[30:0] >= B[30:0])   f = 1;
                            else    f = 0;
                        end
                    end
             ALU_GEU:begin
                        C = 32'b0;
                        if(A >= B) f = 1;
                        else f = 0;
                    end
             ALU_EXT:begin
                        C = B;
                        f = 0;
                    end
            
            default:begin
                        C = 32'b0;
                        f = 0;
                    end
        endcase
    end
    
endmodule
