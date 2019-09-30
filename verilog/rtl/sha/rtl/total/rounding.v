module rounding (/*AUTOARG*/
   // Outputs
   hash_out, hash_fin,
   // Inputs
   K, W, clk, rst_n, H_in, init, done, routing, mode
   ) ;
   input  [63:0] K;
   input  [63:0] W;
   input clk;
   input rst_n;
   input  [511:0] H_in;
   input init;
   input done;
   input [511:0] routing;
   input         mode;

   output hash_out;
   output hash_fin;

   wire [511:0]   hash_out;
   wire [63:0]    a_fin;
   wire [63:0]    b_fin;
   wire [63:0]    c_fin;
   wire [63:0]    d_fin;
   wire [63:0]    e_fin;
   wire [63:0]    f_fin;
   wire [63:0]    g_fin;
   wire [63:0]    h_fin;
   wire [511:0]   hash_fin;

   assign a_fin = mode? (H_in[511:448]+hash_out[511:448]):({32'h0,(H_in[255:224]+hash_out[255:224])});
   assign b_fin = mode? (H_in[447:384]+hash_out[447:384]):({32'h0,(H_in[223:192]+hash_out[223:192])});
   assign c_fin = mode? (H_in[383:320]+hash_out[383:320]):({32'h0,(H_in[191:160]+hash_out[191:160])});
   assign d_fin = mode? (H_in[319:256]+hash_out[319:256]):({32'h0,(H_in[159:128]+hash_out[159:128])});
   assign e_fin = mode? (H_in[255:192]+hash_out[255:192]):({32'h0,(H_in[127: 96]+hash_out[127: 96])});
   assign f_fin = mode? (H_in[191:128]+hash_out[191:128]):({32'h0,(H_in[ 95: 64]+hash_out[ 95: 64])});
   assign g_fin = mode? (H_in[127: 64]+hash_out[127: 64]):({32'h0,(H_in[ 63: 32]+hash_out[ 63: 32])});
   assign h_fin = mode? (H_in[63 :  0]+hash_out[63 :  0]):({32'h0,(H_in[ 31:  0]+hash_out[ 31:  0])});
   assign hash_fin = mode? {a_fin,b_fin,c_fin,d_fin,e_fin,f_fin,g_fin,h_fin}:{256'h0,a_fin[31:0],b_fin[31:0],c_fin[31:0],d_fin[31:0],e_fin[31:0],f_fin[31:0],g_fin[31:0],h_fin[31:0]};

   h_roundFunction h_roundFunction(/*AUTOINST*/
                               // Outputs
                               .h_out           (hash_out[511:0]),
                               // Inputs
                               .h_in            (routing[511:0]),
                               .K               (K[63:0]),
                               .mode            (mode),
                               .W               (W[63:0]));
   
endmodule // rounding
