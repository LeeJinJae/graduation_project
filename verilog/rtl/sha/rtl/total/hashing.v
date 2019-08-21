module hashing (/*AUTOARG*/
   // Outputs
   hash_fin, ready, done,
   // Inputs
   M, clk, rst_n, run, H_in, mode
   ) ;
   input  [1023:0] M;
   input          clk;
   input          rst_n;
   input          run;
   input  [511:0] H_in;
   input          mode;

   output [511:0] hash_fin;
   output         ready;
   output         done;

   wire           init;
   wire           enable;
   wire           done;
   wire           ready;
   wire   [6:0] round;
   wire   [63:0] K;
   wire   [63:0] W;
   wire   [511:0] H_out;
   wire   [511:0] hash_fin;
   
   reg    [511:0] routing;

   cu cu(/*AUTOINST*/
         // Outputs
         .init                          (init),
         .enable                        (enable),
         .done                          (done),
         .ready                         (ready),
         .round                         (round),
         // Inputs
         .clk                           (clk),
         .rst_n                         (rst_n),
         .mode                          (mode),
         .run                           (run));

   k key(
         // Outputs
         .k                             (K[63:0]),
         // Inputs
         .round                         (round[6:0]));

   m_schedule m_schedule(
                         // Outputs
                         .w                     (W[63:0]),
                         // Inputs
                         .M                     (M[1023:0]),
                         .clk                   (clk),
                         .rst_n                 (rst_n),
                         .mode                  (mode),
                         .round                 (round[6:0]));

   rounding rounding(/*AUTOINST*/
                     // Outputs
                     .hash_out         (H_out),
                     .hash_fin       (hash_fin),
                     // Inputs
                     .K                 (K[63:0]),
                     .W                 (W[63:0]),
                     .clk               (clk),
                     .rst_n             (rst_n),
                     .routing           (routing[511:0]),
                     .H_in              (H_in),
                     .init              (init),
                     .mode              (mode),
                     .done              (done));
                     
   always @ (posedge clk or negedge rst_n) begin
     if(!rst_n) begin
        routing <= 0;
     end else begin
        if(init) begin
            routing <= H_in;
        end else begin
            routing <= H_out;
        end
     end
   end                 
    
endmodule // hashing
