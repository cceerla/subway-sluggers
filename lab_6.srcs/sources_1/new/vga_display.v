`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2024 01:33:23 PM
// Design Name: 
// Module Name: vga_display
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


module vga_display(
    input clk,
    input [11:0] color,
    //input booting,
    output [14:0] pixel_h, pixel_v,
    output hsync, vsync,
    output [3:0] vgaR, vgaG, vgaB
    );
//    wire [14:0] pixel_h, pixel_v;
    wire [14:0] H_BORD, V_BORD, // bord is the edge of the active area
        H_OFI, V_OFI, H_OFO, V_OFO, // inner and outer edges of the area where v/hsync has to be low
        H_EDGE, V_EDGE; // outer edge of display
    wire h_max, v_max; // high when pixel is outisde of the active area
    wire h_reset, v_reset; // pulses to move to the beginning of the next row/column
    wire h_active, v_active;
    wire [14:0] ZERO;
    
    assign H_BORD = 14'd639;
    assign H_OFI = 14'd654;
    assign H_OFO = 14'd750;
    assign H_EDGE = 14'd799;
    assign V_BORD = 14'd479;
    assign V_OFI = 14'd488;
    assign V_OFO = 14'd490;
    assign V_EDGE = 14'd524;
    
    // smaller values for testing purposes
//    assign H_BORD = 14'd63;
//    assign V_BORD = 14'd47;
//    assign H_OFI = 14'd75;
//    assign H_OFO = 14'd76;
//    assign H_EDGE = 14'd79;
//    assign V_OFI = 14'd48;
//    assign V_OFO = 14'd49;
//    assign V_EDGE = 14'd52;
    
    assign ZERO = 15'b000000000000000;
    
    bit_counter_15 h_pixel (.clk(clk), 
        .up_or_down(1'b1), .counter_enable(1'b1),
        .load_control(h_max), .Din(ZERO),
        .value_out(pixel_h));
    bit_counter_15 v_pixel (.clk(clk), 
        .up_or_down(1'b1), .counter_enable(h_max),
        .load_control(v_max & h_max), .Din(ZERO),
        .value_out(pixel_v));
    assign h_max = pixel_h >= H_EDGE;
    assign v_max = pixel_v >= V_EDGE;
    assign h_reset = h_max;
    assign v_reset = v_max & h_max;
    
    assign vgaR = color[11:8] & {4{h_active & v_active}};
    assign vgaG = color[7:4] & {4{h_active & v_active}};
    assign vgaB = color[3:0] & {4{h_active & v_active}};
    assign hsync = pixel_h <= H_OFI | pixel_h > H_OFO;
    assign vsync = pixel_v <= V_OFI | pixel_v > V_OFO;
    assign h_active = pixel_h <= H_BORD;
    assign v_active = pixel_v <= V_BORD;
endmodule
