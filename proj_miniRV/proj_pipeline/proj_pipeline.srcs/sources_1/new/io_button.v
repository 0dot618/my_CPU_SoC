`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 10:42:18
// Design Name: 
// Module Name: io_button
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


module io_button(
    input rst,
    input clk,
    input [31:0] addr,
    input [4:0]  button,
    output reg [31:0] data_btn2cpu
    );
   
    
    always @(*) begin
        if(rst)
            data_btn2cpu = 32'b0;
        else if(addr[11:0] == 12'h078)
            data_btn2cpu = {27'b0,button};
        else
            data_btn2cpu = 32'b0;
    end
endmodule
