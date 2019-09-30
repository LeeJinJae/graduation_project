module h_round_adder (/*AUTOARG*/
   // Outputs
   round,round_last,
   // Inputs
   clk, rst_n, init, mode
   ) ;
   input clk;
   input rst_n;
   input init;
   input mode;

   output round;
   output round_last;

   reg [6:0] round;
   wire round_last;

   wire [6:0] next_round;

   assign next_round = round + 7'h1;
   assign round_last = mode?((round == 7'd78)? 1:0) :((round == 7'd62)? 1:0);
   
   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         round <= 7'h0;
      end else begin
         if(init) begin
            round <= 7'h0;
         end else begin
            round <= next_round;
         end
      end
   end
   
endmodule // h_round_adder
