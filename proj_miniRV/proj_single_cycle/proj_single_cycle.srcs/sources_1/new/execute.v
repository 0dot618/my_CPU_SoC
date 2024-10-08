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
    parameter ALU_GEU = 15
    )(
    input [31:0] alua_rs1,
    input [31:0] alua_pc,
    input alua_sel,
    input [31:0] alub_rs2,
    input [31:0] alub_ext,
    input alub_sel,
    input [3:0] alu_op,
    output reg f,
    output reg [31:0] C
    );
    
    reg [31:0] A;
    reg [31:0] B;
    
    always @(alua_rs1, alua_pc, alua_sel) begin
        if(alua_sel == ALUA_RS1) A = alua_rs1;
        else A = alua_pc;
    end
    
    always @(alub_rs2, alub_ext, alub_sel) begin
        if(alub_sel == ALUB_RS2) B = alub_rs2;
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
            
            default:begin
                        C = 32'b0;
                        f = 0;
                    end
        endcase
    end
    
endmodule
