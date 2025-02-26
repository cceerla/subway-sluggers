`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2024 01:32:51 PM
// Design Name: 
// Module Name: brain_fsm_test
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


module brain_fsm_test( );
    reg clk;
    reg frame;
    reg btnC, collision;
    reg reset_timer;
// wires to see the values of the outputs of your top level
    wire start_slug,  stop_all;
    wire open_center, open_left, open_right;
    wire six_sec, two_sec;
    
//    game_fsm gametest (
//        .clk(clk),
//        .btnC(btnC), .two_sec(two_sec), .six_sec(six_sec), .collision(collision),
//        .start_slug(start_slug), .reset_timer(reset_timer), .stop_all(stop_all),
//        .open_center(open_center), .open_left(open_left), .open_right(open_right)
//    );
    
    timer time_counter_test (
        .clk(clk),
        .frame(frame),
        .timer_reset(reset_timer),
        .two_sec(two_sec), .six_sec(six_sec));
    
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
            #(PERIOD * 10'd3);
                frame = 1'b1;
            #(PERIOD - (PERIOD * DUTY_CYCLE));
                frame = 1'b0;
        end
    end
    
    initial
    begin
    btnC = 1'b0;
    //two_sec = 1'b0;
    //six_sec = 1'b0;
    collision = 1'b0;
    reset_timer = 1'b0;
    // and advance time by 2000 to begin
    #2000;
    btnC = 1'b1;
    reset_timer = 1'b1;
    #100;
    btnC = 1'b0;
    reset_timer = 1'b0;
    #400;
    //two_sec = 1'b1;
    #100;
    //two_sec = 1'b0;
    #400;
    //six_sec = 1'b1;
    #100;
    //six_sec = 1'b0;
    #800;
    collision = 1'b1;
    #100;
    end
endmodule