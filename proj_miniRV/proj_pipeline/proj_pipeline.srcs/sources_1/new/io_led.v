`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 10:52:12
// Design Name: 
// Module Name: io_led
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


module io_led(
    input clk,
    input rst,
    input [31:0] addr,
    input we,
    input [31:0] wdata,
    output reg [23:0] led
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst == 1) 
            led <= 24'b0;
        else if(we == 1 && addr[11:0] == 12'h060)
            led <= wdata[23:0];
        else
            led <= led;
    end
    
endmodule
