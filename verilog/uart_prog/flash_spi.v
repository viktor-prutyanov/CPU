module flash_spi
(
    input CLK,

    output FLASH_CLK, 
    output reg FLASH_CS, FLASH_DI,
    
    input [7:0]DATA2,
    output NEW_DATA2,

    input [2:0]MODE
);

assign FLASH_CLK = CLK & ~FLASH_CS;
initial FLASH_CS = 1'b1;

wire [23:0]address = 24'b0;
wire [7:0]we = 8'h06; //Write Enable instruction
wire [7:0]se = 8'h20; //Sector Erase instruction
wire [7:0]pb = 8'h02; //Program Byte instruction

reg [31:0]bit_cnt = 32'b1000;
reg [7:0]byte_cnt = 8'b0;
reg [3:0]state = 4'b0;

assign NEW_DATA2 = ((MODE == 3'b010) | (MODE == 3'b110)) & (bit_cnt == 32'b1000) & (state == 4'b1001) & CLK;

always @(negedge CLK) begin
    case (MODE)
        3'b110: begin //Erase & Program
            case (state)
                4'b0: begin
                    FLASH_CS = 1'b0;
                    bit_cnt = bit_cnt - 32'b1;
                    FLASH_DI = we[bit_cnt[2:0]];
                    if (bit_cnt == 32'b0) begin
                        bit_cnt = 32'b1000;
                        state = 4'b1;
                    end
                end
                4'b1: begin
                    FLASH_CS = 1'b1;
                    bit_cnt = bit_cnt - 32'b1;
                    if (bit_cnt == 32'b0) begin
                        bit_cnt = 32'b1000;
                        state = 4'b10;
                    end
                end
                4'b10: begin
                    FLASH_CS = 1'b0;
                    bit_cnt = bit_cnt - 32'b1;
                    FLASH_DI = se[bit_cnt[2:0]];
                    if (bit_cnt == 32'b0) begin
                        bit_cnt = 32'b11000;
                        state = 4'b11;
                    end
                end
                4'b11: begin
                    FLASH_CS = 1'b0;
                    bit_cnt = bit_cnt - 32'b1;
                    FLASH_DI = address[bit_cnt[4:0]];
                    if (bit_cnt == 32'b0) begin
                        bit_cnt = 32'd19_200_000; //400ms * 48MHz
                        state = 4'b100;
                    end
                end
                4'b100: begin
                    FLASH_CS = 1'b1;
                    bit_cnt = bit_cnt - 32'b1;
                    if (bit_cnt == 32'b0) begin
                        bit_cnt = 32'b1000;
                        state = 4'b101;
                    end
                end
                4'b101: begin
                    FLASH_CS = 1'b0;
                    bit_cnt = bit_cnt - 32'b1;
                    FLASH_DI = we[bit_cnt[2:0]];
                    if (bit_cnt == 32'b0) begin
                        bit_cnt = 32'b1000;
                        state = 4'b110;
                    end
                end
                4'b110: begin
                    FLASH_CS = 1'b1;
                    bit_cnt = bit_cnt - 32'b1;
                    if (bit_cnt == 32'b0) begin
                        bit_cnt = 32'b1000;
                        state = 4'b111;
                    end
                end
                4'b111: begin
                    FLASH_CS = 1'b0;
                    bit_cnt = bit_cnt - 32'b1;
                    FLASH_DI = pb[bit_cnt[2:0]];
                    if (bit_cnt == 32'b0) begin
                        bit_cnt = 32'b11000;
                        state = 4'b1000;
                    end
                end
                4'b1000: begin
                    FLASH_CS = 1'b0;
                    bit_cnt = bit_cnt - 32'b1;
                    FLASH_DI = address[bit_cnt[4:0]];
                    if (bit_cnt == 32'b0) begin
                        bit_cnt = 32'b1000;
                        state = 4'b1001;
                    end
                end
                4'b1001: begin
                    FLASH_CS = 1'b0;
                    bit_cnt = bit_cnt - 32'b1;
                    FLASH_DI = DATA2[bit_cnt[2:0]];
                    if (bit_cnt == 32'b0) begin
                        bit_cnt = 32'b1000;
                        byte_cnt = byte_cnt + 8'b1;
                        if (byte_cnt == 8'b0) begin
                            state = 4'b1111;
                        end
                    end
                end
                4'b1111: begin
                    FLASH_CS = 1'b1;
                    bit_cnt = 32'b1000;
                    byte_cnt = 8'b0;
                end
            endcase
        end
    endcase
end

endmodule