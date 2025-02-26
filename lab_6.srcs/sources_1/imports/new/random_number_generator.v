`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2024 01:46:53 PM
// Design Name: 
// Module Name: random_number_generator
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


module random_number_generator (
    input clk,
    input run,
    output [7:0] random_number
    );
    wire [7:0] rand_in;
    //wire [7:0] rand_processed;
    wire [7:0] rand_out;
    wire rand_xord;
    
    FDRE #(.INIT(8'b1)) rand_ff[7:0] (.C({8{clk}}), .R(8'b0), .CE({8{run}}), .D(rand_in[7:0]), .Q(rand_out[7:0]));
    
    assign rand_xord = rand_out[0] ^ rand_out[5] ^ rand_out[6] ^ rand_out[7];
    assign rand_in = {rand_out[6:0], rand_xord};
    
    assign random_number[7:0] = rand_out[7:0];
endmodule
