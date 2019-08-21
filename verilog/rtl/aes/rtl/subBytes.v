module subBytes (/*AUTOARG*/
   // Outputs
   bytesOut,
   // Inputs
   bytesIn
   ) ;
   input  [127:0] bytesIn;

   output [127:0] bytesOut;

   wire   [127:0] bytesOut;

   sbox subbytes1(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[127:120]),
                  // Inputs
                  .in                    (bytesIn[127:120]));
   sbox subbytes2(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[119:112]),
                  // Inputs
                  .in                    (bytesIn[119:112]));
   sbox subbytes3(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[111:104]),
                  // Inputs
                  .in                    (bytesIn[111:104]));
   sbox subbytes4(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[103: 96]),
                  // Inputs
                  .in                    (bytesIn[103: 96]));
   sbox subbytes5(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 95: 88]),
                  // Inputs
                  .in                    (bytesIn[ 95: 88]));
   sbox subbytes6(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 87: 80]),
                  // Inputs
                  .in                    (bytesIn[ 87: 80]));
   sbox subbytes7(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 79: 72]),
                  // Inputs
                  .in                    (bytesIn[ 79: 72]));
   sbox subbytes8(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 71: 64]),
                  // Inputs
                  .in                    (bytesIn[ 71: 64]));
   sbox subbytes9(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 63: 56]),
                  // Inputs
                  .in                    (bytesIn[ 63: 56]));
   sbox subbytes10(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 55: 48]),
                  // Inputs
                  .in                    (bytesIn[ 55: 48]));
   sbox subbytes11(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 47: 40]),
                  // Inputs
                  .in                    (bytesIn[ 47: 40]));
   sbox subbytes12(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 39: 32]),
                  // Inputs
                  .in                    (bytesIn[ 39: 32]));
   sbox subbytes13(/*AUTOINST*/
                  // Outputs
                  .out                   (bytesOut[ 31: 24]),
                  // Inputs
                  .in                    (bytesIn[ 31: 24]));
   sbox subbytes14(/*AUTOINST*/
                   // Outputs
                   .out                  (bytesOut[ 23: 16]),
                   // Inputs
                   .in                   (bytesIn[ 23: 16]));
   sbox subbytes15(/*AUTOINST*/
                   // Outputs
                   .out                  (bytesOut[ 15:  8]),
                   // Inputs
                   .in                   (bytesIn[ 15:  8]));
   sbox subbytes16(/*AUTOINST*/
                   // Outputs
                   .out                  (bytesOut[  7:  0]),
                   // Inputs
                   .in                   (bytesIn[  7:  0]));
endmodule // roundFunction
