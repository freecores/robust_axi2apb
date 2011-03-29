INCLUDE def_axi2apb.txt
OUTFILE PREFIX_axi2apb_rd.v

module  PREFIX_axi2apb_rd (PORTS);

   input 		          clk;
   input 		          reset;

   input                  GROUP_APB3;
      
   input                  cmd_err;
   input [ID_BITS-1:0]    cmd_id;
   output                 finish_rd;
   
   port                   RGROUP_APB_AXI_R;
   
   
   parameter              RESP_OK     = 2'b00;
   parameter              RESP_SLVERR = 2'b10;
   parameter              RESP_DECERR = 2'b11;
   
   reg                    RGROUP_APB_AXI_R.OUT;
   
   
   assign                 finish_rd = RVALID & RREADY & RLAST;
   
   always @(posedge clk or posedge reset)
     if (reset)
	   begin
         RGROUP_APB_AXI_R.OUT <= #FFD {GROUP_APB_AXI_R.OUT.WIDTH{1'b0}};
	   end
	 else if (finish_rd)
	   begin
         RGROUP_APB_AXI_R.OUT <= #FFD {GROUP_APB_AXI_R.OUT.WIDTH{1'b0}};
	   end
	 else if (psel & penable & (~pwrite) & pready)
	   begin
	     RID    <= #FFD cmd_id;
		 RDATA  <= #FFD prdata;
		 RRESP  <= #FFD cmd_err ? RESP_SLVERR : pslverr ? RESP_DECERR : RESP_OK;
		 RLAST  <= #FFD 1'b1;
		 RVALID <= #FFD 1'b1;
	   end
	   
endmodule

   
