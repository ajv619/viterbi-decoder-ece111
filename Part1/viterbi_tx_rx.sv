module viterbi_tx_rx
(
   input        clk,
   input        rst,
   input        encoder_i,
   input        enable_encoder_i,
   output       decoder_o
);

   wire  [1:0] encoder_o;
   wire        valid_encoder_o;

   int         error_counter;
   int         bad_bit_ct;
   int         word_ct;
   logic [1:0] encoder_o_reg;
   logic       enable_decoder_in;
   logic [1:0] err_inj;

   always_ff @(posedge clk or negedge rst) begin
      if(!rst) begin
         error_counter     <= 'd0;
         bad_bit_ct        <= 'd0;
         word_ct           <= 'd0;
         encoder_o_reg     <= 2'b00;
         enable_decoder_in <= 1'b0;
         err_inj           <= 2'b00;
      end
      else begin
         encoder_o_reg     <= encoder_o;
         enable_decoder_in <= valid_encoder_o;
         err_inj           <= 2'b00;
         error_counter     <= 'd0;
         bad_bit_ct        <= 'd0;

         if(valid_encoder_o)
            word_ct <= word_ct + 1;
      end
   end

   encoder encoder1
   (
      .clk,
      .rst,
      .enable_i(enable_encoder_i),
      .d_in    (encoder_i),
      .valid_o (valid_encoder_o),
      .d_out   (encoder_o)
   );

   decoder decoder1
   (
      .clk,
      .rst,
      .enable (enable_decoder_in),
      .d_in   (encoder_o_reg),
      .d_out  (decoder_o)
   );

endmodule
