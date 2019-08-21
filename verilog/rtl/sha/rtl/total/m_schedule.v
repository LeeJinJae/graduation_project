module m_schedule (/*AUTOARG*/
   // Outputs
   w,
   // Inputs
   M, clk, rst_n, round, mode
   ) ;
   input  [1023:0] M;
   input          clk;
   input          rst_n;
   input  [6:0] round;
   input        mode;

   output [63:0]  w;

   reg   [63:0] w;
   reg   [1023:0] mid_w;

   wire [63:0]  delta0;
   wire [63:0]  delta1;
   wire [63:0]  w2,w7,w15,w16;
   wire [63:0]  wt;

   assign w2     = mode? mid_w[127:64]:{32'h0,mid_w[63:32]};
   assign w7     = mode? mid_w[447:384]:{32'h0,mid_w[223:192]};
   assign w15    = mode? mid_w[959:896]:{32'h0,mid_w[479:448]};
   assign w16    = mode? mid_w[1023:960]:{32'h0,mid_w[511:480]};
   assign delta0 = mode? ({w15[0],w15[63:1]}^{w15[7:0],w15[63:8]}^{7'h0,w15[63:7]}):({32'h0,{w15[6:0],w15[31:7]}^{w15[17:0],w15[31:18]}^{3'h0,w15[31:3]}});
   assign delta1 = mode? ({w2[18:0],w2[63:19]}^{w2[60:0],w2[63:61]}^{6'h0,w2[63:6]}):({32'h0,{w2[16:0],w2[31:17]}^{w2[18:0],w2[31:19]}^{10'h0,w2[31:10]}});
   assign wt     = mode? (delta1+w7+delta0+w16):{32'h0,(delta1[31:0]+w7[31:0]+delta0[31:0]+w16[31:0])};

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         mid_w <= 1024'h0;
      end else begin
         if(round==7'd15) begin
            if(mode) begin
               mid_w <= M;
            end else begin
               mid_w <= {512'h0,M[511:0]};
            end
         end else begin
            if(mode) begin
               mid_w <= {mid_w[959:0],wt};
            end else begin
               mid_w <= {512'h0,mid_w[480:0],wt[31:0]};
            end
         end
      end
   end

   always @ (*) begin
      case(round)
        6'd0: begin
           if(mode) begin
              w = M[1023:960];
           end else begin
              w = {32'h0,M[511:480]};
           end
        end
        6'd1: begin
           if(mode) begin
              w = M[959:896];
           end else begin
              w = {32'h0,M[479:448]};
           end
        end
        6'd2: begin
           if(mode) begin
              w = M[895:832];
           end else begin
              w = {32'h0,M[447:416]};
           end
        end
        6'd3: begin
           if(mode) begin
              w = M[831:768];
           end else begin
              w = {32'h0,M[415:384]};
           end
        end
        6'd4: begin
           if(mode) begin
              w = M[767:704];
           end else begin
              w = {32'h0,M[383:352]};
           end
        end
        6'd5: begin
           if(mode) begin
              w = M[703:640];
           end else begin
              w = {32'h0,M[351:320]};
           end
        end
        6'd6: begin
           if(mode) begin
              w = M[639:576];
           end else begin
              w = {32'h0,M[319:288]};
           end
        end
        6'd7: begin
           if(mode) begin
              w = M[575:512];
           end else begin
              w = {32'h0,M[287:256]};
           end
        end
        6'd8: begin
           if(mode) begin
              w = M[511:448];
           end else begin
              w = {32'h0,M[255:224]};
           end
        end
        6'd9: begin
           if(mode) begin
              w = M[447:384];
           end else begin
              w = {32'h0,M[223:192]};
           end
        end
        6'd10: begin
           if(mode) begin
              w = M[383:320];
           end else begin
              w = {32'h0,M[191:160]};
           end
        end
        6'd11: begin
           if(mode) begin
              w = M[319:256];
           end else begin
              w = {32'h0,M[159:128]};
           end
        end
        6'd12: begin
           if(mode) begin
              w = M[255:192];
           end else begin
              w = {32'h0,M[127: 96]};
           end
        end
        6'd13: begin
           if(mode) begin
              w = M[191:128];
           end else begin
              w = {32'h0,M[ 95: 64]};
           end
        end
        6'd14: begin
           if(mode) begin
              w = M[127: 64];
           end else begin
              w = {32'h0,M[ 63: 32]};
           end
        end
        6'd15: begin
           if(mode) begin
              w = M[ 63:  0];
           end else begin
              w = {32'h0,M[ 31:  0]};
           end
        end
        default: begin
           w = wt;
        end
     endcase
   end
endmodule // m_schedule
