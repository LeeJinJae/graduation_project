module keyExpansion (/*AUTOARG*/
   // Outputs
   roundkey,
   // Inputs
   round, key, clk, rst_n,init, set, mode
   ) ;
   input [4:0]    round;
   input [255:0]  key;
   input          clk;
   input          rst_n;
   input          init;
   input          set;
   input  [1:0]   mode;

   output [127:0] roundkey;

   localparam AES192 = 2'd2;
   localparam AES256 = 2'd3;

   reg [127:0]  roundkey;
   reg [255:0]  key_state;
   reg [31:0]   w;
   reg [31:0]   w0, w1, w2, w3, w4, w5;

   wire [31:0]  w_;
   wire [1:0]   round_192;
   wire         round_256;

   assign round_256 = round%2;
   assign round_192 = round%3;

   functionT functionT(/*AUTOINST*/
                       // Outputs
                       .w_              (w_[31:0]),
                       // Inputs
                       .w               (w),
                       .round           (round[4:0]),
                       .clk             (clk),
                       .init            (init),
                       .mode            (mode),
                       .rst_n           (rst_n));

   always @ (posedge clk or  negedge rst_n) begin
      if(!rst_n) begin
         roundkey <= 128'h0;
      end else begin
         if(mode == AES192) begin
                  if(init) begin
                     roundkey <= key[191:64];
                  end else if(set) begin
                     roundkey <= {key[63:0],w0,w1};
                  end else if(round_192 == 2'h0) begin
                     roundkey <= {w0,w1,w2,w3};
                  end else if(round_192 == 2'h1) begin
                     roundkey <= {key_state[63:0],w0,w1};
                  end else begin
                     roundkey <= key_state[127:0];
                  end
         end else if(mode == AES256) begin
                  if(init) begin
                     roundkey <= key[255:128];
                  end else if(set) begin
                     roundkey <= key[127:0];
                  end else begin
                     roundkey <= {w0,w1,w2,w3};
                  end
         end else begin
               if(init) begin
                  roundkey <= key[127:0];
               end else begin
                  roundkey <= {w0,w1,w2,w3};
               end
         end
      end
   end

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         key_state <= 192'h0;
      end else begin
            if(mode == AES192) begin
               if(init) begin
                  key_state <= {64'h0,key};
               end else if(round_192 != 2'h2) begin
                 key_state<= {64'h0,w0,w1,w2,w3,w4,w5};
               end
            end else if(mode == AES256) begin
               if(init||set) begin
                  key_state <= key;
               end else if(round_256 == 1'h0) begin
                  key_state[255:128] <= {w0,w1,w2,w3};
               end else begin
                  key_state[127:0] <= {w0,w1,w2,w3};
               end
            end else begin
               if(init) begin
                  key_state <= {128'h0,key[127:0]};
               end else begin
                  key_state <= {128'h0,w0,w1,w2,w3};
               end
            end
      end
   end

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         w <= 32'h0;
      end else begin
        if(mode == AES192) begin
            if(init) begin
              w <= key[31:0];
           end else if(round_192 != 2'h2) begin
              w <= w5;
           end
        end else if(mode == AES256) begin
           if(init) begin
              w <= key[159:128];
           end else if(set) begin
              w <= key[31:0];
           end else begin
              w <= w3;
           end
        end else begin
           if(init) begin
              w <= key[31:0];
           end else begin
              w <= w3;
           end
        end
      end
   end

   always @ (*) begin
      case(mode)
        AES192 : begin
           w0 = w_^key_state[191:160];
           w1 = w0^key_state[159:128];
           w2 = w1^key_state[127:96];
           w3 = w2^key_state[95:64];
           w4 = w3^key_state[63:32];
           w5 = w4^key_state[31:0];
        end
        AES256 : begin
           case(round_256)
             1'h0 : begin
                w0 = w_^key_state[255:224];
                w1 = w0^key_state[223:192];
                w2 = w1^key_state[191:160];
                w3 = w2^key_state[159:128];
             end
             1'h1 : begin
                w0 = w_^key_state[127:96];
                w1 = w0^key_state[95:64];
                w2 = w1^key_state[63:32];
                w3 = w2^key_state[31:0];
             end
           endcase
        end
        default : begin
           w0 = w_^key_state[127:96];
           w1 = w0^key_state[95:64];
           w2 = w1^key_state[63:32];
           w3 = w2^key_state[31:0];
        end
      endcase
   end
endmodule // keyExpansion
