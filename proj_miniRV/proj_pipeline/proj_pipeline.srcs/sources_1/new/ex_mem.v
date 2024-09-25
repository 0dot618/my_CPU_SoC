`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/20 21:31:31
// Design Name: 
// Module Name: ex_mem
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


module ex_mem(    
    input rst,
    input clk,
    input  [31:0] ex_alu_C,
    input  [31:0] ex_rD2,
    input  [31:0] ex_pc4,
    input  [31:0] ex_ext,
    input  [4:0] ex_writeRegister,
    input  ex_rf_we,
    input  [1:0] ex_rf_wsel,
    input   ex_ram_we,
    input  [2:0] ex_load_op,
    input  [1:0] ex_store_op,
    input  [31:0] ex_pc,
    input ex_have_inst,
    
    output reg [31:0] mem_alu_C,
    output reg [31:0] mem_rD2,
    output reg [31:0] mem_pc4,
    output reg [31:0] mem_ext,
    output reg [4:0] mem_writeRegister,
    output reg mem_rf_we,
    output reg [1:0] mem_rf_wsel,
    output reg  mem_ram_we,
    output reg [2:0] mem_load_op,
    output reg [1:0] mem_store_op,
    output reg [31:0] mem_pc,
    output reg mem_have_inst
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_alu_C <= 32'b0;
        else    mem_alu_C <= ex_alu_C;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_rD2 <= 32'h0;
        else    mem_rD2 <= ex_rD2;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_pc4 <= 32'h00000004;
        else    mem_pc4 <= ex_pc4;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_ext <= 32'b0;
        else    mem_ext <= ex_ext;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_writeRegister <= 5'b0;
        else    mem_writeRegister <= ex_writeRegister;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_rf_we <= 0;
        else    mem_rf_we <= ex_rf_we;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_rf_wsel <= 2'b0;
        else    mem_rf_wsel <= ex_rf_wsel;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_ram_we <= 0;
        else    mem_ram_we <= ex_ram_we;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_load_op <= 3'b0;
        else    mem_load_op <= ex_load_op;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_store_op <= 2'b0;
        else    mem_store_op <= ex_store_op;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_pc <= 32'b0;
        else    mem_pc <= ex_pc;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) mem_have_inst <= 1'b0;
        else    mem_have_inst <= ex_have_inst;
    end
    
endmodule
