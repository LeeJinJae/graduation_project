`define C_S_AXI_DATA_WIDTH 32
`define C_S_AXI_ADDR_WIDTH 7
`define IDX(x) 32*(x+1)-1:32*x

module aes_axi (
	////////////////////////////////////////////////////////////////////////////
	// System Signals
	input wire                             S_AXI_ACLK,
	input wire                             S_AXI_ARESETN,

	////////////////////////////////////////////////////////////////////////////
	// Slave Interface Write Address
	input wire [`C_S_AXI_ADDR_WIDTH - 1:0] S_AXI_AWADDR,
	input wire                             S_AXI_AWVALID,
	output wire                            S_AXI_AWREADY,

	////////////////////////////////////////////////////////////////////////////
	// Slave Interface Write Data
	input wire [`C_S_AXI_DATA_WIDTH-1:0]   S_AXI_WDATA,
	input wire [`C_S_AXI_DATA_WIDTH/8-1:0] S_AXI_WSTRB,
	input wire                             S_AXI_WVALID,
	output wire                            S_AXI_WREADY,

	////////////////////////////////////////////////////////////////////////////
	// Slave Interface Write Response
	output wire [1:0]                      S_AXI_BRESP,
	output wire                            S_AXI_BVALID,
	input wire                             S_AXI_BREADY,

	////////////////////////////////////////////////////////////////////////////
	// Slave Interface Read Address
	input wire [`C_S_AXI_ADDR_WIDTH - 1:0] S_AXI_ARADDR,
	input wire                             S_AXI_ARVALID,
	output wire                            S_AXI_ARREADY,
 
	////////////////////////////////////////////////////////////////////////////
	// Master Interface Read Data
	output wire [`C_S_AXI_DATA_WIDTH-1:0]  S_AXI_RDATA,
	output wire [1:0]                      S_AXI_RRESP,
	output wire                            S_AXI_RVALID,
	input wire                             S_AXI_RREADY
	);

	 function integer clogb2 (input integer bd);
	    integer                            bit_depth;
	    begin
		     bit_depth = bd;
		     for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
			     bit_depth = bit_depth >> 1;
	    end
	 endfunction

	 localparam integer ADDR_LSB = clogb2(`C_S_AXI_DATA_WIDTH/8)-1;
	 localparam integer ADDR_MSB = `C_S_AXI_ADDR_WIDTH;

	 // AXI4 Lite internal signals
	 reg [1 :0]         axi_rresp;
	 reg [1 :0]         axi_bresp;
	 reg                axi_awready;
	 reg                axi_wready;
	 reg                axi_bvalid;
	 reg                axi_rvalid;
	 reg [ADDR_MSB-1:0] axi_awaddr;
	 reg [ADDR_MSB-1:0] axi_araddr;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] axi_rdata;
	 reg                           axi_arready;

	 // Slave register
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg0;   //mode,enc,fin
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg1;   //iv
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg2;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg3;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg4;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg5;   //key
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg6;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg7;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg8;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg9;   
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg10;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg11;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg12;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg13;  //blk_in
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg14;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg15;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg16;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg17;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg18;

	 // Slave register read enable
	 wire                          slv_reg_rden;

	 // Slave register write enable
	 wire                          slv_reg_wren;
	 wire       [31:0]             next_clk_count;

	 // register read data
	 reg [`C_S_AXI_DATA_WIDTH-1:0] reg_data_out;
	 integer                       byte_index;

	 //User Define Sig
	 reg                           flag_clk_counter;
	 reg                           clear;
     reg                           run;
	 
   wire [127:0] result;
   wire [1:0] mode;
   wire enc;
   wire fin;
   wire ready;
	 wire [255:0]                  key;
	 wire [127:0]                  msg_in;
   wire [127:0]                  iv;
   wire                          rst_n;
   wire                          keygen;
   wire                          encrypt;



	 //I/O Connections assignments
	 assign   enc            = slv_reg0[0];
	 assign 	mode 	         = slv_reg0[2:1];//KEY128=2'b01,KEY192=2'b10,KEY256=2'b11, key_op[0]=1(enc),key_op[0]=0(dec)
   assign   fin            = slv_reg0[3];
   assign   msg_in    	   = {slv_reg13, slv_reg14, slv_reg15, slv_reg16};
   assign   key            = {slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12};
   assign   iv             = {slv_reg1, slv_reg2, slv_reg3, slv_reg4};
   assign   rst_n          = S_AXI_ARESETN & (!clear);
   assign   next_clk_count = slv_reg18 + 32'h1;


	////////////////////////////////////////////////////////////////////////////
	//Write Address Ready (AWREADY)
	assign S_AXI_AWREADY = axi_awready;

	////////////////////////////////////////////////////////////////////////////
	//Write Data Ready(WREADY)
	assign S_AXI_WREADY  = axi_wready;

	////////////////////////////////////////////////////////////////////////////
	//Write Response (BResp)and response valid (BVALID)
	assign S_AXI_BRESP  = axi_bresp;
	assign S_AXI_BVALID = axi_bvalid;

	////////////////////////////////////////////////////////////////////////////
	//Read Address Ready(AREADY)
	assign S_AXI_ARREADY = axi_arready;

	////////////////////////////////////////////////////////////////////////////
	//Read and Read Data (RDATA), Read Valid (RVALID) and Response (RRESP)
	assign S_AXI_RDATA  = axi_rdata;
	assign S_AXI_RVALID = axi_rvalid;
	assign S_AXI_RRESP  = axi_rresp;


	////////////////////////////////////////////////////////////////////////////
	// Implement axi_awready generation
	always @( posedge S_AXI_ACLK )
		begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_awready <= 1'b0;
		end else begin
			if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID) begin
				axi_awready <= 1'b1;
			end else begin
				axi_awready <= 1'b0;
			end
		end
	end

	////////////////////////////////////////////////////////////////////////////
	// Implement axi_awaddr latching
	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_awaddr <= 0;
		end else begin
			if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
			begin
				axi_awaddr <= S_AXI_AWADDR;
			end
		end
	end

	////////////////////////////////////////////////////////////////////////////
	// Implement axi_wready generation

	 always @( posedge S_AXI_ACLK ) begin
	    if ( S_AXI_ARESETN == 1'b0 ) begin
		     axi_wready <= 1'b0;
	    end else begin
		     if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID)
			     begin
				      axi_wready <= 1'b1;
			     end else begin
				      axi_wready <= 1'b0;
			     end
		  end
	 end
     
      always @( posedge S_AXI_ACLK ) begin
               if ( S_AXI_ARESETN == 1'b0 ) begin
                    slv_reg18 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
                end
                else begin
                     if(clear) begin
                        slv_reg18 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
                     end else if(flag_clk_counter) begin
                         slv_reg18 <= next_clk_count;
                     end
                end
         end
	 ////////////////////////////////////////////////////////////////////////////
	 // Implement memory mapped register select and write logic generation
	 assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
	 always @( posedge S_AXI_ACLK ) begin
		  if ( S_AXI_ARESETN == 1'b0 || clear == 1) begin
			   slv_reg0 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
			   slv_reg1 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
			   slv_reg2 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
			   slv_reg3 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
			   slv_reg4 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
			   slv_reg5 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
			   slv_reg6 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
			   slv_reg7 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg8 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg9 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg10 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg11 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg12 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg13 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg14 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg15 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg16 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg17 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg18 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     clear <= 0;
		  end else begin
			   if (slv_reg_wren) begin
				    case ( axi_awaddr[ADDR_MSB-1:ADDR_LSB] )
					    5'h0 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
					    end
					    5'h1 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
					    end
					    5'h2 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
                        end
					    5'h3 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
						      end
              end
					    5'h4 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    5'h5 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    5'h6 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    5'h7 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
							end
					    5'h8 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg8[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
							end
					    5'h09 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg9[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    5'h0A : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg10[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    5'h0B : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg11[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    5'h0C : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg12[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
                                run <= 1;
              end
					    5'h0D : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg13[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    5'h0E : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg14[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    5'h0F : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg15[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    5'h10 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg16[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
                                 run <= 1;
              end
					    5'h11 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg17[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
                 clear<=1;
              end
					    default : begin
					    end
				    endcase
			   end
         //if(fin&ready) begin
         //   slv_reg0[3] <= 0;
         //end
         if(run) begin
	    run  <= 0;
            flag_clk_counter <= 1;
         end
         if(ready) begin
            flag_clk_counter <=0;
         end
		 end
	    end

	////////////////////////////////////////////////////////////////////////////
	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_bvalid  <= 0;
			axi_bresp   <= 2'b0;
		end	else begin
			if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
				axi_bvalid <= 1'b1;
				axi_bresp  <= 2'b0; // 'OKAY' response
			end else begin
				if (S_AXI_BREADY && axi_bvalid) begin
					axi_bvalid <= 1'b0;
				end
			end
		end
	end


	////////////////////////////////////////////////////////////////////////////
	// Implement axi_arready generation
	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_arready <= 1'b0;
			axi_araddr  <= {ADDR_MSB{1'b0}};
		end	else begin
			if (~axi_arready && S_AXI_ARVALID) begin
				axi_arready <= 1'b1;
				axi_araddr  <= S_AXI_ARADDR;
			end else begin
				axi_arready <= 1'b0;
			end
		end
	end

	////////////////////////////////////////////////////////////////////////////
	// Implement memory mapped register select and read logic generation
	always @( posedge S_AXI_ACLK ) begin
		if ( S_AXI_ARESETN == 1'b0 ) begin
			axi_rvalid <= 0;
			axi_rresp  <= 0;
		end	else begin
			if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
				axi_rvalid <= 1'b1;
				axi_rresp  <= 2'b0; // 'OKAY' response
			end else if (axi_rvalid && S_AXI_RREADY) begin
				axi_rvalid <= 1'b0;
			end
		end
	end


	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

	always @(*) begin
		 case ( axi_araddr[ADDR_MSB-1:ADDR_LSB] )
			 5'h00   : reg_data_out <= {ready,keygen,encrypt,25'h0,slv_reg0[3:0]};
			 5'h01   : reg_data_out <= slv_reg1;
			 5'h02   : reg_data_out <= slv_reg2;
			 5'h03   : reg_data_out <= slv_reg3;
			 5'h04   : reg_data_out <= slv_reg4;
			 5'h05   : reg_data_out <= slv_reg5;
			 5'h06   : reg_data_out <= slv_reg6;
			 5'h07   : reg_data_out <= slv_reg7;
			 5'h08   : reg_data_out <= slv_reg8;
			 5'h09   : reg_data_out <= slv_reg9;
			 5'h0A   : reg_data_out <= slv_reg10;
			 5'h0B   : reg_data_out <= slv_reg11;
			 5'h0C   : reg_data_out <= slv_reg12;
			 5'h0D   : reg_data_out <= slv_reg13;
			 5'h0E   : reg_data_out <= slv_reg14;
			 5'h0F   : reg_data_out <= slv_reg15;
			 5'h10   : reg_data_out <= slv_reg16;
			 5'h11   : reg_data_out <= 32'h11111111;
			 5'h12   : reg_data_out <= slv_reg18;
             5'h13   : reg_data_out <= result[`IDX(3)];
             5'h14   : reg_data_out <= result[`IDX(2)];
             5'h15   : reg_data_out <= result[`IDX(1)];
             5'h16   : reg_data_out <= result[`IDX(0)];
			 default : reg_data_out <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		 endcase
	end

	 always @( posedge S_AXI_ACLK ) begin
		  if ( S_AXI_ARESETN == 1'b0 ) begin
			   axi_rdata  <= 0;
		  end else begin
			   if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
				    axi_rdata <= reg_data_out;
			   end
		  end
	 end

   aes_top aes_top(/*AUTOINST*/
                   // Outputs
                   .result              (result[127:0]),
                   .ready               (ready),
                   .keygen              (keygen),
                   .encrypt             (encrypt),
                   // Inputs
                   .clk                 (S_AXI_ACLK),
                   .rst_n               (rst_n),
                   .run                 (run),
                   .fin                 (fin),
                   .msg_in              (msg_in[127:0]),
                   .key                 (key[255:0]),
                   .mode                (mode[1:0]),
                   .enc                 (enc),
                   .iv                  (iv[127:0]));
   

endmodule // aes_axi
