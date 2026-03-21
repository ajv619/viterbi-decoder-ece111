module viterbi_tx_rx_2b8
(
   input  clk,
   input  rst,
   input  encoder_i,
   input  enable_encoder_i,
   output decoder_o
);

   viterbi_tx_rx_part2_base #(
      .MODE(1),
      .BLOCK_LEN(32),
      .BURST_LEN(2),
      .ERR_MASK(2'b11)
   ) dut (
      .clk,
      .rst,
      .encoder_i,
      .enable_encoder_i,
      .decoder_o
   );

endmodule
