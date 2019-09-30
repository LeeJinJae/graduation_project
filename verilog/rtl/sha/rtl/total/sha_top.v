module sha_top (/*AUTOARG*/
   // Inputs
   msg_in, clk, rst_n, run, msg_len,mode,
   // Outputs
   hash_code, ready, hash_ready
   ) ;
   input [1023:0] msg_in;
   input         clk;
   input         rst_n;
   input         run;
   input [127:0] msg_len;
   input         mode;

   output [383:0] hash_code;
   output         ready;
   output         hash_ready;

   wire          hash_ready;
   wire          hash_done;
   wire          ready;
   wire          init;
   wire          hash;
   wire          done;
   wire [127:0]   next_len_count;
   wire [127:0]   pad_count;
   wire [127:0]   zero_count;
   wire [511:0]  hash_fin;
   wire [1023:0] msg;
   wire [1023:0] one;

   reg [10:0]    i;
   reg [10:0]    j;
   reg [1023:0]   M;
   reg [127:0]    len_count;
   reg           fin;
   reg [383:0]   hash_code;
   reg           n_paded;
   reg [511:0]   H_in;
   reg           last_run;

   localparam H0_256 = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;
   localparam H0_384 = 512'hcbbb9d5dc1059ed8629a292a367cd5079159015a3070dd17152fecd8f70e593967332667ffc00b318eb44a8768581511db0c2e0d64f98fa747b5481dbefa4fa4;
   localparam one_mask = 1024'h1;
   localparam mask = ~(1024'h0);
   
   assign msg = mode? msg_in&(mask<<(128'd1024-len_count[127:3])):msg_in&(mask<<(128'd512-len_count[127:3]));
   assign one = mode? msg|(one_mask<<(128'd1024-len_count-128'h1)):msg|(one_mask<<(128'd512-len_count-128'h1)); // bit unit
   assign next_len_count = mode? ((len_count<128'd1024)? 128'h0:len_count - 128'd1024):((len_count<128'd512)? 128'h0 : len_count - 128'd512);
   assign pad_count = mode? (128'd1024 - len_count - 128'h1):(128'd512 - len_count - 128'h1);
   assign zero_count = pad_count - 128'h1;
   hashing hashing(/*AUTOINST*/
                   // Outputs
                   .hash_fin            (hash_fin[511:0]),
                   .ready               (hash_ready),
                   .done                (hash_done),
                   // Inputs
                   .M                   (M[1023:0]),
                   .clk                 (clk),
                   .rst_n               (rst_n),
                   .mode                (mode),
                   .run                 (init|(run&(!ready))|last_run),
                   .H_in                (H_in[511:0]));
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
         H_in <= 512'h0;
      end else begin
         if(ready) begin
            if(mode) begin
                H_in <= H0_384;
            end else begin
                H_in <= {256'h0,H0_256};
            end
         end else if(hash_done) begin
            H_in <= hash_fin;
         end
      end
   end
   
   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         last_run <= 0;
      end else begin
         if(mode) begin
           if(len_count > 128'd895 && len_count < 128'd1025) begin
              last_run <= 1;
           end else if(len_count == 0) begin
              last_run <= 0;
           end
         end else begin
           if(len_count > 128'd447 && len_count < 128'd513) begin
            last_run <= 1;
           end else if(len_count == 0) begin
            last_run <= 0;
           end
         end
      end
   end            

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         hash_code <= 384'h0;
      end else begin
         if(init) begin
            hash_code <= 384'h0;
         end else if(hash_done&fin) begin
            if(mode) begin
               hash_code <= hash_fin[511:128];
            end else begin
               hash_code <= {hash_fin[255:0],128'h0};
            end
         end
      end
   end

   always @(posedge clk or negedge rst_n) begin
     if(!rst_n) begin
        len_count <= 128'h0;
     end else begin   
         if(hash_done) begin
            len_count <= next_len_count;
         end else if((!hash)&run) begin
            len_count <= msg_len;
         end
     end
   end // always @ (posedge clk or negedge rst_n)

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         M <= 1024'h0;
      end else begin
         if(mode) begin
            if(hash_ready&(!ready)) begin
               if(msg_len[127:0] == 0) begin
                M <= {1'b1,1023'h0};              
               end else if(len_count == 128'h0) begin
                   if(n_paded) begin
                      M <= {896'h0,msg_len};
                   end else begin
                      M <= {1'b1,895'h0,msg_len};
                   end            
               end else if(len_count < 128'd896) begin
                  M[1023:0] <= {one[1023:128],msg_len};
               end else if(len_count < 128'd1024) begin
                  M[1023:0] <= one[1023:0];
               end else begin
                  M <= msg_in;
               end
            end
         end else begin
            if(hash_ready&(!ready)) begin
               if(msg_len[127:0] == 0) begin
                   M <= {512'h0,1'b1,511'h0};                   
               end else if(len_count == 128'h0) begin
                   if(n_paded) begin
                      M <= {960'h0,msg_len[63:0]};
                   end else begin
                      M <= {512'h0,1'b1,447'h0,msg_len[63:0]};
                   end            
               end else if(len_count < 128'd448) begin
                  M[1023:0] <= {one[1023:64],msg_len[63:0]};
               end else if(len_count < 128'd512) begin
                  M[1023:0] <= one[1023:0];
               end else begin
                  M <= msg_in;
               end
            end
         end
      end
   end // always @ (posedge clk or negedge rst_n)

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         fin <= 0;
      end else begin
         if(mode) begin
            if((!ready)&(len_count < 128'd896)) begin
               fin <= 1;
            end else if((!ready)&(len_count == 128'h0)) begin
               fin <= 1;
            end else if(hash_done|ready) begin
               fin <= 0;
            end
         end else begin
            if((!ready)&(len_count < 128'd448)) begin
               fin <= 1;
            end else if((!ready)&(len_count == 128'h0)) begin
               fin <= 1;
            end else if(hash_done|ready) begin
               fin <= 0;
            end
         end
      end
   end // always @ (posedge clk or negedge rst_n)
   
   always @ (posedge clk or negedge rst_n) begin
     if(!rst_n) begin
        n_paded <= 1;
     end else begin
        if(mode) begin
           if(len_count == 128'd1024) begin
              n_paded <= 0;
           end else begin
              n_paded <= 1;
           end
        end else begin
           if(len_count == 128'd512) begin
              n_paded <= 0;
           end else begin
              n_paded <= 1;
           end
        end
     end
   end
   
endmodule // sha_top
