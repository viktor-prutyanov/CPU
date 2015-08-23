iverilog -o prg_test top.v test.v 7seg.v flash_spi.v uart_tx.v
vvp prg_test
gtkwave test_out.vcd