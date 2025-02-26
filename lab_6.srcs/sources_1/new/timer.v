`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2024 01:33:23 PM
// Design Name: 
// Module Name: timer
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


module timer(
    input clk,
    input frame,
    input timer_reset,
    output two_sec, six_sec,
    output flasher
    );
    wire [14:0] frame_counter;
    wire qsec;
    
    bit_counter_15 frames_to_qsec (.clk(clk), .up_or_down(1'b1),
        .counter_enable(frame), .load_control(timer_reset | qsec), .Din(15'b0),
        .value_out(frame_counter));
    assign qsec = ~|(frame_counter ^ 15'd15);
    
    wire upper_edge;
    wire [14:0] ticks;
    bit_counter_15 time_counter (.clk(clk), .up_or_down(1'b1),
         .counter_enable(qsec & ~upper_edge), .load_control(timer_reset), .Din(15'b0),
         .value_out(ticks), .up_terminal_count(upper_edge));
    assign two_sec = ~|(ticks ^ 15'd8);
    assign six_sec = ~|(ticks ^ 15'd24);
    
    // to create the quarter second based flashing to sample from in the hover state
    FDRE #(.INIT(1'b1)) flash_generator (.C(clk), .R(1'b0), .CE(1'b1), .D(flasher ^ qsec), .Q(flasher));
    
endmodule
