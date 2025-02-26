`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2024 03:21:33 PM
// Design Name: 
// Module Name: init
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


module init(
    input clk,
    output booting
    );
    FDRE #(.INIT(1'b1) ) bit0 (.C(clk), .R(1'b0), .CE(1'b1), .D(1'b0), .Q(booting));    
endmodule
