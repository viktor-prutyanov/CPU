module top
(
    input CLK,
    
    input KEY1, KEY2, KEY3, KEY4,

    output DS_EN1, DS_EN2, DS_EN3, DS_EN4,
    output DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G,

    output H_SYNC, V_SYNC,
    output [4:0]V_R, 
    output [5:0]V_G, 
    output [4:0]V_B
);

wire [31:0]keys = {28'b0, ~KEY4, ~KEY1, ~KEY2, ~KEY3};

wire [15:0]num_l;
segment_led segment_led0(
    .CLK(CLK),
    .DS_EN1(DS_EN1), .DS_EN2(DS_EN2), .DS_EN3(DS_EN3), .DS_EN4(DS_EN4),
    .DS_A(DS_A), .DS_B(DS_B), .DS_C(DS_C), .DS_D(DS_D), .DS_E(DS_E), .DS_F(DS_F), .DS_G(DS_G),
    .NUM(num_l)
);

wire [11:0]ram_addr;
wire [15:0]ram_data;
wire ram1_wren;
wire [15:0]ram1_q;
ram ram_inst(
    .address(ram_addr),
    .clock(~CLK),
    .data(ram_data),
    .wren(ram1_wren),
    .q(ram1_q)
);

core core_inst(
    .CLK(CLK),
    .OUT(num_l),
    .IN(keys),

    .RAM_ADDR(ram_addr),
    .RAM_WREN(ram_wren),
    .RAM_Q(ram_q),
    .RAM_DATA(ram_data),

    .MEM_SELECT(mem_select)
);

wire ram_wren;
wire [15:0]ram_q;
wire mem_select;
mem_selector mem_selector_inst(
    .WREN(ram_wren), .Q(ram_q),
    .WREN1(ram1_wren), .Q1(ram1_q),
    .WREN2(ram2_wren), .Q2(ram2_q),
    .SELECT(mem_select)
);

wire ram2_wren;
wire [15:0]ram2_q;
gpu_core gpu_core_inst(
    .CLK(CLK),
    .H_SYNC(H_SYNC), .V_SYNC(V_SYNC),
    .V_R(V_R), .V_G(V_G), .V_B(V_B),
    .DATA(ram_data),
    .WREN(ram2_wren),
    .ADDR(ram_addr[8:0]),
    .Q(ram2_q)
);

endmodule