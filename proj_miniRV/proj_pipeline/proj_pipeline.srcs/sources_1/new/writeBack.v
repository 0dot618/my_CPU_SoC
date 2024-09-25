`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/20 22:36:22
// Design Name: 
// Module Name: writeBack
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


module writeBack#(
    parameter WB_ALU = 0,
    parameter WB_DRAM = 1,
    parameter WB_PC4 = 2,
    parameter WB_EXT = 3
    )(
    input [31:0] wb_alu,
    input [31:0] wb_dram,
    input [31:0] wb_pc4,
    input [31:0] wb_ext,
    input [1:0] rf_wsel,
    output reg [31:0] rf_wD

    );
    
    always @(wb_alu, wb_dram, wb_pc4, wb_ext, rf_wsel) begin
        case(rf_wsel)
            WB_ALU: rf_wD = wb_alu;
            WB_DRAM:rf_wD = wb_dram;
            WB_PC4: rf_wD = wb_pc4;
            WB_EXT: rf_wD = wb_ext;
            default:rf_wD = rf_wsel;
        endcase
    end

endmodule
