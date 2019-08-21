module functionT (/*AUTOARG*/
   // Outputs
   w_,
   // Inputs
   w, round, clk, rst_n,init,mode
   ) ;
   input  [31:0] w;
   input  [4:0] round;
   input            clk;
   input            rst_n;
   input            init;
   input [1:0]  mode;

   output [31:0] w_;

   localparam AES192 = 2'h2;
   localparam AES256 = 2'h3;

   wire   [7:0]  B0, B1, B2, B3;
   wire   [7:0]  next_rcon;
   wire   [1:0]  round_192;
   wire          round_256;

   reg   [31:0] w_;
   reg   [7:0] A0, A1, A2, A3;
   reg   [7:0] rcon;

   localparam RC1 = 8'b00000001;
   localparam RC9 = 8'b00011011;

   assign round_192 = round%3;
   assign round_256 = round%2;
   assign next_rcon = rcon << 1;

   sbox s0(
           // Outputs
           .out                         (B0[7:0]),
           // Inputs
           .in                          (A0[7:0]));
   sbox s1(
           // Outputs
           .out                         (B1[7:0]),
           // Inputs
           .in                          (A1[7:0]));
   sbox s2(
           // Outputs
           .out                         (B2[7:0]),
           // Inputs
           .in                          (A2[7:0]));
   sbox s3(
           // Outputs
           .out                         (B3[7:0]),
           // Inputs
           .in                          (A3[7:0]));

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
        rcon <= 8'h0;
      end else begin
         if(init) begin
            rcon <= RC1;
         end else begin
            if(mode == AES192) begin
                  if(round_192 != 2'h2) begin
                     rcon <= next_rcon;
                  end
            end else if(mode == AES256)begin
                  if(round_256 != 1'h1) begin
                     rcon <= next_rcon;
                  end
            end else begin
                  if(round == 4'h8) begin
                     rcon <= RC9;
                  end else begin
                     rcon <= next_rcon;
                  end
            end
       end
     end
  end

   always @ (*) begin
      case(mode)
        AES256 : begin
           case(round_256)
              1'h0 : begin
                 A0 = w[23:16];
                 A1 = w[15:8];
                 A2 = w[7:0];
                 A3 = w[31:24];
              end
              1'h1 : begin
                 A0 = w[31:24];
                 A1 = w[23:16];
                 A2 = w[15:8];
                 A3 = w[7:0];
              end
           endcase
        end
        default : begin
           A0 = w[23:16];
           A1 = w[15:8];
           A2 = w[7:0];
           A3 = w[31:24];
        end
      endcase
   end
   
   always @ (*) begin
      case(mode)
         AES256 :  begin
            case(round_256) 
            1'h0 : begin
                  w_ = {B0^rcon,B1,B2,B3};
            end
            1'h1 : begin
                  w_ = {B0,B1,B2,B3};
            end
            endcase
         end
         default : begin
            w_ = {B0^rcon,B1,B2,B3};
         end
      endcase
   end
endmodule // functionT
