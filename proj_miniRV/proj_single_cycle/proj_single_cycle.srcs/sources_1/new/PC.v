`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/13 13:51:56
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
    output reg [31:0] pc
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1)    pc = 32'hfffffffc;
        else    pc = din;
    end
    
endmodule
