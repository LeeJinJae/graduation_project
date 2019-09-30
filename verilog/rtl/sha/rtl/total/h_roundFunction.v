module h_roundFunction (/*AUTOARG*/
   // Outputs
   h_out,
   // Inputs
   h_in, K, W, mode
   );
   input  [511:0] h_in;
   input  [63:0] K;
   input  [63:0] W;
   input         mode;

   output [511:0] h_out;

   wire   [63:0] a, b, c, d, e, f, g, h;
   wire   [63:0] a_next, b_next, c_next, d_next, e_next, f_next, g_next, h_next;
   wire   [63:0] Maj;
   wire   [63:0] Ch;
   wire   [63:0] sigma0, sigma1;
   wire   [63:0] T1;
   wire   [63:0] T2;
   wire   [511:0] h_out;

   assign a = mode? h_in[511:448]:{32'h0,h_in[255:224]};
   assign b = mode? h_in[447:384]:{32'h0,h_in[223:192]};
   assign c = mode? h_in[383:320]:{32'h0,h_in[191:160]};
   assign d = mode? h_in[319:256]:{32'h0,h_in[159:128]};
   assign e = mode? h_in[255:192]:{32'h0,h_in[127: 96]};
   assign f = mode? h_in[191:128]:{32'h0,h_in[ 95: 64]};
   assign g = mode? h_in[127: 64]:{32'h0,h_in[ 63: 32]};
   assign h = mode? h_in[ 63:  0]:{32'h0,h_in[ 31:  0]};
   assign Ch = mode? (e&f)^((~e)&g):{32'h0,(e[31:0]&f[31:0])^((~e[31:0])&g[31:0])};
   assign Maj = mode? (a&b)^(a&c)^(b&c):{32'h0,(a[31:0]&b[31:0])^(a[31:0]&c[31:0])^(b[31:0]&c[31:0])};
   assign sigma0 = mode? {a[27:0],a[63:28]}^{a[33:0],a[63:34]}^{a[38:0],a[63:39]}:{32'h0,{a[1:0],a[31:2]}^{a[12:0],a[31:13]}^{a[21:0],a[31:22]}};
   assign sigma1 = mode? {e[13:0],e[63:14]}^{e[17:0],e[63:18]}^{e[40:0],e[63:41]}:{32'h0,{e[5:0],e[31:6]}^{e[10:0],e[31:11]}^{e[24:0],e[31:25]}};
   assign T1 = mode? h+sigma1+Ch+K+W:{32'h0,h[31:0]+sigma1[31:0]+Ch[31:0]+K[63:32]+W[31:0]};
   assign T2 = mode? sigma0+Maj:{32'h0,sigma0[31:0]+Maj[31:0]};

   assign a_next = mode? T1+T2:{32'h0,T1[31:0]+T2[31:0]};
   assign b_next = a;
   assign c_next = b;
   assign d_next = c;
   assign e_next = mode? d+T1:{32'h0,d[31:0]+T1[31:0]};
   assign f_next = e;
   assign g_next = f;
   assign h_next = g;

   assign h_out = mode? {a_next,b_next,c_next,d_next,e_next,f_next,g_next,h_next}:{256'h0,a_next[31:0],b_next[31:0],c_next[31:0],d_next[31:0],e_next[31:0],f_next[31:0],g_next[31:0],h_next[31:0]};

endmodule // h_roundFunction
