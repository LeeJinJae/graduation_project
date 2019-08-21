module round_adder (/*AUTOARG*/
   // Outputs
   round, round_last,
   // Inputs
   clk, rst_n, mode,init, set, enable,done, enc
   ) ;
   input [1:0] mode;
   input       clk;
   input       rst_n;
   input       enc;
   input       init;
   input       set;
   input       enable;
   input       done;

   output round_last;
   output round;

   wire [4:0] next_round;

   reg   [4:0] round;
   reg         round_last;
   reg   [4:0] last;

   localparam AES192 = 2'd2;
   localparam AES256 = 2'd3;

   assign next_round = round + 5'h01;

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         round <= 5'h0;
      end else begin
         if(enc) begin
            if(init || set || enable) begin
               round <= next_round;
            end else if(done) begin
               round <=5'h0;
            end
         end else begin
            if(init || set || enable) begin
               round <= next_round;
            end else if(done) begin
               round <=5'h0;
            end
         end
      end
   end

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         round_last <= 0;
      end else begin
        if(round == last) begin
           round_last <= 1;
        end else if(round_last) begin
           round_last <= 0;
        end
      end
   end // always @ (posedge clk or negedge rst_n)

   always @ (*) begin
      case(mode)
        AES192  : begin
              last = 5'h0C;
        end
        AES256  : begin
              last = 5'h0E;
        end
        default : begin
              last = 5'h0A;
        end
      endcase // case(mode)
   end
endmodule // round_adder
