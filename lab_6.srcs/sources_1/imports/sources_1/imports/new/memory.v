`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2024 01:49:43 PM
// Design Name: 
// Module Name: sample_memory_cell
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


//module memory_cell(
//    input clk,
//    input d,
//    input mem_enable,
//    output q
//    );
//    wire loop;
//    wire inD;
//    mux_2_way_1_bit mux (.a(loop), .b(d), .s(mem_enable), .out(inD));
//    FDRE #(.INIT(1'b0) ) mem_ff (.C(clk), .R(1'b0), .CE(1'b1), .D(inD), .Q(loop));
//    assign q = loop;
//endmodule

module mux_2_way_1_bit(
    input a, b,
    input s,
    output out
);
    assign out = ~s & a | s & b;
endmodule

module mux_2_way_16_bit(
    input [15:0] a, [15:0] b,
    input s,
    output [15:0] out
);
    assign out[15:0] = ({16{~s}} & a) | ({16{s}} & b);
endmodule

module mux_2_way_8_bit(
    input [7:0] a, [7:0] b,
    input s,
    output [7:0] out
);
    assign out[7:0] = ({~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s} & a) | ({s, s, s, s, s, s, s, s} & b);
endmodule

module mux_4_way_4_bit(
    input [3:0] a, [3:0] b, [3:0] c, [3:0] d,
    input s, t,
    output [3:0] out
);
    assign out[3:0] = ({4{~s & ~t}} & a) | 
        ({4{~s & t}} & b) | ({4{s & ~t}} & c) | ({4{s & t}} & d);
endmodule

module mux_2_way_5_bit(
    input [4:0] a, [4:0] b,
    input s,
    output [4:0] out
);
    assign out[4:0] = ({5{~s}} & a) | ({5{s}} & b);
endmodule

module mux_2_way_12_bit(
    input [11:0] a, [11:0] b,
    input s,
    output [11:0] out
);
    assign out[11:0] = ({12{~s}} & a) | ({12{s}} & b);
endmodule