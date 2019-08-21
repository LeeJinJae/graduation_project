module m_schedule (/*AUTOARG*/
   // Outputs
   w,
   // Inputs
   M, clk, rst_n, round
   ) ;
   input  [511:0] M;
   input          clk;
   input          rst_n;
   input  [5:0] round;

   output [31:0]  w;

   reg   [31:0] w;
   reg   [511:0] mid_w;

   wire [31:0]  delta0;
   wire [31:0]  delta1;
   wire [31:0]  w2,w7,w15,w16;
   wire [31:0]  wt;

   assign w2 = mid_w[63:32];
   assign w7 = mid_w[223:192];
   assign w15 = mid_w[479:448];
   assign w16 = mid_w[511:480];
   assign delta0 = {w15[6:0],w15[31:7]}^{w15[17:0],w15[31:18]}^{3'h0,w15[31:3]};
   assign delta1 = {w2[16:0],w2[31:17]}^{w2[18:0],w2[31:19]}^{10'h0,w2[31:10]};
   assign wt = delta1+w7+delta0+w16;

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         mid_w <= 512'h0;
      end else begin
         if(round==6'd15) begin
            mid_w <= M;
         end else begin
            mid_w <= {mid_w[480:0],wt};
         end
      end
   end

   always @ (*) begin
      case(round)
        6'd0: begin
           w = M[511:480];
        end
        6'd1: begin
           w = M[479:448];
        end
        6'd2: begin
           w = M[447:416];
        end
        6'd3: begin
           w = M[415:384];
        end
        6'd4: begin
           w = M[383:352];
        end
        6'd5: begin
           w = M[351:320];
        end
        6'd6: begin
           w = M[319:288];
        end
        6'd7: begin
           w = M[287:256];
        end
        6'd8: begin
           w = M[255:224];
        end
        6'd9: begin
           w = M[223:192];
        end
        6'd10: begin
           w = M[191:160];
        end
        6'd11: begin
           w = M[159:128];
        end
        6'd12: begin
           w = M[127:96];
        end
        6'd13: begin
           w = M[95:64];
        end
        6'd14: begin
           w = M[63:32];
        end
        6'd15: begin
           w = M[31:0];
        end
        default: begin
           w = wt;
        end
     endcase
   end
endmodule // m_schedule
