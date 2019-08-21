module aes_top (/*AUTOARG*/
   // Outputs
   result, ready,keygen, encrypt,
   // Inputs
   clk, rst_n, run, fin, msg_in, key, mode, enc, iv
   ) ;
   input  clk;
   input  rst_n;
   input  run;
   input  fin;
   input  [127:0] msg_in;
   input  [255:0] key;
   input  [1:0] mode;
   input  enc;
   input [127:0] iv;

   output [127:0] result;
   output         ready;
   output keygen;
   output encrypt;

   reg [127:0]    xvar;
   reg [127:0]    result;
   
   wire           core_ready;
   wire           core_rst_n;
   wire [127:0]   cbc_in;
   wire [127:0]   cbc_out;
   wire [127:0]   msg_out;
   wire           keygen;
   wire           encrypt;
   wire           decrypt;
   wire           done;
   wire           ready;
   wire           cu_ready;
   wire           iv_done;
   wire           core_done;

   assign ready = core_ready;
   assign core_rst_n = rst_n & !done;
   assign cbc_in = enc? xvar^msg_in:msg_in;
   assign cbc_out = enc? msg_out:xvar^msg_out;

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         xvar <= 128'h0;
      end else begin
         if(keygen) begin
            xvar <= iv;
         end else if(encrypt&iv_done) begin
            xvar <= msg_out;
         end else if(decrypt&iv_done) begin
            xvar <= msg_in;
         end
      end
   end // always @ (posedge clk or negedge rst_n)
   
   always @ (posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            result <= 128'h0;
        end else begin
            if(iv_done) begin
                result <= cbc_out;
            end
        end
    end
    

           aes_total aes_core(
                              // Outputs
                              .aes_out          (msg_out[127:0]),
                              .ready            (core_ready),
                              .done             (core_done),
                              // Inputs
                              .clk              (clk),
                              .rst_n            (core_rst_n),
                              .key              (key[255:0]),
                              .aes_in           (cbc_in[127:0]),
                              .run              (run),
                              .mode             (mode[1:0]),
                              .enc              (enc),
                              .keygen           (keygen));

   MOO_cu MOO_cu(
                 // Outputs
                 .ready                 (cu_ready),
                 .keygen                (keygen),
                 .encrypt               (encrypt),
                 .decrypt               (decrypt),
                 .done                  (done),
                 .iv_done               (iv_done),
                 // Inputs
                 .clk                   (clk),
                 .rst_n                 (rst_n),
                 .run                   (run),
                 .enc                   (enc),
                 .fin                   (fin),
                 .core_done             (core_done),
                 .core_ready            (core_ready));

endmodule // aes_top
