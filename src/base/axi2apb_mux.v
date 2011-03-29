INCLUDE def_axi2apb.txt
OUTFILE PREFIX_axi2apb_mux.v

ITER SX
module  PREFIX_axi2apb_mux (PORTS);


   input 		      clk;
   input                      reset;
   
   input [ADDR_BITS-1:0]      cmd_addr;
   
   input                      psel;
   output [31:0]              prdata;
   output                     pready;
   output                     pslverr;
   
   output                     pselSX;
   
   input                      preadySX;
   
   input                      pslverrSX;

   input [31:0]               prdataSX;
   

   
   parameter                  ADDR_MSB = EXPR(ADDR_BITS-1);
   parameter                  ADDR_LSB = EXPR(ADDR_BITS-DEC_BITS);
   
   reg                        pready;
   reg                        pslverr_pre;
   reg                        pslverr;
   reg [31:0]                 prdata_pre;
   reg [31:0]                 prdata;
   
   reg [SLV_BITS-1:0]         slave_num;
   
   always @(*)
     begin
	casex (cmd_addr[ADDR_MSB:ADDR_LSB])
	  DEC_ADDRSX : slave_num = SLV_BITS'dSX;
	  
	  default : slave_num = SLV_BITS'dSLAVE_NUM; //decode error
	endcase
     end
   
   assign                     pselSX = psel & (slave_num == SLV_BITS'dSX);
			  
   always @(*)
     begin
	   case (slave_num)
	     SLV_BITS'dSX: pready = preadySX;
		 default : pready = 1'b1; //decode error
           endcase
	 end
   
   always @(*)
     begin
	   case (slave_num)
	     SLV_BITS'dSX: pslverr_pre = pslverrSX;
		 default : pslverr_pre = 1'b1; //decode error
           endcase
	 end
   
   always @(*)
     begin
	   case (slave_num)
	     SLV_BITS'dSX: prdata_pre = prdataSX;
		 default : prdata_pre = {32{1'b0}};
           endcase
	 end
   
   
   always @(posedge clk or posedge reset)
     if (reset)
	   begin
         prdata  <= #FFD {32{1'b0}};
         pslverr <= #FFD 1'b0;
	   end
	 else if (psel & pready)
	   begin
         prdata  <= #FFD prdata_pre;
         pslverr <= #FFD pslverr_pre;
	   end
	 else if (~psel)
	   begin
         prdata  <= #FFD {32{1'b0}};
         pslverr <= #FFD 1'b0;
	   end
   
endmodule

   
