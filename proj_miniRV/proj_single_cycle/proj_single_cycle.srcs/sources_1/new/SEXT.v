`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/13 11:44:12
// Design Name: 
// Module Name: SEXT
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


module SEXT#(
    parameter EXT_I = 0,
    parameter EXT_SI = 1,
    parameter EXT_S = 2,
    parameter EXT_B = 3,
    parameter EXT_U = 4,
    parameter EXT_J = 5
    )(
    input [2:0] op,
    input [31:7] din,
    output reg [31:0] ext
    );
    
    always @(op, din) begin
        case(op)
            EXT_I:  ext = {{20{din[31]}},din[31:20]};
            EXT_SI: ext = {{27'b0},din[24:20]};
            EXT_S:  ext = {{20{din[31]}},din[31:25],din[11:7]};
            EXT_B:  ext = {{20{din[31]}},din[7],din[30:25],din[11:8],1'b0};
            EXT_U:  ext = {din[31:12],{12'b0}};
            EXT_J:  ext = {{12{din[31]}},din[19:12],din[20],din[30:21],1'b0};
            default:ext = 32'b0;
        endcase
    end
    
endmodule
