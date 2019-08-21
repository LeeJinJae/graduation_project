module hashing (/*AUTOARG*/
   // Outputs
   hash_fin, ready, done,
   // Inputs
   M, clk, rst_n, run, H_in
   ) ;
   input  [511:0] M;
   input          clk;
   input          rst_n;
   input          run;
   input  [255:0] H_in;

   output [255:0] hash_fin;
   output         ready;
   output         done;

   wire           init;
   wire           enable;
   wire           done;
   wire           ready;
   wire   [5:0] round;
   wire   [31:0] K;
   wire   [31:0] W;
   wire   [255:0] H_out;
   wire   [255:0] hash_fin;
   
   reg    [255:0] routing;

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
         .run                           (run));

   k key(
         // Outputs
         .k                             (K[31:0]),
         // Inputs
         .round                         (round[5:0]));

   m_schedule m_schedule(
                         // Outputs
                         .w                     (W[31:0]),
                         // Inputs
                         .M                     (M[511:0]),
                         .clk                   (clk),
                         .rst_n                 (rst_n),
                         .round                 (round[5:0]));

   rounding rounding(/*AUTOINST*/
                     // Outputs
                     .hash_out         (H_out),
                     .hash_fin       (hash_fin),
                     // Inputs
                     .K                 (K[31:0]),
                     .W                 (W[31:0]),
                     .clk               (clk),
                     .rst_n             (rst_n),
                     .routing           (routing[255:0]),
                     .H_in              (H_in),
                     .init              (init),
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
