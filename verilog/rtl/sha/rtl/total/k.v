module k (/*AUTOARG*/
   // Outputs
   k,
   // Inputs
   round
   ) ;
   input [6:0]round;

   output [63:0] k;

   reg    [63:0] k;

   always @ (*) begin
      case(round)
		    7'd00 : begin
           k = 64'h428a2f98d728ae22;
        end
		    7'd01 : begin
           k = 64'h7137449123ef65cd;
        end
		    7'd02 : begin
           k = 64'hb5c0fbcfec4d3b2f;
        end
		    7'd03 : begin
           k = 64'he9b5dba58189dbbc;
        end
		    7'd04 : begin
           k = 64'h3956c25bf348b538;
        end
		    7'd05 : begin
           k = 64'h59f111f1b605d019;
        end
		    7'd06 : begin
           k = 64'h923f82a4af194f9b;
        end
		    7'd07 : begin
           k = 64'hab1c5ed5da6d8118;
        end
		    7'd08 : begin
           k = 64'hd807aa98a3030242;
        end
		    7'd09 : begin
           k = 64'h12835b0145706fbe;
        end
		    7'd10 : begin
           k = 64'h243185be4ee4b28c;
        end
		    7'd11 : begin
           k = 64'h550c7dc3d5ffb4e2;
        end
		    7'd12 : begin
           k = 64'h72be5d74f27b896f;
        end
		    7'd13 : begin
           k = 64'h80deb1fe3b1696b1;
        end
		    7'd14 : begin
           k = 64'h9bdc06a725c71235;
        end
		    7'd15 : begin
           k = 64'hc19bf174cf692694;
        end
		    7'd16 : begin
           k = 64'he49b69c19ef14ad2;
        end
		    7'd17 : begin
           k = 64'hefbe4786384f25e3;
        end
		    7'd18 : begin
           k = 64'h0fc19dc68b8cd5b5;
        end
		    7'd19 : begin
           k = 64'h240ca1cc77ac9c65;
        end
		    7'd20 : begin
           k = 64'h2de92c6f592b0275;
        end
		    7'd21 : begin
           k = 64'h4a7484aa6ea6e483;
        end
		    7'd22 : begin
           k = 64'h5cb0a9dcbd41fbd4;
        end
		    7'd23 : begin
           k = 64'h76f988da831153b5;
        end
		    7'd24 : begin
           k = 64'h983e5152ee66dfab;
        end
		    7'd25 : begin
           k = 64'ha831c66d2db43210;
        end
		    7'd26 : begin
           k = 64'hb00327c898fb213f;
        end
		    7'd27 : begin
           k = 64'hbf597fc7beef0ee4;
        end
		    7'd28 : begin
           k = 64'hc6e00bf33da88fc2;
        end
		    7'd29 : begin
           k = 64'hd5a79147930aa725;
        end
		    7'd30 : begin
           k = 64'h06ca6351e003826f;
        end
		    7'd31 : begin
           k = 64'h142929670a0e6e70;
        end
		    7'd32 : begin
           k = 64'h27b70a8546d22ffc;
        end
		    7'd33 : begin
           k = 64'h2e1b21385c26c926;
        end
		    7'd34 : begin
           k = 64'h4d2c6dfc5ac42aed;
        end
		    7'd35 : begin
           k = 64'h53380d139d95b3df;
        end
		    7'd36 : begin
           k = 64'h650a73548baf63de;
        end
		    7'd37 : begin
           k = 64'h766a0abb3c77b2a8;
        end
		    7'd38 : begin
           k = 64'h81c2c92e47edaee6;
        end
		    7'd39 : begin
           k = 64'h92722c851482353b;
        end
		    7'd40 : begin
           k = 64'ha2bfe8a14cf10364;
        end
		    7'd41 : begin
           k = 64'ha81a664bbc423001;
        end
		    7'd42 : begin
           k = 64'hc24b8b70d0f89791;
        end
		    7'd43 : begin
           k = 64'hc76c51a30654be30;
        end
		    7'd44 : begin
           k = 64'hd192e819d6ef5218;
        end
		    7'd45 : begin
           k = 64'hd69906245565a910;
        end
		    7'd46 : begin
           k = 64'hf40e35855771202a;
        end
		    7'd47 : begin
           k = 64'h106aa07032bbd1b8;
        end
		    7'd48 : begin
           k = 64'h19a4c116b8d2d0c8;
        end
		    7'd49 : begin
           k = 64'h1e376c085141ab53;
        end
		    7'd50 : begin
           k = 64'h2748774cdf8eeb99;
        end
		    7'd51 : begin
           k = 64'h34b0bcb5e19b48a8;
        end
		    7'd52 : begin
           k = 64'h391c0cb3c5c95a63;
        end
		    7'd53 : begin
           k = 64'h4ed8aa4ae3418acb;
        end
		    7'd54 : begin
           k = 64'h5b9cca4f7763e373;
        end
		    7'd55 : begin
           k = 64'h682e6ff3d6b2b8a3;
        end
		    7'd56 : begin
           k = 64'h748f82ee5defb2fc;
        end
		    7'd57 : begin
           k = 64'h78a5636f43172f60;
        end
		    7'd58 : begin
           k = 64'h84c87814a1f0ab72;
        end
		    7'd59 : begin
           k = 64'h8cc702081a6439ec;
        end
		    7'd60 : begin
           k = 64'h90befffa23631e28;
        end
		    7'd61 : begin
           k = 64'ha4506cebde82bde9;
        end
		    7'd62 : begin
           k = 64'hbef9a3f7b2c67915;
        end
		    7'd63 : begin
           k = 64'hc67178f2e372532b;
        end
		    7'd64 : begin
           k = 64'hca273eceea26619c;
        end
		    7'd65 : begin
           k = 64'hd186b8c721c0c207;
        end
		    7'd66 : begin
           k = 64'heada7dd6cde0eb1e;
        end
		    7'd67 : begin
           k = 64'hf57d4f7fee6ed178;
        end
		    7'd68 : begin
           k = 64'h06f067aa72176fba;
        end
		    7'd69 : begin
           k = 64'h0a637dc5a2c898a6;
        end
		    7'd70 : begin
           k = 64'h113f9804bef90dae;
        end
		    7'd71 : begin
           k = 64'h1b710b35131c471b;
        end
		    7'd72 : begin
           k = 64'h28db77f523047d84;
        end
		    7'd73 : begin
           k = 64'h32caab7b40c72493;
        end
		    7'd74 : begin
           k = 64'h3c9ebe0a15c9bebc;
        end
		    7'd75 : begin
           k = 64'h431d67c49c100d4c;
        end
		    7'd76 : begin
           k = 64'h4cc5d4becb3e42b6;
        end
		    7'd77 : begin
           k = 64'h597f299cfc657e2a;
        end
		    7'd78 : begin
           k = 64'h5fcb6fab3ad6faec;
        end
		    7'd79 : begin
           k = 64'h6c44198c4a475817;
        end
        default : k = 64'h0;
     endcase
   end
endmodule // k
