//-----------------------------------------------------------------------------
// Title         : cu
// Project       : AES
//-----------------------------------------------------------------------------
// File          : cu.v
// Author        :   <wlswo3149@hw>
// Created       : 03.06.2019
// Last modified : 03.06.2019
//-----------------------------------------------------------------------------
// Description :
// 
//-----------------------------------------------------------------------------
// Copyright (c) 2019 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 03.06.2019 : created
//-----------------------------------------------------------------------------


module cu (/*AUTOARG*/
   // Outputs
   init, done, ready,set,round, increase, wr_enable,last_key,
   // Inputs
   clk, rst_n, run, mode, enc, keygen
   ) ;
   input        clk;
   input        rst_n;
   input        run;
   input        enc;
   input [1:0]  mode;
   input        keygen;

   output       init;
   output       set;
   output       done;
   output       ready;
   output       increase;
   output [4:0] round;
   output      wr_enable;
   output      last_key;

   localparam ST_IDLE   = 4'b0001;
   localparam ST_SET    = 4'b0010;
   localparam ST_ENABLE = 4'b0100;
   localparam ST_DONE   = 4'b1000;
   localparam AES192    = 2'h2;
   localparam AES256    = 2'h3;

   reg [3:0]    state;
   reg [3:0]    next_state;
   reg          init;
   reg          set;
   reg          enable;
   reg          done;
   reg          ready;
   reg         increase;

   wire [4:0]   round;
   wire         round_last;
   wire         wr_enable;
   wire         last_key;

   assign wr_enable = (set|enable)&keygen;
   assign last_key = round_last;

   round_adder round_adder(/*AUTOINST*/
                           // Outputs
                           .round              (round[4:0]),
                           .round_last         (round_last),
                           // Inputs
                           .clk                (clk),
                           .rst_n              (rst_n),
                           .enc                (enc),
                           .init               (init),
                           .set                (set),
                           .enable             (enable),
                           .done               (done),
                           .mode               (mode[1:0]));

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         state <= ST_IDLE;
      end else begin
         state <= next_state;
      end
   end

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         increase <= 0;
      end else begin
         if(set) begin
            increase <= 1;
         end else if(round == round_last) begin
            increase <= 0;
         end
      end
   end // always @ (posedge clk or negedge rst_n)

   always @ (*) begin
      next_state = state;
      init = 0;
      set = 0;
      enable = 0;
      done = 0;
      ready = 0;
      case(state)
        ST_IDLE : begin
           ready = 1;
           if(run) begin
              init = 1;
              next_state = ST_SET;
           end
        end
        ST_SET : begin
           set = 1;
           next_state = ST_ENABLE;
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
      endcase // case(state)
   end
endmodule // cu
