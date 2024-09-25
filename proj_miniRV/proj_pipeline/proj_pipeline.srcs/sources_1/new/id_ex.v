`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/19 14:58:24
// Design Name: 
// Module Name: id_ex
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


module id_ex(
    input rst,
    input clk,
    input id_ex_flush,
    input id_ex_flush_jalr,
    input [31:0] id_pc,
    input [31:0] id_pc4,
    input [31:0] id_rD1,
    input [31:0] id_rD2,
    input [31:0] id_ext,
    input [4:0] id_rR1,
    input [4:0] id_rR2,
    input id_pc_sel,
    input [1:0] id_npc_op,
    input id_rf_we,
    input [1:0] id_rf_wsel,
    input  id_alua_sel,
    input  id_alub_sel,
    input [4:0] id_alu_op,
    input  id_ram_we,
    input [2:0] id_load_op,
    input [1:0] id_store_op,
    input [4:0] id_writeRegister,
    input id_have_inst,
    
    output reg [4:0] ex_writeRegister,
    output reg [31:0] ex_pc,
    output reg [31:0] ex_pc4,
    output reg [31:0] ex_rD1,
    output reg [31:0] ex_rD2,
    output reg [31:0] ex_ext,
    output reg ex_pc_sel,
    output reg [1:0] ex_npc_op,
    output reg ex_rf_we,
    output reg [1:0] ex_rf_wsel,
    output reg  ex_alua_sel,
    output reg  ex_alub_sel,
    output reg [4:0] ex_alu_op,
    output reg  ex_ram_we,
    output reg [2:0] ex_load_op,
    output reg [1:0] ex_store_op,
    output reg [4:0] ex_rR1,
    output reg [4:0] ex_rR2,
    output reg ex_have_inst,
    
    input if_pc_keep
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_pc <= 32'b0;
        else if(id_ex_flush == 1'b1) ex_pc <= 32'h0;
        else if(id_ex_flush_jalr == 1'b1) ex_pc <= 32'h0;
        else    ex_pc <= id_pc;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_pc4 <= 32'h00000004;
        else if(id_ex_flush == 1'b1) ex_pc4 <= 32'h00000004;
        else if(id_ex_flush_jalr == 1'b1) ex_pc4 <= 32'h00000004;
        else    ex_pc4 <= id_pc4;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_rD1 <= 32'h0;
        else if(id_ex_flush == 1'b1)ex_rD1 <= 32'h0;
        else if(id_ex_flush_jalr == 1'b1)ex_rD1 <= 32'h0;
        else    ex_rD1 <= id_rD1;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_rD2 <= 32'b0;
        else if(id_ex_flush == 1'b1) ex_rD2 <= 32'b0;
        else if(id_ex_flush_jalr == 1'b1) ex_rD2 <= 32'b0;
        else    ex_rD2 <= id_rD2;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_ext <= 32'h0;
        else if(id_ex_flush == 1'b1) ex_ext <= 32'h0;
        else if(id_ex_flush_jalr == 1'b1) ex_ext <= 32'h0;
        else    ex_ext <= id_ext;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_pc_sel <= 0;
        else if(id_ex_flush == 1'b1) ex_pc_sel <= 0;
        else if(id_ex_flush_jalr == 1'b1) ex_pc_sel <= 0;
        else    ex_pc_sel <= id_pc_sel;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_npc_op <= 2'b0;
        else if(id_ex_flush == 1'b1)  ex_npc_op <= 2'b0;
        else if(id_ex_flush_jalr == 1'b1)  ex_npc_op <= 2'b0;
        else    ex_npc_op <= id_npc_op;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_rf_we <= 0;
        else if(id_ex_flush == 1'b1)  ex_rf_we <= 0;
        else if(id_ex_flush_jalr == 1'b1)  ex_rf_we <= 0;
        else    ex_rf_we <= id_rf_we;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_rf_wsel <= 2'b0;
        else if(id_ex_flush == 1'b1) ex_rf_wsel <= 2'b0;
        else if(id_ex_flush_jalr == 1'b1) ex_rf_wsel <= 2'b0;
        else    ex_rf_wsel <= id_rf_wsel;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_alua_sel <= 0;
        else if(id_ex_flush == 1'b1) ex_alua_sel <= 0;
        else if(id_ex_flush_jalr == 1'b1) ex_alua_sel <= 0;
        else    ex_alua_sel <= id_alua_sel;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_alub_sel <= 0;
        else if(id_ex_flush == 1'b1) ex_alub_sel <= 0;
        else if(id_ex_flush_jalr == 1'b1) ex_alub_sel <= 0;
        else    ex_alub_sel <= id_alub_sel;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_alu_op <= 5'b0;
        else if(id_ex_flush == 1'b1)  ex_alu_op <= 5'b0;
        else if(id_ex_flush_jalr == 1'b1)  ex_alu_op <= 5'b0;
        else    ex_alu_op <= id_alu_op;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_ram_we <= 0;
        else if(id_ex_flush == 1'b1) ex_ram_we <= 0;
        else if(id_ex_flush_jalr == 1'b1) ex_ram_we <= 0;
        else    ex_ram_we <= id_ram_we;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_load_op <= 3'b0;
        else if(id_ex_flush == 1'b1) ex_load_op <= 3'b0;
        else if(id_ex_flush_jalr == 1'b1) ex_load_op <= 3'b0;
        else    ex_load_op <= id_load_op;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_store_op <= 2'b0;
        else if(id_ex_flush == 1'b1)  ex_store_op <= 2'b0;
        else if(id_ex_flush_jalr == 1'b1)  ex_store_op <= 2'b0;
        else    ex_store_op <= id_store_op;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_writeRegister <= 5'b0;
        else if(id_ex_flush == 1'b1)  ex_writeRegister <= 5'b0;
        else if(id_ex_flush_jalr == 1'b1)  ex_writeRegister <= 5'b0;
        else    ex_writeRegister <= id_writeRegister;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_rR1 <= 5'b0;
        else if(id_ex_flush == 1'b1)  ex_rR1 <= 5'b0;
        else if(id_ex_flush_jalr == 1'b1)  ex_rR1 <= 5'b0;
        else    ex_rR1 <= id_rR1;
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) ex_rR2 <= 5'b0;
        else if(id_ex_flush == 1'b1) ex_rR2 <= 5'b0;
        else if(id_ex_flush_jalr == 1'b1) ex_rR2 <= 5'b0;
        else    ex_rR2 <= id_rR2;
    end
    
//    always @(posedge clk or posedge rst or posedge id_ex_flush_jalr) begin
    always @(posedge clk or posedge rst) begin
        if(rst) ex_have_inst <= 1'b0;
        else if(id_ex_flush_jalr == 1'b1) ex_have_inst <= 1'b0;
        else if(id_ex_flush == 1'b1) ex_have_inst <= 1'b0;
        else if(if_pc_keep == 1'b1) ex_have_inst <= 1'b0;
        else    ex_have_inst <= id_have_inst;
    end
    
endmodule
