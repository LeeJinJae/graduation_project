module inv_roundFunction (/*AUTOARG*/
   // Outputs
   plain,
   // Inputs
   cipher, roundKey, round, mode, done, clk, rst_n, init, set, keygen, enc
   ) ;
   input  [127:0] cipher;
   input  [127:0] roundKey;
   input  [1:0] mode;
   input        clk;
   input        rst_n;
   input        done;
   input        init;
   input        set;
   input        enc;
   input  [4:0] round;
   input        keygen;

   output [127:0] plain;

   wire   [127:0] A,B,C,r_states;

   reg   [127:0] rounding;
   reg   [127:0] plain;

   inv_shiftRows inv_shiftRows(/*AUTOINST*/
                       // Outputs
                       .S_              (A[127:0]),
                       // Inputs
                       .S               (rounding[127:0]));

   inv_subBytes inv_subBytes(/*AUTOINST*/
                             // Outputs
                             .bytesOut          (B[127:0]),
                             // Inputs
                             .bytesIn           (A[127:0]));

   assign C = (round==5'h2)? rounding^roundKey : B ^ roundKey;

   inv_mixColumns inv_mixColumns(/*AUTOINST*/
                         // Outputs
                         .S_                    (r_states[127:0]),
                         // Inputs
                         .S                     (C[127:0]),
                         .mode                  (mode[1:0]),
                         .round                 (round[4:0]));

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         rounding <= 128'h0;
      end else begin
         if(set) begin
            rounding <= cipher;
         end else if(round==5'h2) begin
            rounding <= C;
         end else begin
            rounding <= r_states;
         end
      end
   end

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         plain <= 128'h0;
      end else begin
         if(keygen|enc) begin
            plain <= 128'h0;
         end else if(done) begin
            plain <= C;
         end
      end
   end
   
endmodule // inv_roundFunction

