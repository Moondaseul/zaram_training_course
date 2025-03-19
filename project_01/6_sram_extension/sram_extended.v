// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: sram_extended.v
//	* Date			: 2025-03-19 12:40:44
//	* Description	: 
// ==================================================

`include "spsram.v"

module sram_extended
(
	output [63:0] o_data,
	input  [63:0] i_data,
	input  [5:0]  i_addr,
	input 	 	  i_cen,
	input		  i_wen,
	input		  i_oen,
	input 		  i_clk
);

	genvar row,col;
	generate 
		for(row=0; row<4; row=row+1) begin
			for(col=0; col<2; col=col+1) begin
				spsram
				#(
					.BW_DATA (32),
					.BW_ADDR (4)
				)
				u_spsram(
					.o_data (o_data[32*(col+1)-1-:32]        ),
					.i_data (i_data[32*(col+1)-1-:32]		 ),
					.i_addr (i_addr[3:0]				     ),
					.i_cen  (i_addr[5:4] == row ? 1'b1 : 1'b0),
					.i_wen  (i_wen							 ),
					.i_oen  (i_addr[5:4] == row ? 1'b1 : 1'b0),
					.i_clk  (i_clk						     )
				);
			end
		end
	endgenerate

endmodule

