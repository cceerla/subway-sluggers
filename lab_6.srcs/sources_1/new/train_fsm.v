`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2024 02:00:18 PM
// Design Name: 
// Module Name: train_fsm
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


module train_fsm(
    input clk,
    input frame,
    input start_track,
    input freeze_trains,
    input [14:0] overflow_line, // where a new train gets generated;
                                // 400 on sides, 440 on middle
    input [14:0] slug_height,
    input [7:0] random_number,
    
    output [14:0] train_0_bottom, train_0_top,
    output [14:0] train_1_bottom, train_1_top,
    output scored
    );
    // trains TAKE TWO for my own sanity!
    // hudson mentioned approaching the trains with a state machine and thats a WONDERFUL idea actually
    // also i KNOW i was told to write logic
    // directly in the parameters of my counters
    // but it just made me overwhelmed looking at it
    // so, sorry for the extra/redundant wires!!
    // theyre a psychological crutch given this lab is due tomorrow
    wire [7:0] go_to;
    wire [7:0] come_from;
    wire [1:0] pos_increment;
    wire [1:0] pos_inc_toggle;
    
    wire reset_0, reset_1;
    wire done_waiting_0, done_waiting_1;
    wire [14:0] length_0, length_1, length_in_0, length_in_1;
    wire edge_b0, edge_b1, edge_t0, edge_t1;
    wire first_train;
    // STATE MACHINE FLIP FLOPS
    FDRE #(.INIT(1'b1)) q0_ff (.C(clk), .R(1'b0), .CE(1'b1), .D(go_to[0]), .Q(come_from[0]));
    FDRE #(.INIT(7'b0)) q1_7_ff[7:1] (.C({7{clk}}), .R(7'b0), .CE({7{1'b1}}), .D(go_to[7:1]), .Q(come_from[7:1]));
    // POSITION INCREMENTING FLIP FLOPS
    FDRE #(.INIT(2'b0)) pos_incrementor[1:0] (.C({2{clk}}), .R(2'b0), .CE({2{1'b1}}), 
        .D((pos_increment[1:0] ^ pos_inc_toggle[1:0]) & {2{~come_from[7]}}), .Q(pos_increment[1:0]));
    // FIRST TRAIN FF
    FDRE #(.INIT(1'b1)) train_1 (.C(clk), .R(1'b0), .CE(1'b1), .D(first_train & ~come_from[5]), .Q(first_train));
    // q:
    // 0: no trains
    // 1: gen train 0
    // 2: waiting tr 0
    // 3: tr 0 moving
    // 4: gen train 1
    // 5: waiting tr 1
    // 6: tr 1 moving
    // 7: game over
    
    assign go_to[0] = ~freeze_trains & (come_from[0] & ~start_track);
    assign go_to[1] = ~freeze_trains & (come_from[0] & start_track | come_from[6] & ~|(train_1_bottom ^ overflow_line));
    assign go_to[2] = ~freeze_trains & (come_from[1] | come_from[2] & ~done_waiting_0);
    assign go_to[3] = ~freeze_trains & (come_from[2] & done_waiting_0 | come_from[3] & |(train_0_bottom ^ overflow_line));
    assign go_to[4] = ~freeze_trains & (come_from[3] & ~|(train_0_bottom ^ overflow_line));
    assign go_to[5] = ~freeze_trains & (come_from[4] | come_from[5] & ~done_waiting_1);
    assign go_to[6] = ~freeze_trains & (come_from[5] & done_waiting_1 | come_from[6] & |(train_1_bottom ^ overflow_line));
    assign go_to[7] = freeze_trains;
    assign pos_inc_toggle = {come_from[5] & done_waiting_1, come_from[2] & done_waiting_0} | 
        {come_from[3] & ~|(train_0_bottom ^ overflow_line) & ~first_train, come_from[6] & ~|(train_1_bottom ^ overflow_line)};
    assign reset_0 = come_from[1];
    assign reset_1 = come_from[4];
    
    bit_counter_15 bot_edge_0 (.clk(clk), .up_or_down(1'b1), // tracks the bottom edge of trains 1, 3, 5...
        .counter_enable(pos_increment[0] & ~edge_b0 & frame),
        .load_control(reset_0), 
        .Din(15'd0), .value_out(train_0_bottom),
        .up_terminal_count(edge_b0));
    bit_counter_15 bot_edge_1 (.clk(clk), .up_or_down(1'b1), // tracks the bottom edge of trains 2, 4, 6...
        .counter_enable(pos_increment[1] & ~edge_b1 & frame),
        .load_control(reset_1), 
        .Din(15'd0), .value_out(train_1_bottom),
        .up_terminal_count(edge_b1));
        
    bit_counter_15 top_edge_0 (.clk(clk), .up_or_down(1'b1), // tracks the top edge of trains 1, 3, 5...
        .counter_enable(pos_increment[0] & (train_0_bottom > length_0) & ~edge_t0 & frame),
        .load_control(reset_0), 
        .Din(15'd0), .value_out(train_0_top),
        .up_terminal_count(edge_t0));
    bit_counter_15 top_edge_1 (.clk(clk), .up_or_down(1'b1), // tracks the top edge of trains 2, 4, 6...
        .counter_enable(pos_increment[1] & (train_1_bottom > length_1) & ~edge_t1 & frame),
        .load_control(reset_1), 
        .Din(15'd0), .value_out(train_1_top),
        .up_terminal_count(edge_t1));
        
    bit_counter_15 wait_0 (.clk(clk), .up_or_down(1'b0), 
        .counter_enable(come_from[2] & ~done_waiting_0 & frame),
        .load_control(reset_0),
        .Din({8'b0, random_number[6:0]}), .down_terminal_count(done_waiting_0));
    bit_counter_15 wait_1 (.clk(clk), .up_or_down(1'b0), 
        .counter_enable(come_from[5] & ~done_waiting_1 & frame),
        .load_control(reset_1),
        .Din({8'b0, random_number[6:0]}), .down_terminal_count(done_waiting_1));
    
    // sampling length on train frame 1 instead of 0, such that the number doesn't match
    // the one selected for the wait time.
    // this will cause an offset of 1, which is compensated for by adding 59 instead of 60.
    assign length_in_0 = {15{|(train_0_bottom ^ 15'd1)}} & length_0 |
        {15{~|(train_0_bottom ^ 15'd1)}} & ({9'b0, random_number[5:0]} + 15'd59);
    assign length_in_1 = {15{|(train_1_bottom ^ 15'd1)}} & length_0 |
        {15{~|(train_1_bottom ^ 15'd1)}} & ({9'b0, random_number[5:0]} + 15'd59);
   
    FDRE #(.INIT(1'b0)) length_0_store[14:0] (.C({15{clk}}), .R(15'b0), .CE({15{1'b1}}),
        .D(length_in_0),
        .Q(length_0));
    FDRE #(.INIT(1'b0)) length_1_store[14:0] (.C({15{clk}}), .R(15'b0), .CE({15{1'b1}}),
        .D(length_in_1),
        .Q(length_1));
        
    assign scored = ~|(train_0_top ^ slug_height) | ~|(train_1_top ^ slug_height);
    
endmodule