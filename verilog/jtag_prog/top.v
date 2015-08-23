module top
(
    input CLK,

    output DS_EN1, DS_EN2, DS_EN3, DS_EN4,
    output DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G,

    output FLASH_CLK, FLASH_CS, FLASH_DI
);

wire [15:0]num;
//assign num[7:0] = uart_tx_data;
assign num[15:8] = byte_cnt;
segment_led segment_led1(
    .CLK(CLK),
    .DS_EN1(DS_EN1), .DS_EN2(DS_EN2), .DS_EN3(DS_EN3), .DS_EN4(DS_EN4),
    .DS_A(DS_A), .DS_B(DS_B), .DS_C(DS_C), .DS_D(DS_D), .DS_E(DS_E), .DS_F(DS_F), .DS_G(DS_G),
    .NUM(num) 
);

wire [2:0]flash_mode = 3'b110;
wire [7:0]flash_data2 = record_buffer;
wire flash_new_data2;
reg [7:0]record_buffer = 8'b00;
flash_spi flash_spi1(
    .CLK(CLK),
    .FLASH_CLK(FLASH_CLK), .FLASH_CS(FLASH_CS), .FLASH_DI(FLASH_DI),
    .MODE(flash_mode),
    .DATA2(flash_data2),
    .NEW_DATA2(flash_new_data2)
);

reg [6:0]rom_address = 7'b0;
wire [6:0]address_sig = rom_address;
wire [15:0]rom_q;
rom rom1(
    .address(address_sig),
    .clock(CLK),
    .q(rom_q)
);

reg [0:0]record_state = 1'b0;
reg [7:0]byte_cnt = 8'b0;
always @(posedge flash_new_data2) begin
    case (record_state)
        1'b0: begin
            case (byte_cnt[0])
            1'b0:
                record_buffer = rom_q[15:8];
            1'b1:
                record_buffer = rom_q[7:0];
            endcase
            byte_cnt = byte_cnt + 8'b1;
            rom_address = byte_cnt[7:1];
            if (byte_cnt == 8'b0) begin
                record_state = 1'b1;
            end
        end
        1'b1: begin 
            record_buffer = 8'hCC;
        end
    endcase
end

endmodule
