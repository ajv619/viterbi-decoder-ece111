module mem
(
   input             clk,
   input             wr,
   input      [9:0]  addr,
   input      [7:0]  d_i,
   output logic [7:0] d_o
);

   logic [7:0] mem_core [0:1023];

   always_ff @(posedge clk) begin
      if(wr)
         mem_core[addr] <= d_i;
      d_o <= mem_core[addr];
   end

endmodule

module mem_disp
(
   input            clk,
   input            wr,
   input      [9:0] addr,
   input            d_i,
   output logic     d_o
);

   logic mem_core [0:1023];

   always_ff @(posedge clk) begin
      if(wr)
         mem_core[addr] <= d_i;
      d_o <= mem_core[addr];
   end

endmodule
