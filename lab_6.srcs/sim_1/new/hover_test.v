`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2024 04:25:09 PM
// Design Name: 
// Module Name: hover_test
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


module hover_test( );
    reg clk;
    reg hovering;
    reg frame;
    reg booting;
// wires to see the values of the outputs of your top level
    wire [14:0] hover_health;
    wire can_hover;


    hover_bar hbar (
        .clk(clk),
        .hovering(hovering),
        .frame(frame),
        .booting(booting),
        .hover_health(hover_health),
        .can_hover(can_hover)
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
    
    initial    // Clock process for clkin
    begin
        #OFFSET
		  frame = 1'b0;
        forever
        begin
            #(PERIOD * 10'd40)
                frame = 1'b1;
            #100
                frame = 1'b0;
        end
    end
    
    initial
    begin
    
    // and advance time by 2000 to begin
    #2000;
    booting = 1'b1;
    #100;
    booting = 1'b0;
    hovering = 1'b0;
    #200;
    hovering = 1'b1;
    #1000;
    hovering = 1'b0;
    #1000;
    end
endmodule
