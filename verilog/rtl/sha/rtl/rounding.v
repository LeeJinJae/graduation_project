module rounding (/*AUTOARG*/
   // Outputs
   hash_out, hash_fin,
   // Inputs
   K, W, clk, rst_n, H_in, init, done, routing
   ) ;
   input  [31:0] K;
   input  [31:0] W;
   input clk;
   input rst_n;
   input  [255:0] H_in;
   input init;
   input done;
   input [255:0] routing;

   output hash_out;
   output hash_fin;

   wire   [255:0] hash_out;
   wire [31:0]    a_fin;
   wire [31:0]    b_fin;
   wire [31:0]    c_fin;
   wire [31:0]    d_fin;
   wire [31:0]    e_fin;
   wire [31:0]    f_fin;
   wire [31:0]    g_fin;
   wire [31:0]    h_fin; 
   wire [255:0]   hash_fin;

   assign a_fin = H_in[255:224]+hash_out[255:224];
   assign b_fin = H_in[223:192]+hash_out[223:192];
   assign c_fin = H_in[191:160]+hash_out[191:160];
   assign d_fin = H_in[159:128]+hash_out[159:128];
   assign e_fin = H_in[127: 96]+hash_out[127: 96];
   assign f_fin = H_in[ 95: 64]+hash_out[ 95: 64];
   assign g_fin = H_in[ 63: 32]+hash_out[ 63: 32];
   assign h_fin = H_in[ 31:  0]+hash_out[ 31:  0];
   assign hash_fin = {a_fin,b_fin,c_fin,d_fin,e_fin,f_fin,g_fin,h_fin};

   roundFunction roundFunction(/*AUTOINST*/
                               // Outputs
                               .h_out           (hash_out[255:0]),
                               // Inputs
                               .h_in            (routing[255:0]),
                               .K               (K[31:0]),
                               .W               (W[31:0]));
   
endmodule // rounding
