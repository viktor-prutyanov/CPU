module top
(
    input CLK,
    
    output DS_EN1, DS_EN2, DS_EN3, DS_EN4,
    output DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G,

    output D_EN1, D_EN2, D_EN3, D_EN4, output [7:0]LED,

    output FLASH_CLK, FLASH_CS, FLASH_DI,
    input FLASH_DO
);

//Two 7 segment (total 4 bytes) indicators  

wire [15:0]num_l;
segment_led segment_led0(
    .CLK(CLK),
    .DS_EN1(DS_EN1), .DS_EN2(DS_EN2), .DS_EN3(DS_EN3), .DS_EN4(DS_EN4),
    .DS_A(DS_A), .DS_B(DS_B), .DS_C(DS_C), .DS_D(DS_D), .DS_E(DS_E), .DS_F(DS_F), .DS_G(DS_G),
    .NUM(num_l)
);

wire [15:0]num_h;
segment_led segment_led1(
    .CLK(CLK),
    .DS_EN1(D_EN1), .DS_EN2(D_EN2), .DS_EN3(D_EN3), .DS_EN4(D_EN4),
    .DS_A(LED[0]), .DS_B(LED[1]), .DS_C(LED[2]), .DS_D(LED[3]), .DS_E(LED[4]), .DS_F(LED[5]), .DS_G(LED[6]),
    .NUM(num_h)
);

//W25Q32BV flash memory 

wire flash_new_data1;
wire [15:0]flash_data1;
wire flash_idle;
flash_spi flash_spi0(
    .CLK(CLK),
    .FLASH_CLK(FLASH_CLK), .FLASH_CS(FLASH_CS), .FLASH_DI(FLASH_DI), .FLASH_DO(FLASH_DO),
    .NEW_DATA1(flash_new_data1),
    .DATA1(flash_data1),
    .IDLE(flash_idle)
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
    .OUT({num_h, num_l}),
    .RAM_ADDR(ram_addr),
    .RAM_WREN(ram_wren),
    .RAM_Q(ram_q),
    .RAM_DATA(ram_data),
    .FLASH_NEW_DATA1(flash_new_data1),
    .FLASH_DATA1(flash_data1),
    .FLASH_IDLE(flash_idle),
    .END(LED[7])
);

endmodule