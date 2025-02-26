`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2024 01:33:23 PM
// Design Name: 
// Module Name: train_generator
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


module train_generator(
    input clk,
    input start_track,
    input [14:0] overflow_line, // where a new train gets generated;
                                // 400 on sides, 440 on middle
    input frame,
    input [7:0] random_number,
    
    output [14:0] train_0_bottom, train_0_top,
    output [14:0] train_1_bottom, train_1_top,
    output [14:0] wait_out_0
    );
    wire rng_run;
    //wire [7:0] random_number;
    wire new_train, empty_train, first_train;
    wire train_release_0, train_release_1; // 1 if train has begun moving (tr_rel toggles both trains)
    wire done_waiting_0, done_waiting_1;
    wire [14:0] length_0, length_1;
    
    FDRE #(.INIT(1'b1)) train_switcher (.C(clk), .R(1'b0),     // switches which set of counters will be used for a new train;
        .CE(1'b1),
        .D(empty_train ^ 
            (~|(train_0_bottom ^ overflow_line) & frame | 
            ~|(train_1_bottom ^ overflow_line) & frame | 
            start_track)),
        .Q(empty_train)); 
    
    FDRE #(.INIT(1'b1)) not_first_train (.C(clk), .R(1'b0), .CE(1'b1),
        .D(first_train & |(train_0_bottom ^ overflow_line)),
        .Q(first_train));
    
    
    
    bit_counter_15 bot_edge_0 (.clk(clk), .up_or_down(1'b1), // tracks the bottom edge of trains 1, 3, 5...
        .counter_enable(train_release_0 & frame),
        .load_control(~empty_train & ~|(train_1_bottom ^ overflow_line)), 
        .Din(15'd0), .value_out(train_0_bottom));
    bit_counter_15 bot_edge_1 (.clk(clk), .up_or_down(1'b1), // tracks the bottom edge of trains 2, 4, 6...
        .counter_enable(train_release_1 & frame),
        .load_control(empty_train & ~|(train_0_bottom ^ overflow_line)), 
        .Din(15'd0), .value_out(train_1_bottom));
        
    bit_counter_15 wait_0 (.clk(clk), .up_or_down(1'b0), 
        .counter_enable(~train_release_0 & frame),
        .load_control(~empty_train & ~|(train_1_bottom ^ overflow_line) | start_track),
        .Din({8'b0, random_number[6:0]}), .down_terminal_count(done_waiting_0));
    bit_counter_15 wait_1 (.clk(clk), .up_or_down(1'b0), 
        .counter_enable(~train_release_1 & ~first_train & frame),
        .load_control(~empty_train & ~|(train_0_bottom ^ overflow_line) | start_track),
        .Din({8'b0, random_number[6:0]}), .down_terminal_count(done_waiting_1), .value_out(wait_out_0));
        
    // two 15 bit counters, which store the top edges
    // begin incrementing if train_x_bottom >= length,
    // reset in the same circumstances as corresponding bottom
    FDRE #(.INIT(1'b0)) length_0_store[14:0] (.C({15{clk}}), .R(15'b0), .CE({15{1'b1}}),
        .D({15{|(train_0_bottom ^ 15'd1)}} & length_0 |
            {15{~|(train_0_bottom ^ 15'd1)}} & ({9'b0, random_number[5:0]} + 15'd60)),
        .Q(length_0));
    FDRE #(.INIT(1'b0)) length_1_store[14:0] (.C({15{clk}}), .R(15'b0), .CE({15{1'b1}}),
        .D(({15{|(train_1_bottom ^ 15'd1)}} & length_1) |
            ({15{~|(train_1_bottom ^ 15'd1)}} & ({9'b0, random_number[5:0]} + 15'd60))),
        .Q(length_1));
        
    bit_counter_15 top_edge_0 (.clk(clk), .up_or_down(1'b1), // tracks the top edge of trains 1, 3, 5...
        .counter_enable(train_release_0 & (train_0_bottom > length_0) & frame),
        .load_control(~empty_train & ~|(train_1_bottom ^ overflow_line)), 
        .Din(15'd0), .value_out(train_0_top));
    bit_counter_15 top_edge_1 (.clk(clk), .up_or_down(1'b1), // tracks the top edge of trains 1, 3, 5...
        .counter_enable(train_release_1 & (train_1_bottom > length_1) & frame),
        .load_control(~empty_train & ~|(train_0_bottom ^ overflow_line)), 
        .Din(15'd0), .value_out(train_1_top));
    //assign new_train = ~|(train_0_bottom ^ overflow_line) | ~|(train_1_bottom ^ overflow_line) | start_track;
    assign train_release_0 = done_waiting_0 & (train_0_bottom < 15'd4096); // just to prevent it from wrapping around.
    assign train_release_1 = done_waiting_1 & (train_1_bottom < 15'd4096); // idc if they drift down when theyre off screen
    
endmodule
