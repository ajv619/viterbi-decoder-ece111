module bmc
#(
   parameter bit INVERT_RX1 = 1'b0
)
(
   input       [1:0] rx_pair,
   output logic [1:0] path_0_bmc,
   output logic [1:0] path_1_bmc
);

   logic tmp00;
   logic tmp01;
   logic tmp10;
   logic tmp11;

   always_comb begin
      tmp00 = rx_pair[0];
      tmp01 = INVERT_RX1 ? ~rx_pair[1] : rx_pair[1];
      tmp10 = ~tmp00;
      tmp11 = ~tmp01;

      path_0_bmc[1] = tmp00 & tmp01;
      path_0_bmc[0] = tmp00 ^ tmp01;

      path_1_bmc[1] = tmp10 & tmp11;
      path_1_bmc[0] = tmp10 ^ tmp11;
   end

endmodule

module bmc0(input [1:0] rx_pair, output [1:0] path_0_bmc, output [1:0] path_1_bmc);
   bmc #(.INVERT_RX1(1'b0)) bmc_inst(.rx_pair, .path_0_bmc, .path_1_bmc);
endmodule

module bmc1(input [1:0] rx_pair, output [1:0] path_0_bmc, output [1:0] path_1_bmc);
   bmc #(.INVERT_RX1(1'b1)) bmc_inst(.rx_pair, .path_0_bmc, .path_1_bmc);
endmodule

module bmc2(input [1:0] rx_pair, output [1:0] path_0_bmc, output [1:0] path_1_bmc);
   bmc #(.INVERT_RX1(1'b1)) bmc_inst(.rx_pair, .path_0_bmc, .path_1_bmc);
endmodule

module bmc3(input [1:0] rx_pair, output [1:0] path_0_bmc, output [1:0] path_1_bmc);
   bmc #(.INVERT_RX1(1'b0)) bmc_inst(.rx_pair, .path_0_bmc, .path_1_bmc);
endmodule

module bmc4(input [1:0] rx_pair, output [1:0] path_0_bmc, output [1:0] path_1_bmc);
   bmc #(.INVERT_RX1(1'b0)) bmc_inst(.rx_pair, .path_0_bmc, .path_1_bmc);
endmodule

module bmc5(input [1:0] rx_pair, output [1:0] path_0_bmc, output [1:0] path_1_bmc);
   bmc #(.INVERT_RX1(1'b1)) bmc_inst(.rx_pair, .path_0_bmc, .path_1_bmc);
endmodule

module bmc6(input [1:0] rx_pair, output [1:0] path_0_bmc, output [1:0] path_1_bmc);
   bmc #(.INVERT_RX1(1'b1)) bmc_inst(.rx_pair, .path_0_bmc, .path_1_bmc);
endmodule

module bmc7(input [1:0] rx_pair, output [1:0] path_0_bmc, output [1:0] path_1_bmc);
   bmc #(.INVERT_RX1(1'b0)) bmc_inst(.rx_pair, .path_0_bmc, .path_1_bmc);
endmodule
