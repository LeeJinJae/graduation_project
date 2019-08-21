module mem_ctrl (/*AUTOARG*/
   // Outputs
   rkey_out,
   // Inputs
   clk, rst_n, enc, rkey_in, key, init, wr_enable, increase, done, mode, last_key, set, keygen
   ) ;
   input clk;
   input rst_n;
   input  [127:0] rkey_in;
   input  [255:0] key;
   input  [1:0]   mode;
   input          init;
   input          enc;
   input          wr_enable;
   input          done;
   input          increase;
   input          last_key;
   input          set;
   input          keygen;

   output [127:0] rkey_out;

localparam AES192 = 2'h2;
localparam AES256 = 2'h3;

   reg   [3:0]   address;
   reg   [3:0]   last;

   wire   [127:0] rkey_out;
   wire   [3:0] next_address;
   wire   [3:0] before_address;

   assign next_address = (address == 4'he)? 4'h0 : address + 4'h1;
   assign before_address = (address == 4'h0)? 4'he : address - 4'h1;

   memory mem(/*AUTOINST*/
              // Outputs
              .data_out                 (rkey_out[127:0]),
              // Inputs
              .clk                      (clk),
              .rst_n                    (rst_n),
              .address                  (address[3:0]),
              .we                       (wr_enable),
              .data_in                  (rkey_in[127:0]));

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         address <= 4'h0;
      end else begin
         if(enc|keygen) begin
            if(init) begin
               address <= 4'h0;
            end else if(set|increase) begin
               address <= next_address;
            end
         end else begin
            if(init) begin
               address <= last;
            end else if(set|increase) begin
               address <= before_address;
            end            
         end
      end
   end

   always @ (*) begin
      case(mode)
        AES192 : begin
           last = 4'hC;
        end
        AES256 : begin
           last = 4'hE;
        end
        default : begin
           last = 4'hA;
        end
      endcase // case (mode)
   end // always @ (*)
   
endmodule // mem_ctrl
