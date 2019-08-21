module aes_total (/*AUTOARG*/
   // Outputs
   aes_out,ready,done,
   // Inputs
   clk, rst_n, key, aes_in, run, mode, enc, keygen
   ) ;
   input clk;
   input rst_n;
   input [255:0] key;
   input [127:0] aes_in;
   input         run;
   input [1:0]   mode;
   input         enc;
   input         keygen;

   output [127:0] aes_out;
   output         ready;
   output         done;

   wire [127:0] roundkey;
   wire [127:0] mem_roundkey;
   wire [4:0]   round;
   wire         init;
   wire         set;
   wire         done;
   wire         ready;
   wire         wr_enable;
   wire         increase;
   wire [127:0] aes_out;
   wire [127:0] plain;
   wire [127:0] cipher;
   wire          last_key;

   assign aes_out = enc?cipher:plain;

   inv_roundFunction inv_roundFunction(
                               // Outputs
                               .plain           (plain[127:0]),
                               // Inputs
                               .roundKey        (mem_roundkey[127:0]),
                               .round           (round[4:0]),
                               .mode            (mode[1:0]),
                               .cipher          (aes_in[127:0]),
                               .done            (done),
                               .clk             (clk),
                               .keygen     (keygen),
                               .rst_n           (rst_n),
                               .init            (init),
                               .enc            (enc),
                               .set             (set));
   
   roundFunction roundFunction(
                               // Outputs
                               .cipher          (cipher[127:0]),
                               // Inputs
                               .roundKey        (mem_roundkey[127:0]),
                               .round           (round[4:0]),
                               .clk             (clk),
                               .keygen     (keygen),
                               .rst_n           (rst_n),
                               .init            (init),
                               .set             (set),
                               .done            (done),
                               .enc               (enc),
                               .mode            (mode[1:0]),
                               .plain           (aes_in[127:0]));
   
   keyExpansion keyExpansion(
                             // Outputs
                             .roundkey          (roundkey[127:0]),
                             // Inputs
                             .round             (round[4:0]),
                             .key               (key[255:0]),
                             .clk               (clk),
                             .init              (init),
                             .set               (set),
                             .mode              (mode[1:0]),
                             .rst_n             (rst_n));
   
   mem_ctrl mem_ctrl(
                 // Outputs
                 .rkey_out              (mem_roundkey[127:0]),
                 // Inputs
                 .key                   (key[255:0]),
                 .rkey_in               (roundkey[127:0]),
                 .mode                (mode[1:0]),
                 .init                   (init),
                 .wr_enable    (wr_enable),
                 .increase              (increase),
                 .last_key               (last_key),
                 .done                  (done),
                 .rst_n                 (rst_n),
                 .enc                  (enc),
                 .set                   (set),
                 .keygen                (keygen),
                 .clk                   (clk));

   cu cu(
         // Outputs
         .init                          (init),
         .set                           (set),
         .done                          (done),
         .ready                         (ready),
         .wr_enable                      (wr_enable),
         .increase                      (increase),
         .last_key                        (last_key),
         .round                         (round[4:0]),
         // Inputs
         .clk                           (clk),
         .rst_n                         (rst_n),
         .run                           (run),
         .enc                           (enc),
         .keygen                        (keygen),
         .mode                          (mode[1:0]));
endmodule // aes_total
