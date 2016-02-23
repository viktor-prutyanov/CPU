module gpu_core(
    input CLK,

    output H_SYNC, V_SYNC,
    output [4:0]V_R, 
    output [5:0]V_G, 
    output [4:0]V_B,

    input [15:0]DATA,
    input [8:0]ADDR,
    input WREN,
    output [15:0]Q
);

wire vga_clk;
pll pll_inst(
    .inclk0(CLK),
    .c0(vga_clk)
);

wire [9:0]x_num;
wire [8:0]y_num;
wire num_sync;
vga_sync vga_sync_inst(
    .CLK(vga_clk),
    .H_SYNC(H_SYNC), .V_SYNC(V_SYNC),
    .X_NUM(x_num), .Y_NUM(y_num)
);

// gpu_ram gpu_ram_inst(
//     .data(DATA),
//     .rdaddress(ram_addr),
//     .rdclock(vga_clk),
//     .wraddress(ADDR),
//     .wrclock(CLK),
//     .wren(WREN),
//     .q(ram_q)
// );

wire [15:0]ram_q;
wire [8:0]ram_addr = (x_cell >> 2) + y_cell * 10;
wire wren_b_sig = 1'b0;
wire [15:0]data_b_sig = 16'b0;
gpu_ram gpu_ram_inst(
    .address_a(ADDR),
    .address_b(ram_addr),
    .clock_a(~CLK),
    .clock_b(vga_clk),
    .data_a(DATA),
    .data_b(data_b_sig),
    .wren_a(WREN),
    .wren_b(wren_b_sig),
    .q_a(Q),
    .q_b(ram_q)
);

reg [15:0]RGB;

assign V_R = RGB[15:11];
assign V_G = RGB[10:5];
assign V_B = RGB[4:0];

wire [5:0]x_cell = x_num >> 4;
wire [4:0]y_cell = y_num >> 4;

logic [3:0]color;

always_comb begin
    case (x_cell[1:0])
        2'b00: begin
           color = ram_q[15:12];
        end
        2'b01: begin
           color = ram_q[11:8];         
        end
        2'b10: begin
           color = ram_q[7:4];
        end
        2'b11: begin
           color = ram_q[3:0];         
        end
    endcase
end

always @(posedge vga_clk) begin
    if (&x_num || &y_num) begin
        RGB = 16'b0;
    end
    else begin
        case (color)
            4'b0000: RGB = 16'b11111_111111_11111;
            4'b1010: RGB = 16'b00000_111111_00000;
            4'b1111: RGB = 16'b11111_000000_00000;
            default: RGB = 16'b00000_000000_11111;
        endcase
    end
end

endmodule

// segment_led segment_led_inst(
//     .CLK(CLK),
//     .DS_EN1(DS_EN1), .DS_EN2(DS_EN2), .DS_EN3(DS_EN3), .DS_EN4(DS_EN4),
//     .DS_A(DS_A), .DS_B(DS_B), .DS_C(DS_C), .DS_D(DS_D), .DS_E(DS_E), .DS_F(DS_F), .DS_G(DS_G),
//     .NUM({obj_x, obj_y})
// );

// reg [7:0]obj_x = 20;
// reg [7:0]obj_y = 10;

// reg [21:0]cnt = 22'b0;  
// always @(posedge CLK) begin
//     cnt = cnt + 22'b1;
// end

// always @(posedge cnt[21]) begin
//     if (~KEY1 & (obj_x != X_size - 1))
//         obj_x = obj_x + 1;
//     else if (~KEY2 & |obj_x)
//         obj_x = obj_x - 1;
//     else if (~KEY3 & (obj_y != Y_size - 1))
//         obj_y = obj_y + 1;
//     else if (~KEY4 & |obj_y)
//         obj_y = obj_y - 1;
//     field[obj_x][obj_y] = 1;
// end

// always @(posedge vga_clk) begin
//     if (field[x_cell][y_cell])
//         RGB = 16'b11111_000000_00101;
//     else
//         RGB = 16'b00110_000011_01100;    
// end


// always @(posedge vga_clk) begin
//     if (x_num == 10'h3FF) 
//         RGB = 16'b0;
//     else if ((0 < x_num) && (x_num < 213)) begin
//         if ((0 < y_num) && (y_num < 160))
//             RGB = 16'b11100_000000_00011;
//         else if ((160 < y_num) && (y_num < 320))
//             RGB = 16'b01110_001100_00110;
//         else if ((320 < y_num) && (y_num < 480))
//             RGB = 16'b00110_000011_01100;
//     end
//     else if ((213 < x_num) && (x_num < 416)) begin
//         if ((0 < y_num) && (y_num < 160))
//             RGB = 16'b00111_001111_00111;
//         else if ((160 < y_num) && (y_num < 320))
//             RGB = 16'b10111_100111_00011;
//         else if ((320 < y_num) && (y_num < 480))
//             RGB = 16'b00101_001100_11111;
//     end
//     else if ((416 < x_num) && (x_num < 640)) begin
//         if ((0 < y_num) && (y_num < 160))
//             RGB = 16'b00101_001001_00110;
//         else if ((160 < y_num) && (y_num < 320))
//             RGB = 16'b01011_100111_00000;
//         else if ((320 < y_num) && (y_num < 480))
//             RGB = 16'b00111_000000_11001;
//     end
// end

