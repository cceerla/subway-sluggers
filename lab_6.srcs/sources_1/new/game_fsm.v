`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2024 01:33:23 PM
// Design Name: 
// Module Name: game_fsm
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


module game_fsm(
    input clk,
    input btnC, two_sec, six_sec, collision,
    output start_slug, reset_timer, stop_all,
    output open_center, open_left, open_right,
    output [4:0] state
    );
    // one-hot encoding
    wire [4:0] go_to;
    wire [4:0] come_from;
    // STATE MACHINE FLIP FLOPS
    FDRE #(.INIT(1'b1)) q0_ff (.C(clk), .R(1'b0), .CE(1'b1), .D(go_to[0]), .Q(come_from[0]));
    FDRE #(.INIT(4'b0)) q1_4_ff[4:1] (.C({4{clk}}), .R(4'b0), .CE({4{1'b1}}), .D(go_to[4:1]), .Q(come_from[4:1]));
    // states:
    // 0: start screen
    // 1: left track open
    // 2: right track open
    // 3: playing game
    // 4: game over

    assign go_to[0] = ~collision & (come_from[0] & ~btnC);
    assign go_to[1] = ~collision & (come_from[0] & btnC | come_from[1] & ~two_sec);
    assign go_to[2] = ~collision & (come_from[1] & two_sec | come_from[2] & ~six_sec);
    assign go_to[3] = ~collision & (come_from[2] & six_sec | come_from[3]);
    assign go_to[4] = collision | come_from[4];
    
    assign start_slug = go_to[1] & come_from[0];
    assign reset_timer = go_to[1] & come_from[0] | go_to[2] & come_from[1];
    assign stop_all = come_from[4];
    assign open_center = come_from[3];
    assign open_left = come_from[1];
    assign open_right = come_from[2];
    assign state = come_from;
endmodule
