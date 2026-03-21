module encoder
(
   input              clk,
   input              rst,
   input              enable_i,
   input              d_in,
   output logic       valid_o,
   output logic [1:0] d_out
);

   logic [2:0] cstate;
   logic [2:0] nstate;
   logic [1:0] d_out_reg;

   always_comb begin
      d_out_reg[0]  = d_in;
      d_out_reg[1]  = d_in ^ cstate[2] ^ cstate[1];
      nstate[1:0]   = cstate[2:1];
      nstate[2]     = d_in ^ cstate[1] ^ cstate[0];
   end

   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         cstate <= 3'b000;
         d_out  <= 2'b00;
         valid_o <= 1'b0;
      end
      else begin
         if(!enable_i)
            cstate <= 3'b000;
         else
            cstate <= nstate;

         if(enable_i)
            d_out <= d_out_reg;
         else
            d_out <= 2'b00;

         valid_o <= enable_i;
      end
   end

endmodule
