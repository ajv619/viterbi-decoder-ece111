module viterbi_tx_rx_part2_base
#(
   parameter int MODE               = 0,
   parameter int BLOCK_LEN          = 8,
   parameter int BURST_LEN          = 1,
   parameter logic [1:0] ERR_MASK   = 2'b01,
   parameter int SINGLE_BURST_START = 128,
   parameter int MAX_SAMPLES        = 256
)
(
   input        clk,
   input        rst,
   input        encoder_i,
   input        enable_encoder_i,
   output       decoder_o
);

   localparam int MODE_UNIFORM      = 0;
   localparam int MODE_RANDOM_BLOCK = 1;
   localparam int MODE_SINGLE_BURST = 2;

   wire  [1:0] encoder_o;
   wire        valid_encoder_o;

   int         error_counter;
   int         bad_bit_ct;
   int         word_ct;
   int         random_start;

   logic [1:0] encoder_o_reg;
   logic       enable_decoder_in;
   logic [1:0] err_inj;

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

   always_ff @(posedge clk or negedge rst) begin : channel_ff
      logic [1:0] err_mask_now;
      integer     block_offset;
      integer     rand_start_now;
      integer     max_start;
      integer     corrupted_bits_now;

      if(!rst) begin
         error_counter     <= 'd0;
         bad_bit_ct        <= 'd0;
         word_ct           <= 'd0;
         random_start      <= 'd0;
         encoder_o_reg     <= 2'b00;
         enable_decoder_in <= 1'b0;
         err_inj           <= 2'b00;
      end
      else begin
         err_mask_now       = 2'b00;
         block_offset       = 0;
         rand_start_now     = random_start;
         max_start          = 0;
         corrupted_bits_now = 0;

         if(valid_encoder_o && (word_ct < MAX_SAMPLES)) begin
            if(MODE == MODE_RANDOM_BLOCK) begin
               block_offset = word_ct % BLOCK_LEN;
               max_start    = BLOCK_LEN - BURST_LEN;
               if(max_start < 0)
                  max_start = 0;

               if(block_offset == 0) begin
                  if(max_start == 0)
                     rand_start_now = 0;
                  else begin
                     rand_start_now = $random;
                     if(rand_start_now < 0)
                        rand_start_now = -rand_start_now;
                     rand_start_now = rand_start_now % (max_start + 1);
                  end
                  random_start <= rand_start_now;
               end
            end

            unique case(MODE)
               MODE_UNIFORM: begin
                  block_offset = word_ct % BLOCK_LEN;
                  if(block_offset >= (BLOCK_LEN - BURST_LEN))
                     err_mask_now = ERR_MASK;
               end

               MODE_RANDOM_BLOCK: begin
                  if(block_offset >= rand_start_now &&
                     block_offset < (rand_start_now + BURST_LEN))
                     err_mask_now = ERR_MASK;
               end

               MODE_SINGLE_BURST: begin
                  if(word_ct >= SINGLE_BURST_START &&
                     word_ct < (SINGLE_BURST_START + BURST_LEN))
                     err_mask_now = ERR_MASK;
               end

               default: begin
                  err_mask_now = 2'b00;
               end
            endcase
         end

         corrupted_bits_now = err_mask_now[0] + err_mask_now[1];

         if(valid_encoder_o) begin
            word_ct        <= word_ct + 1;
            error_counter  <= error_counter + corrupted_bits_now;
            bad_bit_ct     <= bad_bit_ct + corrupted_bits_now;
         end

         encoder_o_reg     <= valid_encoder_o ? (encoder_o ^ err_mask_now) : 2'b00;
         enable_decoder_in <= valid_encoder_o;
         err_inj           <= err_mask_now;
      end
   end

endmodule
