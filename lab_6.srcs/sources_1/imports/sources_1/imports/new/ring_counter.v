module ring_counter(
    input clk,
    input advance,
    output [3:0] ring
);
    wire loop;
    wire aNot;
    wire a;
    wire b;
    wire c;
    //wire [3:0] current_state;
    //wire loop_begin;
    
    // cycles a 1 through the ring on each clock rising edge
    // loop comes in, is inverted
    FDRE #(.INIT(1'b0)) ff_a (.C(clk), .CE(advance), .D(~loop), .Q(aNot));
    assign a = ~aNot;
    // comes out to a, is inverted back to normal
    FDRE #(.INIT(1'b0)) ff_b (.C(clk), .CE(advance), .D(a), .Q(b));
    // wire b
    FDRE #(.INIT(1'b0)) ff_c (.C(clk), .CE(advance), .D(b), .Q(c));
    // wire c
    FDRE #(.INIT(1'b0)) ff_d (.C(clk), .CE(advance), .D(c), .Q(loop));
    // wire loop
    assign ring[0] = a;
    assign ring[1] = b;
    assign ring[2] = c;
    assign ring[3] = loop;
    //mux_2_way_1_bit(.a(), .b(), .s(), .out());
endmodule