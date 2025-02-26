module bit_counter_15(
    input clk,
    input up_or_down,   // ud in assignment doc, selects whether incrementing
                        // or decrementing when button pushed
    input counter_enable, // start incrementing
    input load_control,
    input [14:0] Din,
    
    output [14:0] value_out,
    output up_terminal_count,   // 1 when counter is 5'b11111
    output down_terminal_count  // 1 when counter is 5'b00000
);
    // template:
    // bit_counter_15 counter (.clk(clk), .up_or_down(),
    //      .counter_enable(), .load_control(), .Din(),
    //      .value_out(), .up_terminal_count(), .down_terminal_count());


    wire [4:0] val_out_0;
    wire [4:0] val_out_1;
    wire [4:0] val_out_2;

    wire count_0;
    wire count_1; // connectors for utcs
    wire count_2;
    wire up_0_1; // connectors for utcs
    wire up_1_2;
    wire up_2_0;
    wire down_0_1; // connectors for utcs
    wire down_1_2;
    wire down_2_0;
    // redundant | up_or_down & up_2_0 for readability
    assign count_0 = counter_enable;
        //& (up_or_down & up_2_0 | ~up_or_down & ~down_1_2);
    assign count_1 = counter_enable & (
        up_or_down & up_0_1 | ~up_or_down & (down_2_0));
    assign count_2 = counter_enable & (
        up_or_down & (up_1_2 & up_0_1) | ~up_or_down & (down_0_1 & down_2_0));
    
    
    // 3 5 bit registers
//    bit_counter_5 counter0 (.clk(clk), .up_or_down(up_or_down), .load_control(load_control),
//        .counter_enable(count_0), .Din(Din[4:0]), .value_out(value_out[4:0]),
//        .up_terminal_count(up_0_1), .down_terminal_count(down_2_0));
//    bit_counter_5 counter1 (.clk(clk), .up_or_down(up_or_down), .load_control(load_control),
//        .counter_enable(count_1), .Din(Din[9:4]), .value_out(value_out[9:5]),
//        .up_terminal_count(up_1_2), .down_terminal_count(down_0_1));
//    bit_counter_5 counter2 (.clk(clk), .up_or_down(up_or_down), .load_control(load_control),
//        .counter_enable(count_2), .Din(Din[14:10]), .value_out(value_out[14:10]),
//        .up_terminal_count(up_2_0), .down_terminal_count(down_1_2));
    bit_counter_5 counter0 (.clk(clk), .up_or_down(up_or_down), .load_control(load_control),
        .counter_enable(count_0), .value_in(Din[4:0]), .value_out(val_out_0),
        .up_terminal_count(up_0_1), .down_terminal_count(down_2_0));
    bit_counter_5 counter1 (.clk(clk), .up_or_down(up_or_down), .load_control(load_control),
        .counter_enable(count_1), .value_in(Din[9:5]), .value_out(val_out_1),
        .up_terminal_count(up_1_2), .down_terminal_count(down_0_1));
    bit_counter_5 counter2 (.clk(clk), .up_or_down(up_or_down), .load_control(load_control),
        .counter_enable(count_2), .value_in(Din[14:10]), .value_out(val_out_2),
        .up_terminal_count(up_2_0), .down_terminal_count(down_1_2));
        
        assign value_out = {val_out_2, val_out_1, val_out_0};
        assign up_terminal_count = &value_out;
        assign down_terminal_count = ~|value_out;
endmodule

