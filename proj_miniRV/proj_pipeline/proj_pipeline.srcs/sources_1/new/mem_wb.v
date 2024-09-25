`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/20 22:36:22
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
    input  clk,
    input  rst,
    input  [31:0] mem_rdo,
    input  [31:0] mem_pc4,
    input  [31:0] mem_ext,
    input  [31:0] mem_alu_C,
    input  [4:0]  mem_writeRegister,
    input  [1:0]  mem_rf_wsel,
    input  mem_rf_we,
    input [31:0] mem_pc,
    input mem_have_inst,
    
    output reg [31:0] wb_rdo,
    output reg [31:0] wb_pc4,
    output reg [31:0] wb_ext,
    output reg [31:0] wb_alu_C,
    output reg [4:0]  wb_writeRegister,
    output reg [1:0]  wb_rf_wsel,
    output reg wb_rf_we,
    output reg [31:0] wb_pc,
    output reg wb_have_inst
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) wb_rdo <= 32'b0;
        else    wb_rdo <= mem_rdo;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) wb_pc4 <= 32'h0;
        else    wb_pc4 <= mem_pc4;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) wb_ext <= 32'h0;
        else    wb_ext <= mem_ext;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) wb_alu_C <= 32'b0;
        else    wb_alu_C <= mem_alu_C;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) wb_writeRegister <= 5'b0;
        else    wb_writeRegister <= mem_writeRegister;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) wb_rf_we <= 0;
        else    wb_rf_we <= mem_rf_we;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) wb_rf_wsel <= 2'b0;
        else    wb_rf_wsel <= mem_rf_wsel;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) wb_pc <= 32'b0;
        else    wb_pc <= mem_pc;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) wb_have_inst <= 1'b0;
        else    wb_have_inst <= mem_have_inst;
    end
    
endmodule
