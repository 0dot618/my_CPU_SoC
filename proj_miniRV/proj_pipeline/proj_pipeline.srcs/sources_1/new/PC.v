`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/18 23:32:40
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input rst,
    input [31:0] din,
    input pc_keep,
    output reg [31:0] pc,
    output reg if_have_inst
    );
    
    always @(posedge clk or posedge rst) begin
//        if (rst == 1'b1)    pc = 32'h0;
        if (rst == 1'b1)    pc <= 32'hfffffffc;
        else if(pc_keep == 1'b1) pc <= pc;
        else    pc <= din;
    end
    
    always @(posedge clk) begin
        if (rst == 1'b1)    if_have_inst <= 1'b0;
//        else if(pc_keep==1'b1) if_have_inst <= 1'b0;
        else    if_have_inst <= 1'b1;
    end

//    always @(*) begin
//        if(pc_keep==1'b1) if_have_inst = 1'b0;
//    end
    
endmodule
