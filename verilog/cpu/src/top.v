module top
(
    input CLK,
    
    output DS_EN1, DS_EN2, DS_EN3, DS_EN4,
    output DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G
);

//Two 7 segment (total 4 bytes) indicators  

wire [15:0]num_l;
segment_led segment_led0(
    .CLK(CLK),
    .DS_EN1(DS_EN1), .DS_EN2(DS_EN2), .DS_EN3(DS_EN3), .DS_EN4(DS_EN4),
    .DS_A(DS_A), .DS_B(DS_B), .DS_C(DS_C), .DS_D(DS_D), .DS_E(DS_E), .DS_F(DS_F), .DS_G(DS_G),
    .NUM(num_l)
);

wire [11:0]ram_addr;
wire [15:0]ram_data;
wire ram_wren;
wire [15:0]ram_q;
ram ram_inst(
    .address(ram_addr),
    .clock(~CLK),
    .data(ram_data),
    .wren(ram_wren),
    .q(ram_q)
);

core core_inst(
    .CLK(CLK),
    .OUT(num_l),
    .RAM_ADDR(ram_addr),
    .RAM_WREN(ram_wren),
    .RAM_Q(ram_q),
    .RAM_DATA(ram_data)
);

endmodule