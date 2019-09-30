`define C_S_AXI_DATA_WIDTH 32
`define C_S_AXI_ADDR_WIDTH 7
`define IDX(x) 32*(x+1)-1:32*x

module sha_axi (
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
	 localparam integer ADDR_MSB = 8;//`C_S_AXI_ADDR_WIDTH;

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
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg0;   // mode,ready,hash_ready
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg1;   // msg_len  4
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg2;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg3;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg4;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg5;   //msg_in    14
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg6;   //            18
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg7;   //            1c
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg8;   //             20
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg9;   //            24 
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg10;  //        28
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg11;  //    2c
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg12;  // 30
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg13;  // 34
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg14;  //  38
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg15;  // 3c
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg16;  // 40 
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg17;  // 44
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg18;  // 48
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg19;  // 4c
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg20;  // 50
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg21;  //  54  
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg22;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg23;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg24;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg25;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg26;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg27;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg28;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg29;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg30;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg31;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg32;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg33;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg34;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg35;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg36;
	 reg [`C_S_AXI_DATA_WIDTH-1:0] slv_reg37; //

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

   wire [383:0] result;
   wire mode;
   wire ready;
   wire hash_ready;
   wire [1023:0]                  msg_in;
   wire [127:0]                   msg_len;
   wire                          rst_n;

	 //I/O Connections assignments
	 assign 	mode 	         = slv_reg0[0];
   assign   msg_len        = {slv_reg1, slv_reg2, slv_reg3, slv_reg4};
   assign   msg_in    	   = {slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, slv_reg16,slv_reg17, slv_reg18, slv_reg19,
                              slv_reg20, slv_reg21, slv_reg22, slv_reg23, slv_reg24, slv_reg25, slv_reg26, slv_reg27, slv_reg28, slv_reg29, slv_reg30, slv_reg31, slv_reg32, slv_reg33, slv_reg34,
                              slv_reg35, slv_reg36};
   assign   rst_n          = S_AXI_ARESETN & (!clear);
   assign   next_clk_count = slv_reg37 + 32'h1;


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
                    slv_reg37 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
                end
                else begin
                     if(clear) begin
                        slv_reg37 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
                     end else if(flag_clk_counter) begin
                         slv_reg37 <= next_clk_count;
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
		     slv_reg19 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg20 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg21 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg22 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg23 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg24 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg25 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg26 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg27 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg28 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg29 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg30 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg31 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg32 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg33 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg34 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg35 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     slv_reg36 <= {`C_S_AXI_DATA_WIDTH{1'b0}};
		     clear <= 0;
		  end else begin
			   if (slv_reg_wren) begin
				    case ( axi_awaddr[ADDR_MSB-1:ADDR_LSB] )
					    6'h0 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
					    end
					    6'h1 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
					    end
					    6'h2 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
                        end
					    6'h3 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
						      end
              end
					    6'h4 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    6'h5 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    6'h6 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    6'h7 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
							end
					    6'h8 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg8[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
							end
					    6'h09 : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg9[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    6'h0A : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg10[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    6'h0B : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg11[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    6'h0C : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg12[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
             end
					    6'h0D : begin
						    for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							    if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								     slv_reg13[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							    end
              end
					    6'h0E : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg14[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h0F : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg15[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h10 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg16[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h11 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg17[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h12 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg18[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h13 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg19[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h14 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg20[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h15 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg21[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h16 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg22[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h17 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg23[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h18 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg24[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h19 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg25[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h1A : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg26[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h1B : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg27[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h1C : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg28[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h1D : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg29[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h1E : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg30[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h1F : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg31[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h20 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg32[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h21 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg33[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h22 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg34[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h23 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg35[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
              end
					    6'h24 : begin
						     for ( byte_index = 0; byte_index <= (`C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
							     if ( S_AXI_WSTRB[byte_index] == 1 ) begin
								      slv_reg36[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
							     end
                 run <= 1;
              end
					    6'h25 : begin
              end
					    6'h26 : begin
                 clear <= 1;
              end
					    default : begin
					    end
				    endcase
			   end
         if(run) begin
	          run  <= 0;
            flag_clk_counter <= 1;
         end
         if(ready|hash_ready) begin
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
			 6'h00   : reg_data_out <= {ready,hash_ready,29'h0,slv_reg0[0]};
			 6'h01   : reg_data_out <= slv_reg1;
			 6'h02   : reg_data_out <= slv_reg2;
			 6'h03   : reg_data_out <= slv_reg3;
			 6'h04   : reg_data_out <= slv_reg4;
			 6'h05   : reg_data_out <= slv_reg5;
			 6'h06   : reg_data_out <= slv_reg6;
			 6'h07   : reg_data_out <= slv_reg7;
			 6'h08   : reg_data_out <= slv_reg8;
			 6'h09   : reg_data_out <= slv_reg9;
			 6'h0A   : reg_data_out <= slv_reg10;
			 6'h0B   : reg_data_out <= slv_reg11;
			 6'h0C   : reg_data_out <= slv_reg12;
			 6'h0D   : reg_data_out <= slv_reg13;
			 6'h0E   : reg_data_out <= slv_reg14;
			 6'h0F   : reg_data_out <= slv_reg15;
			 6'h10   : reg_data_out <= slv_reg16;
			 6'h11   : reg_data_out <= slv_reg17;
			 6'h12   : reg_data_out <= slv_reg18;
			 6'h13   : reg_data_out <= slv_reg19;
			 6'h14   : reg_data_out <= slv_reg20;
			 6'h15   : reg_data_out <= slv_reg21;
			 6'h16   : reg_data_out <= slv_reg22;
			 6'h17   : reg_data_out <= slv_reg23;
			 6'h18   : reg_data_out <= slv_reg24;
			 6'h19   : reg_data_out <= slv_reg25;
			 6'h1A   : reg_data_out <= slv_reg26;
			 6'h1B   : reg_data_out <= slv_reg27;
			 6'h1C   : reg_data_out <= slv_reg28;
			 6'h1D   : reg_data_out <= slv_reg29;
			 6'h1E   : reg_data_out <= slv_reg30;
			 6'h1F   : reg_data_out <= slv_reg31;
			 6'h20   : reg_data_out <= slv_reg32;
			 6'h21   : reg_data_out <= slv_reg33;
			 6'h22   : reg_data_out <= slv_reg34;
			 6'h23   : reg_data_out <= slv_reg35;
			 6'h24   : reg_data_out <= slv_reg36;
			 6'h25   : reg_data_out <= slv_reg37;
			 6'h26   : reg_data_out <= 32'hffffffff;
       6'h27   : reg_data_out <= result[`IDX(11)];
       6'h28   : reg_data_out <= result[`IDX(10)];
       6'h29   : reg_data_out <= result[`IDX(9)];
       6'h2A   : reg_data_out <= result[`IDX(8)];
       6'h2B   : reg_data_out <= result[`IDX(7)];
       6'h2C   : reg_data_out <= result[`IDX(6)];
       6'h2D   : reg_data_out <= result[`IDX(5)];
       6'h2E   : reg_data_out <= result[`IDX(4)];
       6'h2F   : reg_data_out <= result[`IDX(3)];
       6'h30   : reg_data_out <= result[`IDX(2)];
       6'h31   : reg_data_out <= result[`IDX(1)];
       6'h32   : reg_data_out <= result[`IDX(0)];
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

   sha_top sha_top(/*AUTOINST*/
                   // Outputs
                   .hash_code           (result[383:0]),
                   .ready               (ready),
                   .hash_ready          (hash_ready),
                   // Inputs
                   .msg_in              (msg_in[1023:0]),
                   .clk                 (S_AXI_ACLK),
                   .rst_n               (rst_n),
                   .run                 (run),
                   .msg_len             (msg_len[127:0]),
                   .mode                (mode));

endmodule // sha_axi
