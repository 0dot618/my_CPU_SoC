`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 09:33:56
// Design Name: 
// Module Name: io_dig
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


module io_dig(
    input wire         rst,
    input wire         clk,
    input wire [31:0]  addr,
    input wire         we,
    input wire [31:0]  wdata,
    output reg [ 7:0]  led_en,
    output wire         DN_A,
    output wire         DN_B,
    output wire         DN_C,
    output wire         DN_D,
    output wire         DN_E,
    output wire         DN_F,
    output wire         DN_G,
    output wire         DN_DP
    );
    parameter   maxn_cnt = 10000;
    reg [31:0]  disp_data_reg;
    reg [15:0]  cnt;
    reg [ 3:0]  led_num;
    reg [7:0] led_cx;
    wire before_end = (cnt == maxn_cnt - 2);
    wire cnt_end = (cnt == maxn_cnt - 1);
    wire cnt_inc = (cnt < maxn_cnt - 1);

    assign {DN_A,DN_B,DN_C,DN_D,DN_E,DN_F,DN_G,DN_DP} = led_cx;

    always@(posedge clk or posedge rst) begin
        if (rst)         cnt <= 16'b0;
        else if (cnt_inc)   cnt <= cnt + 16'b1;
        else                cnt <= 16'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)         disp_data_reg <= 32'b0;
        else if (we==1 && addr[11:0]==12'h000)      disp_data_reg <= wdata;
        else                disp_data_reg <= disp_data_reg;
    end

    always@(posedge clk or posedge rst) begin
        if (rst) begin
            led_en  <= 8'b11111111;
            led_num <= 4'd7;
            led_cx <= 8'h03;
            end     // end if(~rst_n)
        else begin
            if (before_end) begin
                if (led_num == 4'd7)    led_en <= 8'b01111111;
                else                    led_en <= {led_en[0], led_en[7:1]};
                case({disp_data_reg[4*led_num + 3], disp_data_reg[4*led_num + 2], disp_data_reg[4*led_num + 1], disp_data_reg[4*led_num] })
                    4'h0:   led_cx <= 8'h03 ;
                    4'h1:   led_cx <= 8'h9f ;
                    4'h2:   led_cx <= 8'h25;
                    4'h3:   led_cx <= 8'h0d;
                    4'h4:   led_cx <= 8'h99;
                    4'h5:   led_cx <= 8'h49;
                    4'h6:   led_cx <= 8'h41;
                    4'h7:   led_cx <= 8'h1f;
                    4'h8:   led_cx <= 8'h01;
                    4'h9:   led_cx <= 8'h09;
                    4'hA:   led_cx <= 8'h11;
                    4'hB:   led_cx <= 8'hc1;
                    4'hC:   led_cx <= 8'h63;
                    4'hD:   led_cx <= 8'h85;
                    4'hE:   led_cx <= 8'h61;
                    4'hF:   led_cx <= 8'h71;
                    default:   led_cx <= 8'h03;
                endcase
            end     //end if (before_end)
            else if (cnt_end) begin
                if (led_num == 4'b0)    led_num <= 4'd7;
                else                    led_num <= led_num - 4'd1;
                end     //end if (cnt_end)
            end
    end
    
    
endmodule
