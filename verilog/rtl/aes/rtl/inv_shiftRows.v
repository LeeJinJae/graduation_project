module inv_shiftRows (/*AUTOARG*/
   // Outputs
   S_,
   // Inputs
   S
   ) ;
   input  [127:0] S;

   output [127:0] S_;

   wire   [127:0] S_;

   assign S_ = {S[127:120],S[ 23: 16],S[ 47: 40],S[ 71: 64],
                S[ 95: 88],S[119:112],S[ 15:  8],S[ 39: 32],
                S[ 63: 56],S[ 87: 80],S[111:104],S[  7:  0],
                S[ 31: 24],S[ 55: 48],S[ 79: 72],S[103: 96]};
   
endmodule // inv_shiftRows