module bit_counter_5(
    input clk,
    input up_or_down,   // ud in assignment doc, selects whether incrementing
                        // or decrementing when button pushed
    input counter_enable,
    input load_control,
    input [4:0] value_in,
    
    output [4:0] value_out,
    output up_terminal_count,   // 1 when counter is 5'b11111
    output down_terminal_count  // 1 when counter is 5'b00000
);
    // NOTE: up_or_down: 0->dec, 1->inc
    
    // overall code intent:
    // hold +1 and -1 value in wires
    // load the respective one into the register and render when asked to
    // pro tip: this is memory inefficient so you probably shouldn't do this in real life
    
    wire [4:0] register_value_in;
    wire [4:0] register_value_out;
    
    wire [4:0] plus_one;
    wire [4:0] minus_one;
    wire [4:0] processed_number; // added or subtracted, then muxed
    
    wire load_any; // if load_control (loading) or
                     // counter_enable (crementing) is on, we're loading
    
    // module that stores a 5-bit value in a 5-bit register.
        // functionality: storing the value
            // takes feed from Din when asked to write and outputs to register_value.
        bit_register_5 register (.clk(clk), .mem_load(load_any),
            .value_in(register_value_in), .value_out(register_value_out));
        // functionality: incrementing and decrementing the value
        
        // INCREMENTOR
        // this line assigns value_in (next state)'s nth bit to
            // prev state's nth xor the and of all of the bits before it.
            // it essentially checks if all the bits to the right
            // are 1s and flips the bit if that's the case.
            // this goes from left to right, starting with the
            // leading 0 turning into a 1, and
            // progressing to each 1 to the right turning into a 0.
            // if all digits are 1, this would just turn each 1 into
            // a 0, rolling over.
        assign plus_one[4] = register_value_out[4] ^ 
            (register_value_out[3] & register_value_out[2] & 
            register_value_out[1] & register_value_out[0]);
        assign plus_one[3] = register_value_out[3] ^ 
            (register_value_out[2] & register_value_out[1] &
            register_value_out[0]);
        assign plus_one[2] = register_value_out[2] ^ 
            (register_value_out[1] & register_value_out[0]);
        assign plus_one[1] = register_value_out[1] ^ 
            register_value_out[0];
        assign plus_one[0] = ~register_value_out[0]; // adding one ALWAYS flips the far right bit
        
        // DECREMENTOR
        // 
        assign minus_one[4] = register_value_out[4] ^ 
            (~register_value_out[3] & ~register_value_out[2] & 
            ~register_value_out[1] & ~register_value_out[0]);
        assign minus_one[3] = register_value_out[3] ^ 
            (~register_value_out[2] & ~register_value_out[1] &
            ~register_value_out[0]);
        assign minus_one[2] = register_value_out[2] ^ 
            (~register_value_out[1] & ~register_value_out[0]);
        assign minus_one[1] = register_value_out[1] ^ 
            ~register_value_out[0];
        assign minus_one[0] = ~register_value_out[0]; // adding one ALWAYS flips the far right bit
        
        // uses a mux to assign either the plus one value
        // or the minus one value to processed_number
        mux_2_way_5_bit add_or_sub_one (.a(minus_one), .b(plus_one), .s(up_or_down), .out(processed_number));
        // another mux to see if we load in the processed number or the loadIn
        mux_2_way_5_bit math_or_load (.a(processed_number), .b(value_in), .s(load_control), .out(register_value_in));
        // load whichever value was muxed.
        assign load_any = load_control | counter_enable;
        // priority goes (least) btnU +-, btnC +-, load (most)
        // if multiple buttons are held at once
        
        //finally, render + output metadata
        assign value_out = register_value_out;
        assign up_terminal_count = &value_out;
        assign down_terminal_count = ~|value_out;
endmodule

module bit_register_5(
    input clk,
    input mem_load, // 1 if loading new information
    input [4:0] value_in,  // input value
    output [4:0] value_out // output value
);
    wire [4:0] loop;
    wire [4:0] dIn;
    mux_2_way_5_bit load_keep_selector (.a(loop), .b(value_in), .s(mem_load), .out(dIn));
    FDRE #(.INIT(1'b0) ) bit0 (.C(clk), .R(1'b0), .CE(1'b1), .D(dIn[0]), .Q(loop[0]));
    FDRE #(.INIT(1'b0) ) bit1 (.C(clk), .R(1'b0), .CE(1'b1), .D(dIn[1]), .Q(loop[1]));
    FDRE #(.INIT(1'b0) ) bit2 (.C(clk), .R(1'b0), .CE(1'b1), .D(dIn[2]), .Q(loop[2]));
    FDRE #(.INIT(1'b0) ) bit3 (.C(clk), .R(1'b0), .CE(1'b1), .D(dIn[3]), .Q(loop[3]));
    FDRE #(.INIT(1'b0) ) bit4 (.C(clk), .R(1'b0), .CE(1'b1), .D(dIn[4]), .Q(loop[4]));
    assign value_out = loop;
endmodule