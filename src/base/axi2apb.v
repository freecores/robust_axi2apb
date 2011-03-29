INCLUDE def_axi2apb.txt
  OUTFILE PREFIX_axi2apb.v

    ITER SX
      module  PREFIX_axi2apb (PORTS);

   input              clk;
   input              reset;

   port               GROUP_APB_AXI;
   
   //apb slaves
   output             penable;
   output             pwrite;
   output [ADDR_BITS-1:0] paddr;
   output [31:0]          pwdata;

   output                 pselSX;
   
   input [31:0]           prdataSX;
   
   input                  preadySX;
   
   input                  pslverrSX;



   wire                   GROUP_APB3;
   
   //outputs of cmd
   wire                   cmd_empty;
   wire                   cmd_read;
   wire [ID_BITS-1:0]     cmd_id;
   wire [ADDR_BITS-1:0]   cmd_addr;
   wire                   cmd_err;
   
   //outputs of rd / wr
   wire                   finish_wr;
   wire                   finish_rd;
   
   
   assign                 paddr  = cmd_addr;
   assign                 pwdata = WDATA;

   
   CREATE axi2apb_cmd.v
     PREFIX_axi2apb_cmd PREFIX_axi2apb_cmd(
					   .clk(clk),
					   .reset(reset),
					   .AWGROUP_APB_AXI_A(AWGROUP_APB_AXI_A),
					   .ARGROUP_APB_AXI_A(ARGROUP_APB_AXI_A),
					   .finish_wr(finish_wr),
					   .finish_rd(finish_rd),
					   .cmd_empty(cmd_empty),
					   .cmd_read(cmd_read),
					   .cmd_id(cmd_id),
					   .cmd_addr(cmd_addr),
					   .cmd_err(cmd_err)
                                           );

   
   CREATE axi2apb_rd.v
     PREFIX_axi2apb_rd PREFIX_axi2apb_rd(
					 .clk(clk),
					 .reset(reset),
					 .GROUP_APB3(GROUP_APB3),
					 .cmd_err(cmd_err),
					 .cmd_id(cmd_id),
					 .finish_rd(finish_rd),
					 .RGROUP_APB_AXI_R(RGROUP_APB_AXI_R),
                                         STOMP ,
					 );
   
   CREATE axi2apb_wr.v
     PREFIX_axi2apb_wr PREFIX_axi2apb_wr(
					 .clk(clk),
					 .reset(reset),
					 .GROUP_APB3(GROUP_APB3),
					 .cmd_err(cmd_err),
					 .cmd_id(cmd_id),
					 .finish_wr(finish_wr),
					 .WGROUP_APB_AXI_W(WGROUP_APB_AXI_W),
					 .BGROUP_APB_AXI_B(BGROUP_APB_AXI_B),
                                         STOMP ,
					 );
      
   CREATE axi2apb_mux.v
     PREFIX_axi2apb_mux PREFIX_axi2apb_mux(
					   .clk(clk),
					   .reset(reset),
					   .cmd_addr(cmd_addr),
					   .psel(psel),
					   .prdata(prdata),
					   .pready(pready),
					   .pslverr(pslverr),
					   .pselSX(pselSX),
					   .preadySX(preadySX),
					   .pslverrSX(pslverrSX),
					   .prdataSX(prdataSX),
					   STOMP ,
					   );

   
   CREATE axi2apb_ctrl.v						
     PREFIX_axi2apb_ctrl PREFIX_axi2apb_ctrl(
					     .clk(clk),
					     .reset(reset),
					     .finish_wr(finish_wr),			
					     .finish_rd(finish_rd),
					     .cmd_empty(cmd_empty),
					     .cmd_read(cmd_read),
					     .WVALID(WVALID),
					     .psel(psel),
					     .penable(penable),
					     .pwrite(pwrite),
					     .pready(pready)
					     );
   

endmodule


