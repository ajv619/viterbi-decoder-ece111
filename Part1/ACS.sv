module ACS
(
   input             path_0_valid,
   input             path_1_valid,
   input       [1:0] path_0_bmc,
   input       [1:0] path_1_bmc,
   input       [7:0] path_0_pmc,
   input       [7:0] path_1_pmc,
   output logic      selection,
   output logic      valid_o,
   output logic [7:0] path_cost
);

   logic [7:0] path_cost_0;
   logic [7:0] path_cost_1;

   always_comb begin
      path_cost_0 = path_0_pmc + path_0_bmc;
      path_cost_1 = path_1_pmc + path_1_bmc;

      valid_o    = path_0_valid | path_1_valid;
      selection  = 1'b0;
      path_cost  = 8'd0;

      if(path_0_valid && !path_1_valid) begin
         selection = 1'b0;
         path_cost = path_cost_0;
      end
      else if(!path_0_valid && path_1_valid) begin
         selection = 1'b1;
         path_cost = path_cost_1;
      end
      else if(path_0_valid && path_1_valid) begin
         if(path_cost_1 < path_cost_0) begin
            selection = 1'b1;
            path_cost = path_cost_1;
         end
         else begin
            selection = 1'b0;
            path_cost = path_cost_0;
         end
      end
   end

endmodule
