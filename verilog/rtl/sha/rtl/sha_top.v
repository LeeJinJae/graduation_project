module sha_top (/*AUTOARG*/
   // Inputs
   msg_in, clk, rst_n, run, msg_len,
   // Outputs
   hash_code, ready
   ) ;
   input [511:0] msg_in;
   input         clk;
   input         rst_n;
   input         run;
   input [63:0]  msg_len;

   output [255:0] hash_code;
   output         ready;

   wire          hash_ready;
   wire          hash_done;
   wire          ready;
   wire          init;
   wire          hash;
   wire          done;
   wire [63:0]   next_len_count;
   wire [63:0]   pad_count;
   wire [63:0]   zero_count;
   wire [255:0]  hash_fin;

   reg [63:0]    i;
   reg [63:0]    j;
   reg [511:0]   M;
   reg [63:0]    len_count;
   reg           fin;
   reg [255:0]   hash_code;
   reg           n_paded;
   reg [255:0]   H_in;

   localparam H0 = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;

   assign next_len_count = (len_count<64'd512)? 64'h0 : len_count - 64'd512;
   assign pad_count = 64'd512 - len_count - 64'h1;
   assign zero_count = pad_count - 64'h1;
   hashing hashing(/*AUTOINST*/
                   // Outputs
                   .hash_fin               (hash_fin[255:0]),
                   .ready               (hash_ready),
                   .done                (hash_done),
                   // Inputs
                   .M                   (M[511:0]),
                   .clk                 (clk),
                   .rst_n               (rst_n),
                   .run                 (init|(run&(!ready))|(!n_paded)),
                   .H_in                (H_in[255:0]));
   sha_cu cu(/*AUTOINST*/
             // Outputs
             .ready                     (ready),
             .init                      (init),
             .hash                      (hash),
             .done                      (done),
             // Inputs
             .clk                       (clk),
             .rst_n                     (rst_n),
             .fin                       (fin),
             .hash_done                 (hash_done),
             .run                       (run));

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         H_in <= 256'h0;
      end else begin
         if(ready) begin
            H_in <= H0;
         end else if(hash_done) begin
            H_in <= hash_fin;
         end
      end
   end

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         hash_code <= 256'h0;
      end else begin
         if(init) begin
            hash_code <= 256'h0;
         end else if(hash_done&fin) begin
            hash_code <= hash_fin;
         end
      end
   end

   always @(posedge clk or negedge rst_n) begin
     if(hash_done) begin
        len_count <= next_len_count;
     end else if((!hash)&run) begin
        len_count <= msg_len;
     end         
   end // always @ (posedge clk or negedge rst_n)
   
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         M <= 512'h0;
      end else begin
         if(hash_ready&(!ready)) begin
             if(len_count < 64'd448) begin
                for(i=511;i>pad_count;i=i-1) begin
                    M[i] <= msg_in[i];
                end
                M[pad_count] <= 1'b1;
                for(j=zero_count;j>63;j=j-1) begin
                    M[j] <= 1'b0;
                end
                M[63:0] <= msg_len;
             end else if(len_count < 64'd512) begin
                for(i=511;i>pad_count;i=i-1) begin
                    M[i] <= msg_in[i];
                end
                M[pad_count] <= 1'b1;
                for(j=zero_count;j>=0;j=j-1) begin
                    M[j] <= 1'b0;
                end          
             end else if(len_count == 64'h0) begin
                if(n_paded) begin
                    M <= {448'h0,msg_len};
                end else begin
                    M <= {1'b1,447'h0,msg_len};
                end
             end else begin
                M <= msg_in;
             end
         end
      end
   end // always @ (posedge clk or negedge rst_n)

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         fin <= 0;
      end else begin
         if((!ready)&(len_count < 64'd448)) begin
            fin <= 1;
         end else if((!ready)&(len_count == 64'h0)) begin
            fin <= 1;
         end else if(hash_done|ready) begin
            fin <= 0;
         end
      end
   end // always @ (posedge clk or negedge rst_n)
   
   always @ (posedge clk or negedge rst_n) begin
     if(!rst_n) begin
        n_paded <= 1;
     end else begin
        if(len_count == 64'd512) begin
            n_paded <= 0;
        end else begin
            n_paded <= 1;
        end
     end
   end
   
endmodule // sha_top
