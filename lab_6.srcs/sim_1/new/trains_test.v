`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2024 06:47:40 PM
// Design Name: 
// Module Name: trains_test
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


module trains_test( );
    reg clk;
    reg frame;
    reg start_track, freeze_trains;
    reg [14:0] overflow_line, slug_height;
    reg [7:0] random_number;
// wires to see the values of the outputs of your top level
    wire [14:0] train_0_bottom, train_0_top;
    wire [14:0] train_1_bottom, train_1_top;
    wire scored;


    train_fsm track (
        .clk(clk),
        .start_track(start_track),
        .freeze_trains(freeze_trains),
        .overflow_line(overflow_line),
        .slug_height(slug_height),
        .frame(frame),
        .random_number(random_number),
        .train_0_bottom(train_0_bottom),
        .train_0_top(train_0_top),
        .train_1_bottom(train_1_bottom),
        .train_1_top(train_1_top),
        .scored(scored)
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
    start_track = 1'b0;
    freeze_trains = 1'b0;
    overflow_line = 15'd400;
    slug_height = 15'd360;
    random_number = 8'b00101101;
    // and advance time by 2000 to begin
    #2000;
    #200;
    start_track = 1'b1;
    #100;
    start_track = 1'b0;
    end
endmodule
