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
    input [31:0] wb_alu,
    input [31:0] wb_dram,
    input [31:0] wb_pc4,
    input [31:0] wb_ext,
    input [1:0] rf_wsel,
    input rf_we,
    input [2:0] sext_op,
    input [24:0] sext_din,
    output [31:0] rf_rD1,
    output [31:0] rf_rD2,
    output [31:0] sext_ext,
    output wire [31:0] wb_value
    );
    
    reg [31:0] rf_wD;
    
    always @(wb_alu, wb_dram, wb_pc4, wb_ext, rf_wsel) begin
        case(rf_wsel)
            WB_ALU: rf_wD = wb_alu;
            WB_DRAM:rf_wD = wb_dram;
            WB_PC4: rf_wD = wb_pc4;
            WB_EXT: rf_wD = wb_ext;
            default:rf_wD = rf_wsel;
        endcase
    end
    
    RF U_RF (
        .rR1    (rf_rR1),
        .rR2    (rf_rR2),
        .wR     (rf_wR),
        .wD     (rf_wD),
        .rf_we  (rf_we),
        .clk    (clk),
        .rD1    (rf_rD1),
        .rD2    (rf_rD2),
        .wb_value (wb_value)
    );
    
    SEXT U_SEXT (
        .op     (sext_op),
        .din    (sext_din),
        .ext    (sext_ext)
    );
    
endmodule
