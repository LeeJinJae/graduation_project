module inv_mixColumns (/*AUTOARG*/
   // Outputs
   S_,
   // Inputs
   S, round, mode
   ) ;
   input  [127:0] S;
   input  [4:0] round;
   input  [1:0] mode;

   output [127:0] S_;

   wire   [7:0]   S00, S01, S02, S03,
                  S10, S11, S12, S13,
                  S20, S21, S22, S23,
                  S30, S31, S32, S33;
   wire   [7:0]   T03,T02,T01,
                  T13,T12,T11,
                  T23,T22,T21,
                  T33,T32,T31,
                  T43,T42,T41,
                  T53,T52,T51,
                  T63,T62,T61,
                  T73,T72,T71,
                  T83,T82,T81,
                  T93,T92,T91,
                  TA3,TA2,TA1,
                  TB3,TB2,TB1,
                  TC3,TC2,TC1,
                  TD3,TD2,TD1,
                  TE3,TE2,TE1,
                  TF3,TF2,TF1;
                  
   reg   [127:0] S_;

   localparam min3 =   8'b01101100;
   localparam min2 =   8'b00110110;
   localparam min1 =   8'b00011011;
   localparam zero =   8'b00000000;
   localparam AES192 = 2'h2;
   localparam AES256 = 2'h3;

   assign T03 =   (S[127] ?min3:zero)^(S[126] ?min2:zero)^(S[125] ?min1:zero);
   assign T02 =   (S[127] ?min2:zero)^(S[126] ?min1:zero);
   assign T01 =   (S[127] ?min1:zero);
   assign T13 =   (S[119] ?min3:zero)^(S[118] ?min2:zero)^(S[117] ?min1:zero);
   assign T12 =   (S[119] ?min2:zero)^(S[118] ?min1:zero);
   assign T11 =   (S[119] ?min1:zero);
   assign T23 =   (S[111] ?min3:zero)^(S[110] ?min2:zero)^(S[109] ?min1:zero);
   assign T22 =   (S[111] ?min2:zero)^(S[110] ?min1:zero);
   assign T21 =   (S[111] ?min1:zero);
   assign T33 =   (S[103] ?min3:zero)^(S[102] ?min2:zero)^(S[101] ?min1:zero);
   assign T32 =   (S[103] ?min2:zero)^(S[102] ?min1:zero);
   assign T31 =   (S[103] ?min1:zero);
   assign T43 =   (S[ 95] ?min3:zero)^(S[ 94] ?min2:zero)^(S[ 93] ?min1:zero);
   assign T42 =   (S[ 95] ?min2:zero)^(S[ 94] ?min1:zero);
   assign T41 =   (S[ 95] ?min1:zero);
   assign T53 =   (S[ 87] ?min3:zero)^(S[ 86] ?min2:zero)^(S[ 85] ?min1:zero);
   assign T52 =   (S[ 87] ?min2:zero)^(S[ 86] ?min1:zero);
   assign T51 =   (S[ 87] ?min1:zero);
   assign T63 =   (S[ 79] ?min3:zero)^(S[ 78] ?min2:zero)^(S[ 77] ?min1:zero);
   assign T62 =   (S[ 79] ?min2:zero)^(S[ 78] ?min1:zero);
   assign T61 =   (S[ 79] ?min1:zero);
   assign T73 =   (S[ 71] ?min3:zero)^(S[ 70] ?min2:zero)^(S[ 69] ?min1:zero);
   assign T72 =   (S[ 71] ?min2:zero)^(S[ 70] ?min1:zero);
   assign T71 =   (S[ 71] ?min1:zero);
   assign T83 =   (S[ 63] ?min3:zero)^(S[ 62] ?min2:zero)^(S[ 61] ?min1:zero);
   assign T82 =   (S[ 63] ?min2:zero)^(S[ 62] ?min1:zero);
   assign T81 =   (S[ 63] ?min1:zero);
   assign T93 =   (S[ 55] ?min3:zero)^(S[ 54] ?min2:zero)^(S[ 53] ?min1:zero);
   assign T92 =   (S[ 55] ?min2:zero)^(S[ 54] ?min1:zero);
   assign T91 =   (S[ 55] ?min1:zero);
   assign TA3 =   (S[ 47] ?min3:zero)^(S[ 46] ?min2:zero)^(S[ 45] ?min1:zero);
   assign TA2 =   (S[ 47] ?min2:zero)^(S[ 46] ?min1:zero);
   assign TA1 =   (S[ 47] ?min1:zero);
   assign TB3 =   (S[ 39] ?min3:zero)^(S[ 38] ?min2:zero)^(S[ 37] ?min1:zero);
   assign TB2 =   (S[ 39] ?min2:zero)^(S[ 38] ?min1:zero);
   assign TB1 =   (S[ 39] ?min1:zero);
   assign TC3 =   (S[ 31] ?min3:zero)^(S[ 30] ?min2:zero)^(S[ 29] ?min1:zero);
   assign TC2 =   (S[ 31] ?min2:zero)^(S[ 30] ?min1:zero);
   assign TC1 =   (S[ 31] ?min1:zero);
   assign TD3 =   (S[ 23] ?min3:zero)^(S[ 22] ?min2:zero)^(S[ 21] ?min1:zero);
   assign TD2 =   (S[ 23] ?min2:zero)^(S[ 22] ?min1:zero);
   assign TD1 =   (S[ 23] ?min1:zero);
   assign TE3 =   (S[ 15] ?min3:zero)^(S[ 14] ?min2:zero)^(S[ 13] ?min1:zero);
   assign TE2 =   (S[ 15] ?min2:zero)^(S[ 14] ?min1:zero);
   assign TE1 =   (S[ 15] ?min1:zero);
   assign TF3 =   (S[  7] ?min3:zero)^(S[  6] ?min2:zero)^(S[  5] ?min1:zero);
   assign TF2 =   (S[  7] ?min2:zero)^(S[  6] ?min1:zero);
   assign TF1 =   (S[  7] ?min1:zero);
   
   assign S00 =   S[127:120]<<3^T03^S[127:120]<<2^T02^S[127:120]<<1^T01^S[119:112]<<3^T13^S[119:112]<<1^T11^S[119:112]^
                  S[111:104]<<3^T23^S[111:104]<<2^T22^S[111:104]^S[103: 96]<<3^T33^S[103: 96];
   assign S10 =   S[127:120]<<3^T03^S[127:120]^S[119:112]<<3^T13^S[119:112]<<2^T12^S[119:112]<<1^T11^
                  S[111:104]<<3^T23^S[111:104]<<1^T21^S[111:104]^S[103: 96]<<3^T33^S[103: 96]<<2^T32^S[103: 96];
   assign S20 =   S[127:120]<<3^T03^S[127:120]<<2^T02^S[127:120]^S[119:112]<<3^T13^S[119:112]^
                  S[111:104]<<3^T23^S[111:104]<<2^T22^S[111:104]<<1^T21^S[103: 96]<<3^T33^S[103: 96]<<1^T31^S[103: 96];
   assign S30 =   S[127:120]<<3^T03^S[127:120]<<1^T01^S[127:120]^S[119:112]<<3^T13^S[119:112]<<2^T12^S[119:112]^
                  S[111:104]<<3^T23^S[111:104]^S[103: 96]<<3^T33^S[103: 96]<<2^T32^S[103: 96]<<1^T31;
   
   assign S01 =   S[ 95: 88]<<3^T43^S[ 95: 88]<<2^T42^S[ 95: 88]<<1^T41^S[ 87: 80]<<3^T53^S[ 87: 80]<<1^T51^S[ 87: 80]^
                  S[ 79: 72]<<3^T63^S[ 79: 72]<<2^T62^S[ 79: 72]^S[ 71: 64]<<3^T73^S[ 71: 64];
   assign S11 =   S[ 95: 88]<<3^T43^S[ 95: 88]^S[ 87: 80]<<3^T53^S[ 87: 80]<<2^T52^S[ 87: 80]<<1^T51^
                  S[ 79: 72]<<3^T63^S[ 79: 72]<<1^T61^S[ 79: 72]^S[ 71: 64]<<3^T73^S[ 71: 64]<<2^T72^S[ 71: 64];
   assign S21 =   S[ 95: 88]<<3^T43^S[ 95: 88]<<2^T42^S[ 95: 88]^S[ 87: 80]<<3^T53^S[ 87: 80]^
                  S[ 79: 72]<<3^T63^S[ 79: 72]<<2^T62^S[ 79: 72]<<1^T61^S[ 71: 64]<<3^T73^S[ 71: 64]<<1^T71^S[ 71: 64];
   assign S31 =   S[ 95: 88]<<3^T43^S[ 95: 88]<<1^T41^S[ 95: 88]^S[ 87: 80]<<3^T53^S[ 87: 80]<<2^T52^S[ 87: 80]^
                  S[ 79: 72]<<3^T63^S[ 79: 72]^S[ 71: 64]<<3^T73^S[ 71: 64]<<2^T72^S[ 71: 64]<<1^T71;
   
   assign S02 =   S[ 63: 56]<<3^T83^S[ 63: 56]<<2^T82^S[ 63: 56]<<1^T81^S[ 55: 48]<<3^T93^S[ 55: 48]<<1^T91^S[ 55: 48]^
                  S[ 47: 40]<<3^TA3^S[ 47: 40]<<2^TA2^S[ 47: 40]^S[ 39: 32]<<3^TB3^S[ 39: 32];
   assign S12 =   S[ 63: 56]<<3^T83^S[ 63: 56]^S[ 55: 48]<<3^T93^S[ 55: 48]<<2^T92^S[ 55: 48]<<1^T91^
                  S[ 47: 40]<<3^TA3^S[ 47: 40]<<1^TA1^S[ 47: 40]^S[ 39: 32]<<3^TB3^S[ 39: 32]<<2^TB2^S[ 39: 32];
   assign S22 =   S[ 63: 56]<<3^T83^S[ 63: 56]<<2^T82^S[ 63: 56]^S[ 55: 48]<<3^T93^S[ 55: 48]^
                  S[ 47: 40]<<3^TA3^S[ 47: 40]<<2^TA2^S[ 47: 40]<<1^TA1^S[ 39: 32]<<3^TB3^S[ 39: 32]<<1^TB1^S[ 39: 32];
   assign S32 =   S[ 63: 56]<<3^T83^S[ 63: 56]<<1^T81^S[ 63: 56]^S[ 55: 48]<<3^T93^S[ 55: 48]<<2^T92^S[ 55: 48]^
                  S[ 47: 40]<<3^TA3^S[ 47: 40]^S[ 39: 32]<<3^TB3^S[ 39: 32]<<2^TB2^S[ 39: 32]<<1^TB1;
   
   assign S03 =   S[ 31: 24]<<3^TC3^S[ 31: 24]<<2^TC2^S[ 31: 24]<<1^TC1^S[ 23: 16]<<3^TD3^S[ 23: 16]<<1^TD1^S[ 23: 16]^
                  S[ 15:  8]<<3^TE3^S[ 15:  8]<<2^TE2^S[ 15:  8]^S[  7:  0]<<3^TF3^S[  7:  0];
   assign S13 =   S[ 31: 24]<<3^TC3^S[ 31: 24]^S[ 23: 16]<<3^TD3^S[ 23: 16]<<2^TD2^S[ 23: 16]<<1^TD1^
                  S[ 15:  8]<<3^TE3^S[ 15:  8]<<1^TE1^S[ 15:  8]^S[  7:  0]<<3^TF3^S[  7:  0]<<2^TF2^S[  7:  0];
   assign S23 =   S[ 31: 24]<<3^TC3^S[ 31: 24]<<2^TC2^S[ 31: 24]^S[ 23: 16]<<3^TD3^S[ 23: 16]^
                  S[ 15:  8]<<3^TE3^S[ 15:  8]<<2^TE2^S[ 15:  8]<<1^TE1^S[  7:  0]<<3^TF3^S[  7:  0]<<1^TF1^S[  7:  0];
   assign S33 =   S[ 31: 24]<<3^TC3^S[ 31: 24]<<1^TC1^S[ 31: 24]^S[ 23: 16]<<3^TD3^S[ 23: 16]<<2^TD2^S[ 23: 16]^
                  S[ 15:  8]<<3^TE3^S[ 15:  8]^S[  7:  0]<<3^TF3^S[  7:  0]<<2^TF2^S[  7:  0]<<1^TF1;

   always @ (*) begin
      case(mode)
        AES192 : begin
           if(round == 5'h19) begin
              S_ = S;
           end else begin
              S_ = {S00, S10, S20, S30, S01, S11, S21, S31, S02, S12, S22, S32, S03, S13, S23, S33};
           end
        end
        AES256 : begin
           if(round == 5'h1d) begin
              S_ = S;
           end else begin
              S_ = {S00, S10, S20, S30, S01, S11, S21, S31, S02, S12, S22, S32, S03, S13, S23, S33};
           end
        end
        default : begin
           if(round == 5'h15) begin
              S_ = S;
           end else begin
              S_ = {S00, S10, S20, S30, S01, S11, S21, S31, S02, S12, S22, S32, S03, S13, S23, S33};
           end
        end
      endcase
   end

endmodule // inv_mixColumns
