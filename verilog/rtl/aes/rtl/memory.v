module memory (/*AUTOARG*/
   // Outputs
   data_out,
   // Inputs
   clk, rst_n, address, we, data_in
   ) ;
   input        clk;
   input        rst_n;
   input  [3:0] address;
   input        we;
   input [127:0] data_in;

   output  [127:0] data_out;

   reg   [127:0] mem[0:14];
   reg   [127:0]   data_out;

   always @ (posedge clk or negedge rst_n) begin
        if(!rst_n) begin
           data_out <= 0;
        end else begin
           data_out <= mem[address];
        end
    end

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         mem[0] <= 128'h0;
         mem[1] <= 128'h0;
         mem[2] <= 128'h0;
         mem[3] <= 128'h0;
         mem[4] <= 128'h0;
         mem[5] <= 128'h0;
         mem[6] <= 128'h0;
         mem[7] <= 128'h0;
         mem[8] <= 128'h0;
         mem[9] <= 128'h0;
         mem[10] <= 128'h0;
         mem[11] <= 128'h0;
         mem[12] <= 128'h0;
         mem[13] <= 128'h0;
         mem[14] <= 128'h0;
      end else begin // if (!rst_n)
         if(we) begin
            mem[address] <= data_in;
         end
      end // else: !if(!rst_n)
   end

endmodule // memory
