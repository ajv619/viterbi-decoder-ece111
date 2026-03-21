module viterbi_tx_rx_2c
#(
   parameter int BURST_LEN   = 1,
   parameter int BURST_START = 128
)
(
   input  clk,
   input  rst,
   input  encoder_i,
   input  enable_encoder_i,
   output decoder_o
);

   viterbi_tx_rx_part2_base #(
      .MODE(2),
      .BURST_LEN(BURST_LEN),
      .ERR_MASK(2'b01),
      .SINGLE_BURST_START(BURST_START)
   ) dut (
      .clk,
      .rst,
      .encoder_i,
      .enable_encoder_i,
      .decoder_o
   );

endmodule
