module MOO_cu (/*AUTOARG*/
   // Outputs
   ready, keygen, encrypt, decrypt, done, iv_done,
   // Inputs
   clk, rst_n, run, fin, core_ready, enc, core_done
   ) ;
   input  clk;
   input  rst_n;
   input  run;
   input  fin;
   input  enc;
   input  core_ready;
   input  core_done;

   output ready;
   output keygen;
   output encrypt;
   output decrypt;
   output done;
   output iv_done;

   localparam ST_IDLE   = 5'b00001;
   localparam ST_KEYGEN = 5'b00010;
   localparam ST_ENC    = 5'b00100;
   localparam ST_DEC    = 5'b01000;
   localparam ST_DONE   = 5'b10000;

   reg   [4:0] state;
   reg   [4:0] next_state;
   reg         iv_done;
   reg        ready;
   reg        keygen;
   reg        encrypt;
   reg        decrypt;
   reg        final;
   reg        done;
   

   wire [4:0]  sel;

   assign sel = enc? ST_ENC : ST_DEC;

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         state <= ST_IDLE;
      end else begin
         state <= next_state;
      end
   end
   
   always @ (posedge clk or negedge rst_n) begin
     if(!rst_n) begin
        iv_done <= 0;
     end else begin
        if((encrypt|decrypt)&core_done) begin
            iv_done <= 1;
        end else begin
            iv_done <= 0;
        end
     end
   end   

  always @ (*) begin
     next_state = state;
     ready = 0;
     keygen = 0;
     encrypt = 0;
     decrypt = 0;
     done = 0;
     case(state)
       ST_IDLE : begin
          ready = 1;
          if(run) begin
             keygen = 1;
             next_state = ST_KEYGEN;
          end
       end
       ST_KEYGEN : begin
          keygen = 1;
          if(core_ready) begin
             next_state = sel;
          end
       end
       ST_ENC : begin
          encrypt = 1;
          if(fin&core_ready) begin
             final = 1;
          end else if(final&core_ready) begin
             final = 0;
             next_state = ST_DONE;
          end
       end
       ST_DEC : begin
          decrypt = 1;
          if(fin&core_ready) begin
             final = 1;
          end else if(final&core_ready) begin
             final = 0;
             next_state = ST_DONE;
          end
       end
       ST_DONE : begin
          done = 1;
          next_state = ST_IDLE;
       end
     endcase // case (state)
  end //  @ (*)

endmodule // MOO_cu
