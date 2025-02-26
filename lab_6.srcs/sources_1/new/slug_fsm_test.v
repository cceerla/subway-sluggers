`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2024 10:29:56 AM
// Design Name: 
// Module Name: slug_fsm_test
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


module slug_fsm_test( );
    reg clk;
    reg frame;
    reg stop_all, can_hover, start_slug;
    reg btnR, btnL, btnU;
    reg right_lane, left_lane, center_lane;
// wires to see the values of the outputs of your top level
    wire is_hovering, go_left, go_right;


    slug_fsm playertest (
        .clk(clk),
        .stop_all(stop_all), .can_hover(can_hover), .start_slug(start_slug),
        .btnR(btnR), .btnL(btnL), .btnU(btnU),
        .right_lane(right_lane), .left_lane(left_lane), .center_lane(center_lane),
        .is_hovering(is_hovering), .go_left(go_left), .go_right(go_right)
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
            #(PERIOD * 10'd40);
                frame = 1'b1;
            #(PERIOD - (PERIOD * DUTY_CYCLE));
                frame = 1'b0;
        end
    end
    
    initial
    begin
    stop_all = 1'b0;
    can_hover = 1'b1;
    start_slug = 1'b0;
    right_lane = 1'b0;
    left_lane = 1'b0;
    center_lane = 1'b0;
    btnR = 1'b0;
    btnL = 1'b0;
    btnU = 1'b0;
    // and advance time by 2000 to begin
    #2000;
    start_slug = 1'b1;
    #100;
    start_slug = 1'b0;
    #100;
    btnU = 1'b1;
    #400;
    can_hover = 1'b0;
    #100;
    can_hover = 1'b1;
    #400;
    btnL = 1'b1;
    #100;
    btnU = 1'b0;
    end
endmodule