`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2024 11:37:40 AM
// Design Name: 
// Module Name: slug_color_manager
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


module slug_color_manager(
    input hovering,
    input dead,
    input flasher,
    input [11:0] primary, hover, // color parameters
    output [11:0] color_out
    );
    assign color_out = 
        ~hovering & ~dead & primary | 
        hovering & ~dead & hover & flasher | 
        dead & primary & flasher;
endmodule
