`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2024 01:01:27 PM
// Design Name: 
// Module Name: vga_test
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


module vga_module_test( );
    reg clk;
    reg [11:0] color;
    reg booting;
// wires to see the values of the outputs of your top level
    wire [14:0] pixel_h, pixel_v;
    wire hsync, vsync;
    wire [3:0] vgaR, vgaG, vgaB;


    vga_display vga_test (
        .clk(clk),
        .color(color),
        .booting(booting),
        .pixel_h(pixel_h),
        .pixel_v(pixel_v),
        .hsync(hsync),
        .vsync(vsync),
        .vgaR(vgaR),
        .vgaG(vgaG),
        .vgaB(vgaB)
    );
    
    parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;
    initial    // Clock process for clkin
    begin
        #OFFSET
		  clk = 1'b1;
        forever
        begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clk = ~clk;
        end
    end
    
    initial
    begin
    color = 12'hfff;
    booting = 1'b1;
    // and advance time by 2000 to begin
    #2000;
    booting = 1'b0;
    #100;
    color = 12'hf00;
    #100;
    color = 12'h0f0;
    #100;
    color = 12'h00f;
    #100;
    color = 12'hf00;
    #100;
    color = 12'h0f0;
    #100;
    color = 12'h00f;
    #100;
    color = 12'hf00;
    #100;
    color = 12'h0f0;
    #100;
    color = 12'h00f;
    #100;
    color = 12'hf00;
    #100;
    color = 12'h0f0;
    #100;
    color = 12'h00f;
    #100;
    color = 12'hf00;
    #100;
    color = 12'h0f0;
    #100;
    color = 12'h00f;
    end
endmodule
