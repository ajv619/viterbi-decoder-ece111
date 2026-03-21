module viterbi_tx_rx_2a1
(
   input  clk,
   input  rst,
   input  encoder_i,
   input  enable_encoder_i,
   output decoder_o
);

   viterbi_tx_rx_part2_base #(
      .MODE(0),
      .BLOCK_LEN(8),
      .BURST_LEN(1),
      .ERR_MASK(2'b01)
   ) dut (
      .clk,
      .rst,
      .encoder_i,
      .enable_encoder_i,
      .decoder_o
   );

endmodule
