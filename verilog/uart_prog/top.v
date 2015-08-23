module top
(
    input CLK,

    input TXD,

    output DS_EN1, DS_EN2, DS_EN3, DS_EN4,
    output DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G,

    output FLASH_CLK, FLASH_CS, FLASH_DI
);

wire [15:0]num;
assign num[7:0] = uart_tx_data;
assign num[15:8] = byte_cnt;
segment_led segment_led1(
    .CLK(CLK),
    .DS_EN1(DS_EN1), .DS_EN2(DS_EN2), .DS_EN3(DS_EN3), .DS_EN4(DS_EN4),
    .DS_A(DS_A), .DS_B(DS_B), .DS_C(DS_C), .DS_D(DS_D), .DS_E(DS_E), .DS_F(DS_F), .DS_G(DS_G),
    .NUM(num) 
);

wire [2:0]flash_mode;
assign flash_mode = mode;
wire [7:0]flash_data2;
assign flash_data2 = record_buffer;
wire flash_new_data2;
reg [7:0]record_buffer = 8'b00;
flash_spi flash_spi1(
    .CLK(CLK),
    .FLASH_CLK(FLASH_CLK), .FLASH_CS(FLASH_CS), .FLASH_DI(FLASH_DI),
    .MODE(flash_mode),
    .DATA2(flash_data2),
    .NEW_DATA2(flash_new_data2)
);

wire [7:0]uart_tx_data;
wire uart_tx_idle;
uart_tx uart_tx1(
    .CLK(CLK),
    .TXD(TXD),
    .DATA(uart_tx_data),
    .IDLE(uart_tx_idle)
);

reg [2:0]mode = 3'b0;
reg [7:0]mem[255:0];
reg [1:0]record_state = 3'b0;
reg [7:0]byte_cnt = 8'b0;
wire record_clk;
assign record_clk = ((uart_tx_idle & (record_state == 3'b0 | record_state == 3'b1)) | (flash_new_data2));

always @(posedge record_clk) begin
    case (record_state)
        2'b00: begin 
            record_state = 2'b01;
        end
        2'b01: begin
            mem[byte_cnt] = uart_tx_data;
            byte_cnt = byte_cnt + 8'b1;
            if (byte_cnt == 8'b0) begin
                record_state = 2'b10;
                mode = 3'b110;      
            end
        end
        2'b10: begin
            record_buffer = mem[byte_cnt];
            byte_cnt = byte_cnt + 8'b1;
            if (byte_cnt == 8'b0) begin
                record_state = 2'b11;
            end
        end
        2'b11: begin 
            record_buffer = 8'hCC;
        end
    endcase
end

endmodule
