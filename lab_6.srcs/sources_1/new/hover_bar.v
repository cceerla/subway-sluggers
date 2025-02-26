`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 04:04:45 PM
// Design Name: 
// Module Name: hover_bar
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


module hover_bar(
    input clk,
    input hovering,
    input frame,
    input booting,
    output [14:0] hover_health,
    output can_hover
    );
    wire no_hover;
    wire hover_count;
    wire hover_edge;
    
    bit_counter_15 hov_hp (.clk(clk), .up_or_down(hovering),
        .counter_enable(hover_count),
        .load_control(booting), .Din(15'd0), .value_out(hover_health),
        .down_terminal_count(no_hover));
    
    assign hover_edge = ~|(hover_health ^ 15'd0) & ~hovering |
        ~|(hover_health ^ 15'd192) & hovering;
    assign hover_count = frame & ~hover_edge;
    assign can_hover = |(hover_health ^ 15'd192);
endmodule
