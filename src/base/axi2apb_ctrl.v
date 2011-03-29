
INCLUDE def_axi2apb.txt
OUTFILE PREFIX_axi2apb_ctrl.v

module  PREFIX_axi2apb_ctrl (PORTS);


   input              clk;
   input              reset;

   input              finish_wr;
   input              finish_rd;
   
   input              cmd_empty;
   input              cmd_read;
   input              WVALID;

   output 		      psel;
   output 		      penable;
   output 		      pwrite;
   input 		      pready;
   
   
   wire	 		      wstart;
   wire                       rstart;
   
   reg                        busy;
   reg                        psel;
   reg 			      penable;
   reg 			      pwrite;
   wire                       pack;
   wire                       cmd_ready;
   

   assign                     cmd_ready = (~busy) & (~cmd_empty);
   assign                     wstart = cmd_ready & (~cmd_read) & (~psel) & WVALID;
   assign                     rstart = cmd_ready & cmd_read & (~psel);
   
   assign             pack = psel & penable & pready;
   
   always @(posedge clk or posedge reset)
     if (reset)
       busy <= #FFD 1'b0;
     else if (psel)
       busy <= #FFD 1'b1;
     else if (finish_rd | finish_wr)
       busy <= #FFD 1'b0;
   
   always @(posedge clk or posedge reset)
     if (reset)
       psel <= #FFD 1'b0;
     else if (pack)
       psel <= #FFD 1'b0;
     else if (wstart | rstart)
       psel <= #FFD 1'b1;
   
   always @(posedge clk or posedge reset)
     if (reset)
       penable <= #FFD 1'b0;
     else if (pack)
       penable <= #FFD 1'b0;
     else if (psel)
       penable <= #FFD 1'b1;

   always @(posedge clk or posedge reset)
     if (reset)
       pwrite  <= #FFD 1'b0;
     else if (pack)
       pwrite  <= #FFD 1'b0;
     else if (wstart)
       pwrite  <= #FFD 1'b1;
   

endmodule

   
