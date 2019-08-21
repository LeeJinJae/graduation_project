module mixColumns (/*AUTOARG*/
   // Outputs
   S_,
   // Inputs
   S, round, mode
   ) ;
   input  [127:0] S;
   input  [4:0]   round;
   input  [1:0]   mode;

   output [127:0] S_;

   wire   [7:0] S00, S01, S02, S03,
                S10, S11, S12, S13,
                S20, S21, S22, S23,
                S30, S31, S32, S33;
   wire   [7:0] T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, TA, TB, TC, TD, TE, TF;

   reg   [127:0] S_;

   localparam min  = 8'b00011011;
   localparam zero =8'b00000000;
   localparam AES192 = 2'h2;
   localparam AES256 = 2'h3;

   assign T0 =   S[127]?min:zero;
   assign T1 =   S[119]?min:zero;
   assign T2 =   S[111]?min:zero;
   assign T3 =   S[103]?min:zero;
   assign T4 =   S[95] ?min:zero;
   assign T5 =   S[87] ?min:zero;
   assign T6 =   S[79] ?min:zero;
   assign T7 =   S[71] ?min:zero;
   assign T8 =   S[63] ?min:zero;
   assign T9 =   S[55] ?min:zero;
   assign TA =   S[47] ?min:zero;
   assign TB =   S[39] ?min:zero;
   assign TC =   S[31] ?min:zero;
   assign TD =   S[23] ?min:zero;
   assign TE =   S[15] ?min:zero;
   assign TF =   S[7]  ?min:zero;

   assign S00 =   S[127:120]<<1^T0^S[119:112]<<1^T1^S[119:112]      ^S[111:104]      ^S[103: 96];
   assign S10 =   S[127:120]      ^S[119:112]<<1^T1^S[111:104]<<1^T2^S[111:104]      ^S[103: 96];
   assign S20 =   S[127:120]      ^S[119:112]      ^S[111:104]<<1^T2^S[103: 96]<<1^T3^S[103: 96];
   assign S30 =   S[127:120]<<1^T0^S[127:120]    ^S[119:112]      ^S[111:104]      ^S[103: 96]<<1^T3;

   assign S01 =   S[ 95: 88]<<1^T4^S[ 87: 80]<<1^T5^S[ 87: 80]      ^S[ 79: 72]      ^S[ 71: 64];
   assign S11 =   S[ 95: 88]      ^S[ 87: 80]<<1^T5^S[ 79: 72]<<1^T6^S[ 79: 72]      ^S[ 71: 64];
   assign S21 =   S[ 95: 88]      ^S[ 87: 80]      ^S[ 79: 72]<<1^T6^S[ 71: 64]<<1^T7^S[ 71: 64];
   assign S31 =   S[ 95: 88]<<1^T4^S[ 95: 88]    ^S[ 87: 80]      ^S[ 79: 72]      ^S[ 71: 64]<<1^T7;

   assign S02 =   S[ 63: 56]<<1^T8^S[ 55: 48]<<1^T9^S[ 55: 48]      ^S[47:40]     ^S[ 39: 32];
   assign S12 =   S[ 63: 56]      ^S[ 55: 48]<<1^T9^S[47:40]<<1^TA^S[47:40]     ^S[ 39: 32];
   assign S22 =   S[ 63: 56]      ^S[ 55: 48]      ^S[47:40]<<1^TA^S[ 39: 32]<<1^TB^S[ 39: 32];
   assign S32 =   S[ 63: 56]<<1^T8^S[ 63: 56]    ^S[ 55: 48]      ^S[47:40]     ^S[ 39: 32]<<1^TB;

   assign S03 =   S[ 31: 24]<<1^TC^S[ 23: 16]<<1^TD^S[ 23: 16]      ^S[ 15:  8]    ^S[7:0];
   assign S13 =   S[ 31: 24]      ^S[ 23: 16]<<1^TD^S[ 15:  8]<<1^TE^S[ 15:  8]    ^S[7:0];
   assign S23 =   S[ 31: 24]      ^S[ 23: 16]      ^S[ 15:  8]<<1^TE^S[7:0]<<1^TF^S[7:0];
   assign S33 =   S[ 31: 24]<<1^TC^S[ 31: 24]     ^S[ 23: 16]      ^S[ 15:  8]    ^S[7:0]<<1^TF;

   always @ (*) begin
      case(mode)
         AES192 : begin
            if(round == 5'h0E) begin
               S_ = S;
            end else begin
               S_ = {S00, S10, S20, S30, S01, S11, S21, S31, S02, S12, S22, S32, S03, S13, S23, S33};
            end
         end
         AES256 : begin
            if(round == 5'h10) begin
               S_ = S;
            end else begin
               S_ = {S00, S10, S20, S30, S01, S11, S21, S31, S02, S12, S22, S32, S03, S13, S23, S33};
            end
         end
         default : begin
            if(round == 5'h0C) begin
               S_ = S;
            end else begin
               S_ = {S00, S10, S20, S30, S01, S11, S21, S31, S02, S12, S22, S32, S03, S13, S23, S33};
            end
         end
      endcase
   end
endmodule // mixColumns
