`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2024 01:33:23 PM
// Design Name: 
// Module Name: lab_6
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


module lab_6(
    input clkin,
    input [15:0] async_sw,
    input async_btnU, async_btnL, async_btnR, async_btnC, async_btnD,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp,
    output Hsync, Vsync,
    output [3:0] vgaRed, vgaBlue, vgaGreen
    );
    //synchronizer
    wire btnU; // hover
    wire btnL; // move left
    wire btnR; // move right
    wire btnC; // start game
    wire btnC_edge;
    wire btnD; // reset
    wire [15:0] sw; // settings
    wire clk;
    wire qSec; // for the quarter-second inputs
    wire digsel;
    wire booting; // on startup, 1 cycle
    wire zero;
    wire frame;
    assign zero = 1'b0;
    synchronizer_21 sync (.clk(clk), .async({async_btnU, async_btnL, async_btnR, async_btnC, async_btnD, async_sw[15:0]}),
        .sync({btnU, btnL, btnR, btnC, btnD, sw[15:0]}));
    init initializer (.clk(clk), .booting(booting));
    labVGA_clks vga_clock (.clkin(clkin), .greset(async_btnD), .clk(clk), .digsel(digsel));
    edge_detector frame_det (.clk(clk), .feed(Vsync), .detected(frame)); // frame pulse when new frame: vsync
    edge_detector btnC_start (.clk(clk), .feed(btnC), .detected(btnC_edge));
    
    //game logic
    wire [7:0] random_number;
    wire [14:0] hover_health;
    wire can_hover, hovering;
    wire invincible;
    wire [14:0] hover_top;
    wire [14:0] train_0_bottom, train_0_top, train_1_bottom, train_1_top;
    wire [14:0] train_2_bottom, train_2_top, train_3_bottom, train_3_top;
    wire [14:0] train_4_bottom, train_4_top, train_5_bottom, train_5_top;
    wire [14:0] wait_out_0;
    wire [14:0] slug_position;
    wire sl_go_right, sl_go_left;
    wire in_left_lane, in_right_lane, in_center_lane;
    wire two_sec, six_sec, qsec;
    wire collision;
    wire start_slug, reset_timer, game_over;
    wire open_tr_c, open_tr_l, open_tr_r;
    wire flasher;
    wire [8:0] state;
    wire scored_0, scored_1, scored_2;
    wire hover_reduce;
    
    // UI AND HOUSEKEEPING
    random_number_generator rand (.clk(clk), .run(1'b1), .random_number(random_number));
    
    hover_bar hover_manager (.clk(clk), .hovering(hover_reduce),
        .frame(frame), .booting(booting),
        .hover_health(hover_health), .can_hover(can_hover));
        
    timer time_counter (
        .clk(clk),
        .frame(frame),
        .timer_reset(reset_timer),
        .two_sec(two_sec), .six_sec(six_sec),
        .flasher(flasher));
        
    assign hover_top = 139 + hover_health;
    
    // BRAIN
    game_fsm brain (.clk(clk),
        .btnC(btnC), .two_sec(two_sec), .six_sec(six_sec), .collision(collision),
        .start_slug(start_slug), .reset_timer(reset_timer), .stop_all(game_over),
        .open_center(open_tr_c), .open_left(open_tr_l), .open_right(open_tr_r));
    
    // TRAINS
    train_fsm left_track (.clk(clk), .start_track(open_tr_l),
        .frame(frame), .freeze_trains(game_over),
        .random_number(random_number),
        .overflow_line(15'd400),
        .slug_height(15'd376),
        .train_0_bottom(train_0_bottom), .train_0_top(train_0_top),
        .train_1_bottom(train_1_bottom), .train_1_top(train_1_top),
        .scored(scored_0));
    train_fsm right_track (.clk(clk), .start_track(open_tr_r),
        .frame(frame), .freeze_trains(game_over),
        .random_number(random_number),
        .overflow_line(15'd400),
        .slug_height(15'd376),
        .train_0_bottom(train_2_bottom), .train_0_top(train_2_top),
        .train_1_bottom(train_3_bottom), .train_1_top(train_3_top),
        .scored(scored_1));
    train_fsm center_track (.clk(clk), .start_track(open_tr_c),
        .frame(frame), .freeze_trains(game_over),
        .random_number(random_number),
        .overflow_line(15'd440),
        .slug_height(15'd376),
        .train_0_bottom(train_4_bottom), .train_0_top(train_4_top),
        .train_1_bottom(train_5_bottom), .train_1_top(train_5_top),
        .scored(scored_2));
    
    // SLUG STUFF
    slug_pos_manager slug_x (.clk(clk), .frame(frame),
        .ll_pos(15'd242), .cl_pos(15'd312), .rl_pos(15'd382),
        .booting(booting),
        .go_right(sl_go_right), .go_left(sl_go_left),
        .position(slug_position),
        .left_lane(in_left_lane), .right_lane(in_right_lane), .center_lane(in_center_lane));
    slug_fsm slug_doing (.clk(clk),
        .stop_all(game_over), .can_hover(can_hover), .start_slug(start_slug),
        .btnR(btnR), .btnL(btnL), .btnU(btnU),
        .left_lane(in_left_lane), .right_lane(in_right_lane), .center_lane(in_center_lane),
        .is_hovering(hovering), .hover_reduce(hover_reduce), .go_left(sl_go_left), .go_right(sl_go_right),
        .state(state));
    

    
    wire [14:0] pixel_h, pixel_v;
    wire [12:0] ui_layer, train_layer, slug_layer;
    wire [12:0] ui_0, ui_1, ui_2, ui_3, ui_4; //bg4 is hp bar
    wire [12:0] tr_0, tr_1, tr_2, tr_3, tr_4, tr_5;
    wire [12:0] sl_0;
    wire [11:0] col_trxsl; // color trains x (cross) slug , col_slxui (if a fourth layer is added?)
    wire [11:0] current_color;
    wire [15:0] display_number;
    wire [3:0] display_ring;
    wire [3:0] display_digit;
    
    // UI LAYER
    rect bord_top (.x0(15'd1),   .y0(15'd0),   .x1(15'd639), .y1(15'd7),   
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'hfff), .color_out(ui_0)); // top edge
    rect bord_lef (.x0(15'd0),   .y0(15'd8),   .x1(15'd7),   .y1(15'd479), 
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'hfff), .color_out(ui_1)); // left
    rect bord_rig (.x0(15'd632), .y0(15'd8),   .x1(15'd639), .y1(15'd479), 
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'hfff), .color_out(ui_2)); // right
    rect bord_bot (.x0(15'd8),   .y0(15'd472), .x1(15'd639), .y1(15'd479), 
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'hfff), .color_out(ui_3)); // bottom
    
    rect hover_bar_disp (.x0(15'd15),   .y0(hover_top), .x1(15'd35), .y1(15'd330), 
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'h3f2), .color_out(ui_4)); // hover bar
    
    // SLUG LAYER
    wire [11:0] slug_color;
//    slug_color_manager col_manager (.hovering(hovering), .dead(game_over),
//        .flasher(flasher), .primary(12'hfd5), .hover(12'he35),
//        .color_out(slug_color));
    assign slug_color = 
        {12{~hovering}} & {12{~game_over}} & 12'hfd5 | 
        {12{hovering}} & {12{~game_over}} & 12'hf35 & {12{flasher}} | 
        {12{game_over}} & 12'hfd5 & {12{flasher}};
    
    rect player (.x0(slug_position), .x1(slug_position + 15'd15), .y0(15'd360), .y1(15'd375),
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(slug_color), .color_out(sl_0));
    
//     TRAINS LAYER
    rect train_0 (.x0(15'd220), .x1(15'd279), .y0(train_0_top), .y1(train_0_bottom),
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'h27f), .color_out(tr_0));
    rect train_1 (.x0(15'd220), .x1(15'd279), .y0(train_1_top), .y1(train_1_bottom),
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'h27f), .color_out(tr_1));
    rect train_2 (.x0(15'd360), .x1(15'd419), .y0(train_2_top), .y1(train_2_bottom),
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'h27f), .color_out(tr_2));
    rect train_3 (.x0(15'd360), .x1(15'd419), .y0(train_3_top), .y1(train_3_bottom),
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'h27f), .color_out(tr_3));
    rect train_4 (.x0(15'd290), .x1(15'd349), .y0(train_4_top), .y1(train_4_bottom),
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'h27f), .color_out(tr_4));
    rect train_5 (.x0(15'd290), .x1(15'd349), .y0(train_5_top), .y1(train_5_bottom),
        .pixel_h(pixel_h), .pixel_v(pixel_v), .color_in(12'h27f), .color_out(tr_5));
    
    assign ui_layer = ui_0 | ui_1 | ui_2 | ui_3 | ui_4; // really more of a ui layer, lets be honest
    assign train_layer = tr_0 | tr_1 | tr_2 | tr_3 | tr_4 | tr_5;
    assign slug_layer = sl_0; // redundant now, future proofing in case i need more colors
    
    mux_2_way_12_bit trxsl_mux (.a(train_layer[11:0]), .b(slug_layer[11:0]), .s(slug_layer[12]), .out(col_trxsl));
    mux_2_way_12_bit slxui_mux (.a(col_trxsl[11:0]), .b(ui_layer[11:0]), .s(ui_layer[12]), .out(current_color));
    //assign current_color = color_posttrains;
    
    assign collision = train_layer[12] & slug_layer[12] & ~invincible & ~hovering;
    
    vga_display display (
        .clk(clk), .color(current_color),
        .pixel_h(pixel_h), .pixel_v(pixel_v),
        .hsync(Hsync), .vsync(Vsync),
        .vgaR(vgaRed), .vgaB(vgaBlue), .vgaG(vgaGreen));
        //assign led[0] = ~Hsync;
        //assign led[12:1] = pixel_v;
        //assign led[13] = clk;
        assign led[15] = ~can_hover;
        assign led[14] = hovering;
        assign led[13] = collision;
        //assign led[12:8] = state;
        assign led[12:4] = state;
        assign led[3] = flasher;
        //assign led[14:0] = wait_out_0;
        assign invincible = sw[3];
        
    //assign display_number = ;
     bit_counter_15 score (.clk(clk), .up_or_down(1'b1),
          .counter_enable((scored_0 | scored_1 | scored_2) & frame), .load_control(booting), .Din(15'd0),
          .value_out(display_number));
    ring_counter an_selector (.clk(clk), .ring(display_ring), .advance(digsel));
    assign an = ~display_ring;
    selector digit_select (.bin(display_number), .selector(display_ring), .highlight(display_digit));
    hex_7_seg num_display (.bin(display_digit), .segment(seg));
    assign dp = 1'b1;
endmodule
