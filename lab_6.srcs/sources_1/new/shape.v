`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2024 02:48:41 PM
// Design Name: 
// Module Name: shape
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


module rect(
    input [14:0] x0, y0, x1, y1,
    input [14:0] pixel_h, pixel_v,
    input [11:0] color_in,
    output [12:0] color_out
    );
    wire inside_shape;
    assign inside_shape =
        pixel_h >= x0 & pixel_h <= x1 &
        pixel_v >= y0 & pixel_v <= y1;
    assign color_out[11:0] = color_in & {12{inside_shape}};
    assign color_out[12] = inside_shape;
endmodule
