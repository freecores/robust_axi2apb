INCLUDE def_axi2apb.txt
OUTFILE PREFIX_axi2apb_cmd.v

module  PREFIX_axi2apb_cmd (PORTS);

   input 		          clk;
   input 		          reset;

   port                   AWGROUP_APB_AXI_A;
   port                   ARGROUP_APB_AXI_A;
   input                  finish_wr;
   input                  finish_rd;
         
   output                 cmd_empty;
   output                 cmd_read;
   output [ID_BITS-1:0]   cmd_id;
   output [ADDR_BITS-1:0] cmd_addr;
   output                 cmd_err;
   
   
   wire                   AGROUP_APB_AXI_A;
   
   wire                   cmd_push;
   wire                   cmd_pop;
   reg                    read;
   
   
   assign                 wreq = AWVALID;
   assign                 rreq = ARVALID;
   assign                 wack = AWVALID & AWREADY;
   assign                 rack = ARVALID & ARREADY;
         
   always @(posedge clk or posedge reset)
     if (reset)
       read <= #FFD 1'b1;
     else if (wreq & (rack | (~rreq)))
       read <= #FFD 1'b0;
     else if (rreq & (wack | (~wreq)))
       read <= #FFD 1'b1;

	//command mux
	assign AGROUP_APB_AXI_A = read ? ARGROUP_APB_AXI_A : AWGROUP_APB_AXI_A;
	assign AERR   = (ASIZE != 'd2) | (ALEN != 'd0); //support only 32 bit single AXI commands
   
   assign ARREADY = (~cmd_full) & read;
   assign AWREADY = (~cmd_full) & (~read);
   
    assign 		      cmd_push  = AVALID & AREADY;
    assign 		      cmd_pop   = cmd_read ? finish_rd : finish_wr;
   
CREATE prgen_fifo.v DEFCMD(SWAP CONST(#FFD) #FFD)
   prgen_fifo #(ID_BITS+ADDR_BITS+2, CMD_DEPTH) 
   cmd_fifo(
	    .clk(clk),
	    .reset(reset),
	    .push(cmd_push),
	    .pop(cmd_pop),
	    .din({
			AID,
			AADDR,
			AERR,
			read
			}
		 ),
	    .dout({
			cmd_id,
			cmd_addr,
			cmd_err,
			cmd_read
			}
		  ),
	    .empty(cmd_empty),
	    .full(cmd_full)
	    );

		
   
endmodule


