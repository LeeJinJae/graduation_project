module roundFunction (/*AUTOARG*/
   // Outputs
   cipher,
   // Inputs
   roundKey, round,set, mode, plain, init, rst_n, clk, done, keygen, enc
   ) ;
   input  [127:0] roundKey;
   input  [4:0]   round;
   input          clk;
   input          rst_n;
   input          init;
   input          set;
   input          done;
   input  [1:0]   mode;
   input  [127:0] plain;
   input          keygen;
   input          enc;

   output [127:0] cipher;

   wire   [127:0] A,B,C,r_states;

   reg   [127:0] rounding;
   reg   [127:0] cipher;

   subBytes subBytes(/*AUTOINST*/
                     // Outputs
                     .bytesOut          (A[127:0]),
                     // Inputs
                     .bytesIn           (rounding[127:0]));

   shiftRows shiftRows(/*AUTOINST*/
                       // Outputs
                       .S_              (B[127:0]),
                       // Inputs
                       .S               (A[127:0]));

   mixColumns mixColumns(/*AUTOINST*/
                         // Outputs
                         .S_                    (C[127:0]),
                         // Inputs
                         .S                     (B[127:0]),
                         .mode                  (mode[1:0]),
                         .round                 (round[4:0]));

   assign r_states = (round==5'h2)? rounding^roundKey : C ^ roundKey;

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         rounding <= 128'h0;
      end else begin
         if(set) begin
            rounding <= plain;
         end else begin
            rounding <= r_states;
         end
      end
   end

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         cipher <= 128'h0;
      end else begin
         if(keygen|!enc) begin
            cipher <= 128'h0;
         end else if(done) begin
            cipher <= r_states;
         end
      end
   end
endmodule // roundFunction
 
