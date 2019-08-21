module inv_subBytes (/*AUTOARG*/
   // Outputs
   bytesOut,
   // Inputs
   bytesIn
   ) ;
   input  [127:0] bytesIn;

   output [127:0] bytesOut;

   wire   [127:0] bytesOut;

   inv_sbox inv_subbytes1(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[127:120]),
                  // Inputs
                  .in                    (bytesIn[127:120]));
   inv_sbox inv_subbytes2(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[119:112]),
                  // Inputs
                  .in                    (bytesIn[119:112]));
   inv_sbox inv_subbytes3(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[111:104]),
                  // Inputs
                  .in                    (bytesIn[111:104]));
   inv_sbox inv_subbytes4(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[103: 96]),
                  // Inputs
                  .in                    (bytesIn[103: 96]));
   inv_sbox inv_subbytes5(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 95: 88]),
                  // Inputs
                  .in                    (bytesIn[ 95: 88]));
   inv_sbox inv_subbytes6(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 87: 80]),
                  // Inputs
                  .in                    (bytesIn[ 87: 80]));
   inv_sbox inv_subbytes7(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 79: 72]),
                  // Inputs
                  .in                    (bytesIn[ 79: 72]));
   inv_sbox inv_subbytes8(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 71: 64]),
                  // Inputs
                  .in                    (bytesIn[ 71: 64]));
   inv_sbox inv_subbytes9(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 63: 56]),
                  // Inputs
                  .in                    (bytesIn[ 63: 56]));
   inv_sbox inv_subbytes10(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 55: 48]),
                  // Inputs
                  .in                    (bytesIn[ 55: 48]));
   inv_sbox inv_subbytes11(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 47: 40]),
                  // Inputs
                  .in                    (bytesIn[ 47: 40]));
   inv_sbox inv_subbytes12(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 39: 32]),
                  // Inputs
                  .in                    (bytesIn[ 39: 32]));
   inv_sbox inv_subbytes13(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 31: 24]),
                  // Inputs
                  .in                    (bytesIn[ 31: 24]));
   inv_sbox inv_subbytes14(/*AUTOINST*/
                   // Outputs
                   .out                  (bytesOut[ 23: 16]),
                   // Inputs
                   .in                   (bytesIn[ 23: 16]));
   inv_sbox inv_subbytes15(/*AUTOINST*/
                   // Outputs
                   .out                  (bytesOut[ 15:  8]),
                   // Inputs
                   .in                   (bytesIn[ 15:  8]));
   inv_sbox inv_subbytes16(/*AUTOINST*/
                   // Outputs
                   .out                  (bytesOut[  7:  0]),
                   // Inputs
                   .in                   (bytesIn[  7:  0]));
endmodule // roundFunction
