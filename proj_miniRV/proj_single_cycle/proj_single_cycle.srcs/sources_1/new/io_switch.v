`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 09:50:06
// Design Name: 
// Module Name: io_switch
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


module io_switch(
    input clk,
    input rst,
    input [31:0] addr,
    input [23:0] switch,
    output reg [31:0] data_switch2cpu
    );
    
    always @(*) begin
        if(rst==1)
            data_switch2cpu = 32'b0;
        else if(addr[11:0] == 12'h070)
            data_switch2cpu = {8'b0,switch};
        else
            data_switch2cpu = 32'b0;
    end
    
endmodule
