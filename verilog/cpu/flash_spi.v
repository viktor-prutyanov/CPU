module flash_spi
(
    input CLK,

    output FLASH_CLK, 
    output reg FLASH_CS, FLASH_DI,
    input FLASH_DO,

    output reg [15:0]DATA1,
    output reg NEW_DATA1,

    output reg IDLE
);

assign FLASH_CLK = CLK & ~FLASH_CS;
initial DATA1 = 16'b0;
initial NEW_DATA1 = 1'b0;
initial FLASH_CS = 1'b1;

wire [23:0]address = 24'b0;
wire [7:0]rb = 8'h03; //Read Byte instruction

reg [4:0]bit_cnt = 5'b1000;
reg [6:0]sample_cnt = 7'b0;
reg [2:0]state = 3'b0;

always @(negedge CLK) begin //Read 256 byte
    case (state)
        3'b0: begin    
            FLASH_CS <= 1'b0;
            bit_cnt = bit_cnt - 5'b1;
            FLASH_DI <= rb[bit_cnt[2:0]];
            if (bit_cnt == 5'b0) begin
                bit_cnt = 5'b11000;
                state <= 3'b1;
            end
        end
        3'b1: begin
            bit_cnt = bit_cnt - 5'b1;
            FLASH_DI <= address[bit_cnt[4:0]];
            if (bit_cnt == 5'b0) begin
                state <= 3'b10;
            end
        end
        3'b10: begin
            state <= 3'b11;
        end
        3'b11: begin
            NEW_DATA1 <= 1'b0;
            bit_cnt[3:0] = bit_cnt[3:0] - 4'b1;
            DATA1[bit_cnt[3:0]] <= FLASH_DO;
            if (bit_cnt[3:0] == 4'b0) begin
                NEW_DATA1 <= 1'b1;
                sample_cnt = sample_cnt + 7'b1;
                if (sample_cnt == 7'b0) begin
                    state <= 3'b100;
                end
            end
        end
        3'b100: begin
            IDLE <= 1'b1;
            NEW_DATA1 <= 1'b0;
            FLASH_CS <= 1'b1;
        end
    endcase 
end

endmodule