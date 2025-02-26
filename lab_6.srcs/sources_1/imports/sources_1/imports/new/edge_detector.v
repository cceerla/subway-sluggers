`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2024 12:49:03 PM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
    input clk,
    input feed,
    output detected
);
    // module that detects if an input changes from 0 to 1
    // first, check for 0
    // if 0, listen for 1
    // produce true if 1 detected
    // research needed to discern if this requires the setting of a flag
    wire a;
    wire b;
    wire ground;
    
    //feed goes in
    FDRE #(.INIT(1'b0)) ff_a (.C(clk), .R(1'b0), .CE(1'b1), .D(feed), .Q(a));
    // wire a in between
    FDRE #(.INIT(1'b0)) ff_b (.C(clk), .R(1'b0), .CE(1'b1), .D(a), .Q(b));
    // wire b goes out
    assign detected = ~a & b;
endmodule
