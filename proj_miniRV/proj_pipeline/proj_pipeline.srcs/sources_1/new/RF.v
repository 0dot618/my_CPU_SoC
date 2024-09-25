`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/13 11:44:12
// Design Name: 
// Module Name: RF
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


module RF#(    
    parameter WB_ALU = 0,
    parameter WB_DRAM = 1,
    parameter WB_PC4 = 2,
    parameter WB_EXT = 3
    )(
    input [4:0] rR1,
    input [4:0] rR2,
    input [4:0] wR,
    input [31:0] wD,
    input rf_we,
    input clk,
    output [31:0] rD1,
    output [31:0] rD2,
    output reg [31:0] wb_value
    );
    
    reg [31:0] register [31:0];
    integer i;
    
    initial begin
        for(i=0;i<=31;i=i+1)
            register[i] = 32'b0;
    end
    
    assign rD1 = register[rR1];
    assign rD2 = register[rR2];
    
    always @(negedge clk) begin
        if( rf_we==1 && wR != 5'b0) begin
            register[wR] <= wD;
        end
    end
    
    always @(*) wb_value = wD;
    
endmodule
