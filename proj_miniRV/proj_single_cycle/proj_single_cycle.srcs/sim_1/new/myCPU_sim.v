`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/13 11:56:06
// Design Name: 
// Module Name: myCPU_sim
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


module myCPU_sim();
// input
    reg fpga_clk = 0;
    // output
    wire clk_lock;
    wire pll_clk;
    wire cpu_clk;
    
    reg reset;
    
    always #5 fpga_clk = ~fpga_clk;
    
    cpuclk UCLK (
        .clk_in1    (fpga_clk),
        .locked (clk_lock),
        .clk_out1  (pll_clk)
    );
    
    assign cpu_clk = pll_clk & clk_lock;
    
    myCPU U_myCPU (
        .cpu_clk    (cpu_clk),
        .cpu_rst    (reset)
    );
    
    initial begin
        reset = 0;
        #5005 reset = 1;
        #20 reset = 0;
    end
    
    
endmodule
