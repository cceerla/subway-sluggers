`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2024 01:33:23 PM
// Design Name: 
// Module Name: slug_fsm
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


module slug_fsm(
    input clk,
    input stop_all, can_hover, start_slug,
    input btnR, btnL, btnU,
    input right_lane, left_lane, center_lane,
    output is_hovering, hover_reduce, go_left, go_right,
    output [8:0] state
    );
    // one-hot encoding
    wire [8:0] go_to;
    wire [8:0] come_from;
    // STATE MACHINE FLIP FLOPS
    FDRE #(.INIT(1'b1)) q0_ff (.C(clk), .R(1'b0), .CE(1'b1), .D(go_to[0]), .Q(come_from[0]));
    FDRE #(.INIT(5'b0)) q1_8_ff[8:1] (.C({8{clk}}), .R(8'b0), .CE({8{1'b1}}), .D(go_to[8:1]), .Q(come_from[8:1]));
    // states:
    // 0: still
    // 1: in center lane
    // 2: in left lane
    // 3: in right lane
    // 4: shifting c->l
    // 5: shifting l->c
    // 6: shifting c->r
    // 7: shifting r->c
    // 8: hover
    
    assign go_to[0] = stop_all | come_from[0] & ~start_slug;
    assign go_to[1] = ~stop_all & (come_from[0] & start_slug | 
        come_from[5] & center_lane | come_from[7] & center_lane | 
        come_from[8] & (~can_hover | ~btnU) | come_from[1] & ~btnL & ~btnR & ~btnU | 
        come_from[1] & ~btnL & ~btnR & ~can_hover);
    assign go_to[2] = ~stop_all & (come_from[4] & left_lane | come_from[2] & ~btnR);
    assign go_to[3] = ~stop_all & (come_from[6] & right_lane | come_from[3] & ~btnL);
    assign go_to[4] = ~stop_all & (come_from[1] & btnL | come_from[4] & ~left_lane);
    assign go_to[5] = ~stop_all & (come_from[2] & btnR | come_from[5] & ~center_lane);
    assign go_to[6] = ~stop_all & (come_from[1] & btnR | come_from[6] & ~right_lane);
    assign go_to[7] = ~stop_all & (come_from[3] & btnL | come_from[7] & ~center_lane);
    assign go_to[8] = ~stop_all & (come_from[1] & btnU & can_hover | come_from[8] & btnU & can_hover);
    assign is_hovering = come_from[8];
    assign hover_reduce = come_from[8] | come_from[1] & btnU;
    assign go_left = come_from[4] | come_from[7];
    assign go_right = come_from[5] | come_from[6];
    
endmodule
