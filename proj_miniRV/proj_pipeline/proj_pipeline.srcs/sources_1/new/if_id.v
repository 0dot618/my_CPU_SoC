`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/19 14:33:02
// Design Name: 
// Module Name: if_id
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


module if_id(
    input clk,
    input rst,
    input if_id_flush,
    input if_id_flush_jalr,
    input if_id_keep,
    input [31:0] if_pc,
    input [31:0] if_pc4,
    input [31:0] if_inst,
    input if_have_inst,
    
    output reg [31:0] id_pc,
    output reg [31:0] id_pc4,
    output reg [31:0] id_inst,
    output reg id_have_inst
    );
    
//    always @(posedge clk) begin
    always @(posedge clk or posedge rst) begin
        if(rst) id_pc <= 32'b0;
        else if(if_id_keep == 1'b1) id_pc <= id_pc;
        else if(if_id_flush == 1'b1) id_pc <= 32'h0;
        else if(if_id_flush_jalr == 1'b1) id_pc <= 32'h0;
        else    id_pc <= if_pc;
    end
    

    always @(posedge clk or posedge rst) begin
    if(rst) id_pc4 <= 32'h00000004;
        else if(if_id_keep == 1'b1) id_pc4 <= id_pc4;
        else if(if_id_flush == 1'b1) id_pc4 <= 32'h00000004;
        else if(if_id_flush_jalr == 1'b1) id_pc4 <= 32'h00000004;
        else    id_pc4 <= if_pc4;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) id_inst <= 32'h0;
        else if(if_id_keep == 1'b1)id_inst <= id_inst;
        else if(if_id_flush == 1'b1)id_inst <= 32'h0;
        else if(if_id_flush_jalr == 1'b1)id_inst <= 32'h0;
        else    id_inst <= if_inst;
    end
    
//    always @(posedge clk or posedge if_id_flush_jalr) begin
    always @(posedge clk or posedge rst) begin
        if(rst) id_have_inst <= 0;
        else if(if_id_flush_jalr == 1'b1) id_have_inst <= 0;
        else if(if_id_flush == 1'b1) id_have_inst <= 0;
//        else if(if_id_keep == 1'b1) id_have_inst <= 0;
        else    id_have_inst <= if_have_inst;
    end
    
    
endmodule
