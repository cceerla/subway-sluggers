module selector(
    input [15:0] bin,
    input [3:0] selector,
    output [3:0] highlight //outputs a number corresponding to a digit to be rendered
);
    // module that works with hex_7_seg
    // outputs one of the four inputs based off of a ring counter
    // 15:12 when sel = 1000
    // 11: 8 when sel = 0100
    //  7: 4 when sel = 0010
    //  3: 0 when sel = 0001
    //assign highlight = bin[3:0] & {selector[3], selector[3], selector[3], selector[3]};
    assign highlight = (bin[15:12] & {4{selector[3]}}) | 
    (bin[11:8] & {4{selector[2]}}) | 
    (bin[7:4] & {4{selector[1]}}) | 
    (bin[3:0] & {4{selector[0]}});
endmodule