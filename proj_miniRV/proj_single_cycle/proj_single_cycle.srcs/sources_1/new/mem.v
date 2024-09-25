`timescale 1ns / 1ps

`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/13 15:27:48
// Design Name: 
// Module Name: mem
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


module mem#(
    parameter LOAD_B = 0,
    parameter LOAD_BU = 1,
    parameter LOAD_H = 2,
    parameter LOAD_HU = 3,
    parameter LOAD_W = 4,
    
    parameter STORE_B = 0,
    parameter STORE_H = 1,
    parameter STORE_W = 2
    )(
    input clk,
    input [31:0] adr,
    input [31:0] wdin,
    input we,
    input [2:0] load_op,
    input [1:0] store_op,
    output reg [31:0] rdo
    );
    
    reg [31:0] rdata;
    wire [31:0] rdata1;
    
    reg [31:0] wdata;
    
    reg [3:0] wdata_en ;
    
    always @(*) begin
        if(we==1) begin
            case(store_op)
                STORE_B:begin
                            case(adr[1:0])
                                2'b00:  begin 
                                            wdata_en = 4'b0001;
                                            wdata = wdin;
                                        end
                                2'b01:  begin 
                                            wdata_en = 4'b0010;
                                            wdata = {wdin[23:0],8'b0};
                                        end
                                2'b10:  begin 
                                            wdata_en = 4'b0100;
                                            wdata = {wdin[15:0],16'b0};
                                        end
                                2'b11:  begin 
                                            wdata_en = 4'b1000;
                                            wdata = {wdin[7:0],24'b0};
                                        end
                                default:begin 
                                            wdata_en = 4'b0001;
                                            wdata = wdin;
                                        end
                            endcase
                        end
                STORE_H:begin
                            wdata = wdin;
                            case(adr[1:0])
                                2'b00:  begin 
                                            wdata_en = 4'b0011;
                                            wdata = wdin;
                                        end
                                2'b10:  begin 
                                            wdata_en = 4'b1100;
                                            wdata = {wdin[15:0],16'b0};
                                        end
                                default:begin 
                                            wdata_en = 4'b0011;
                                            wdata = wdin;
                                        end
                            endcase
                        end
                STORE_W:begin
                            wdata_en = 4'b1111;
                            wdata = wdin;
                        end
                default:begin
                            wdata_en = 4'b1111;
                            wdata = wdin;
                        end
            endcase
        end
        else begin
            wdata_en = 4'b0000;
            wdata = wdin;
        end
    end
    
    wire [31:0] adr_tmp = adr-32'h4000;
    
    DRAM Mem_DRAM (
`ifdef RUN_TRACE
        .addra  (adr[15:2]),
`else
        .addra  (adr_tmp[15:2]),
`endif
        .clka   (clk),
        .dina   (wdata),
        .wea    (wdata_en),
        .douta  (rdata1)
    );
    
    always @(*) begin
        if(we==0) begin
            case(adr[1:0])
                2'b00:  rdata = rdata1;
                2'b01:  rdata = {8'b0,rdata1[31:8]};
                2'b10:  rdata = {16'b0,rdata1[31:16]};
                2'b11:  rdata = {24'b0,rdata1[31:24]};
                default:rdata = rdata1;
            endcase
        end
        else rdata = rdata1;
    end    
    
    always @(load_op, rdata) begin
        case(load_op)
            LOAD_B: rdo = {{24{rdata[7]}},rdata[7:0]};
            LOAD_BU:rdo = {{24'b0},rdata[7:0]};
            LOAD_H: rdo = {{16{rdata[15]}},rdata[15:0]};
            LOAD_HU:rdo = {{16'b0},rdata[15:0]};
            LOAD_W: rdo = {rdata[31:0]};
            default:rdo = rdata;
        endcase
    end    
    
endmodule
