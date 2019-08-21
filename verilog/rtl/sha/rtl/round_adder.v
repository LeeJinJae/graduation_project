module round_adder (/*AUTOARG*/
   // Outputs
   round,round_last,
   // Inputs
   clk, rst_n, init
   ) ;
   input clk;
   input rst_n;
   input init;

   output round;
   output round_last;

   reg [5:0] round;
   wire round_last;

   wire [5:0] next_round;

   assign next_round = round + 6'h1;
   assign round_last = (round == 6'd62)? 1:0;
   
   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         round <= 6'h0;
      end else begin
         if(init) begin
            round <= 6'h0;
         end else begin
            round <= next_round;
         end
      end
   end
   
endmodule // round_adder
