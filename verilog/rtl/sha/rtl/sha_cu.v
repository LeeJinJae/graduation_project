module sha_cu (/*AUTOARG*/
   // Outputs
   ready, init, hash, done,
   // Inputs
   clk, rst_n, run, fin, hash_done
   ) ;
   input          clk;
   input          rst_n;
   input          run;
   input          fin;
   input          hash_done;

   output         ready;
   output         init;
   output         hash;
   output         done;

   reg [4:0]      state;
   reg [4:0]      next_state;
   reg            ready;
   reg            init;
   reg            set;
   reg            hash;
   reg            done;

   localparam ST_IDLE = 4'b0001;
   localparam ST_INIT = 4'b0010;
   localparam ST_HASH = 4'b0100;
   localparam ST_DONE = 4'b1000;

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
       state <= ST_IDLE;
      end else begin
       state <= next_state;
      end
   end

   always @ (*) begin
      next_state = state;
      ready = 0;
      init = 0;
      hash = 0;
      done = 0;
      case(state)
        ST_IDLE : begin
           ready = 1;
           if(run) begin
              next_state = ST_INIT;
           end
        end
        ST_INIT : begin
           init = 1;
           if(init) begin
             hash = 1;
             next_state = ST_HASH;
           end
        end
        ST_HASH : begin
           hash = 1;
           if(fin&&hash_done) begin
              next_state = ST_DONE;
           end
        end
        ST_DONE : begin
           done = 1;
           next_state = ST_IDLE;
        end
      endcase // case (state)
   end

endmodule // sha_cu
