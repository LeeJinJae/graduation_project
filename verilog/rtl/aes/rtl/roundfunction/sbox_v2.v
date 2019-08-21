module sbox(/*AUTOARG*/
   // Outputs
   out,
   // Inputs
   in
   );

   input  [7:0] in;

   output [7:0] out;

   reg   [  7:0] out;
   reg   [127:0] row;

   wire [3:0]  x,y;

   assign x = in[7:4];
   assign y = in[3:0];

   always @ (*) begin
      case(x)
         4'h0  : row = 127'h637c777bf26b6fc53001672bfed7ab76;
         4'h1  : row = 127'hca82c97dfa5947f0add4a2af9ca472c0;
         4'h2  : row = 127'hb7fd9326363ff7cc34a5e5f171d83115;
         4'h3  : row = 127'h04c723c31896059a071280e2eb27b275;
         4'h4  : row = 127'h09832c1a1b6e5aa0523bd6b329e32f84;
         4'h5  : row = 127'h53d100ed20fcb15b6acbbe394a4c58cf;
         4'h6  : row = 127'hd0efaafb434d338545f9027f503c9fa8;
         4'h7  : row = 127'h51a3408f929d38f5bcb6da2110fff3d2;
         4'h8  : row = 127'hcd0c13ec5f974417c4a77e3d645d1973;
         4'h9  : row = 127'h60814fdc222a908846eeb814de5e0bdb;
         4'hA  : row = 127'he0323a0a4906245cc2d3ac629195e479;
         4'hB  : row = 127'he7c8376d8dd54ea96c56f4ea657aae08;
         4'hC  : row = 127'hba78252e1ca6b4c6e8dd741f4bbd8b8a;
         4'hD  : row = 127'h703eb5664803f60e613557b986c11d9e;
         4'hE  : row = 127'he1f8981169d98e949b1e87e9ce5528df;
         4'hF  : row = 127'h8ca1890dbfe6426841992d0fb054bb16;
      endcase
   end

   always @ (*) begin
      case(y)
        4'h0  : out = row[127:120];
        4'h1  : out = row[119:112];
        4'h2  : out = row[111:104];
        4'h3  : out = row[103: 96];
        4'h4  : out = row[ 95: 88];
        4'h5  : out = row[ 87: 80];
        4'h6  : out = row[ 79: 72];
        4'h7  : out = row[ 71: 64];
        4'h8  : out = row[ 63: 56];
        4'h9  : out = row[ 55: 48];
        4'hA  : out = row[ 47: 40];
        4'hB  : out = row[ 39: 32];
        4'hC  : out = row[ 31: 24];
        4'hD  : out = row[ 23: 16];
        4'hE  : out = row[ 15:  8];
        4'hF  : out = row[ 7 :  0];
      endcase
   end

endmodule
