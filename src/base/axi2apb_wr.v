INCLUDE def_axi2apb.txt
OUTFILE PREFIX_axi2apb_wr.v

module  PREFIX_axi2apb_wr (PORTS);

   input 		          clk;
   input 		          reset;
   
   input                  GROUP_APB3;
      
   input                  cmd_err;
   input [ID_BITS-1:0]    cmd_id;
   output                 finish_wr;
   
   port                   WGROUP_APB_AXI_W;
   port                   BGROUP_APB_AXI_B;
   
   
   parameter              RESP_OK     = 2'b00;
   parameter              RESP_SLVERR = 2'b10;
   parameter              RESP_DECERR = 2'b11;
   
   reg                    BGROUP_APB_AXI_B.OUT;
   
   
   assign                 finish_wr = BVALID & BREADY;
   
   assign                 WREADY = psel & penable & pwrite & pready;
   
   always @(posedge clk or posedge reset)
     if (reset)
	   begin
         BGROUP_APB_AXI_B.OUT <= #FFD {GROUP_APB_AXI_B.OUT.WIDTH{1'b0}};
	   end
	 else if (finish_wr)
	   begin
         BGROUP_APB_AXI_B.OUT <= #FFD {GROUP_APB_AXI_B.OUT.WIDTH{1'b0}};
	   end
	 else if (psel & penable & pwrite & pready)
	   begin
	     BID    <= #FFD cmd_id;
		 BRESP  <= #FFD cmd_err ? RESP_SLVERR : pslverr ? RESP_DECERR : RESP_OK;
		 BVALID <= #FFD 1'b1;
	   end
	   
endmodule

   
