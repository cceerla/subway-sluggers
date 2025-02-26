`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2024 05:19:49 PM
// Design Name: 
// Module Name: synchronizer
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


module synchronizer_21(
    input clk,
    input [20:0] async,
    output [20:0] sync
    );
    FDRE #(.INIT(1'b0)) synchronizer_ffs[20:0] (.C({21{clk}}), .R(21'b0), .CE({21{1'b1}}),
        .D(async[20:0]), .Q(sync[20:0]));
endmodule
