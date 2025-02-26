`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2024 05:27:27 PM
// Design Name: 
// Module Name: slug_pos_manager
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


module slug_pos_manager(
    input clk,
    input frame,
    input [14:0] ll_pos, cl_pos, rl_pos, // cl_pos=312
    input booting,
    input go_left, go_right,
    output [14:0] position,
    output left_lane, center_lane, right_lane
    );
    wire moving;
    wire left_or_right;
    wire frame_2;
    
    // 2 frame inputs per frame. for that 2 pixels per frame movement LMAO
    FDRE #(.INIT(1'b1)) frame_duper (.C(clk), .R(1'b0), .CE(1'b1), .D(frame), .Q(frame_2));
    
    bit_counter_15 position_counter (.clk(clk), .up_or_down(left_or_right),
        .counter_enable(moving & (frame | frame_2)), .load_control(booting),
            .Din(cl_pos), .value_out(position));
    // right -> up
    assign left_or_right = go_right;
    assign moving = go_left | go_right;
    assign left_lane = ~|(position ^ ll_pos);
    assign center_lane = ~|(position ^ cl_pos);
    assign right_lane = ~|(position ^ rl_pos);
    
endmodule
