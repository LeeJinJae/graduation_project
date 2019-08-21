module roundFunction (/*AUTOARG*/
   // Outputs
   h_out,
   // Inputs
   h_in, K, W
   );
   input  [255:0] h_in;
   input  [31:0] K;
   input  [31:0] W;

   output [255:0] h_out;

   wire   [31:0] a, b, c, d, e, f, g, h;
   wire   [31:0] a_next, b_next, c_next, d_next, e_next, f_next, g_next, h_next;
   wire   [31:0] Maj;
   wire   [31:0] Ch;
   wire   [31:0] sigma0, sigma1;
   wire   [31:0] T1;
   wire   [31:0] T2;
   wire   [255:0] h_out;

   assign a = h_in[255:224];
   assign b = h_in[223:192];
   assign c = h_in[191:160];
   assign d = h_in[159:128];
   assign e = h_in[127:96];
   assign f = h_in[95:64];
   assign g = h_in[63:32];
   assign h = h_in[31:0];
   assign Ch = (e&f)^((~e)&g);
   assign Maj = (a&b)^(a&c)^(b&c);
   assign sigma0 = {a[1:0],a[31:2]}^{a[12:0],a[31:13]}^{a[21:0],a[31:22]};
   assign sigma1 = {e[5:0],e[31:6]}^{e[10:0],e[31:11]}^{e[24:0],e[31:25]};
   assign T1 = h+sigma1+Ch+K+W;
   assign T2 = sigma0+Maj;

   assign a_next = T1+T2;
   assign b_next = a;
   assign c_next = b;
   assign d_next = c;
   assign e_next = d+T1;
   assign f_next = e;
   assign g_next = f;
   assign h_next = g;

   assign h_out = {a_next,b_next,c_next,d_next,e_next,f_next,g_next,h_next};

endmodule // roundFunction
