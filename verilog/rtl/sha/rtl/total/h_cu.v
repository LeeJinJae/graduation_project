module h_cu (/*AUTOARG*/
   // Outputs
   init, enable, done, ready, round,
   // Inputs
   clk, rst_n, run, mode
   ) ;
   input  clk;
   input  rst_n;
   input  run;
   input  mode;

   output init;
   output enable;
   output done;
   output ready;
   output round;

   localparam ST_IDLE     = 3'b001;
   localparam ST_ENABLE   = 3'b010;
   localparam ST_DONE     = 3'b100;

   reg   [3:0] state;
   reg   [3:0] next_state;
   reg         init;
   reg         enable;
   reg         done;
   reg         ready;

   wire   [6:0] round;
   wire         round_last;

   h_round_adder h_round_adder(/*AUTOINST*/
                           // Outputs
                           .round               (round),
                           .round_last      (round_last),
                           // Inputs
                           .clk                 (clk),
                           .rst_n               (rst_n),
                           .mode                (mode),
                           .init                (init));

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         state <= ST_IDLE;
      end else begin
         state <= next_state;
      end
   end

   always @ (*) begin
      next_state = state;
      init = 0;
      enable = 0;
      done = 0;
      ready = 0;
      case(state)
        ST_IDLE : begin
           ready = 1;
           if(run) begin
              init = 1;
              next_state = ST_ENABLE;
           end
        end
        ST_ENABLE : begin
           enable = 1;
           if(round_last) begin
              next_state = ST_DONE;
           end
        end
        ST_DONE : begin
           done = 1;
           next_state = ST_IDLE;
        end
      endcase // case (state)
   end
endmodule // cu
