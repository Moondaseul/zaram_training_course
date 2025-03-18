// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: spsram_doubled.v
//	* Date			: 2025-03-17 15:04:52
//	* Description	: 
// ==================================================

`include	"spsram.v"

module spsram_doubled
(
	output [31:0]	o_data,
	input  [31:0]	i_data,
	input  [4:0]    i_addr,
	input 			i_cen,
	input    		i_wen,
	input 			i_oen,
	input  			i_clk
);

	spsram
	#(
		.BW_DATA (32),
		.BW_ADDR (4 )
	)
	u_spsram_0(
		.o_data (o_data     ),
		.i_data (i_data     ),
		.i_addr (i_addr[3:0]),
		.i_cen  (~i_addr[4] ),
		.i_wen  (i_wen      ),
		.i_oen  (~i_addr[4] ),
		.i_clk  (i_clk 		)
	);
	
	spsram
	#(
		.BW_DATA (32),
		.BW_ADDR (4 )
	)
	u_spsram_1(
		.o_data (o_data     ),
		.i_data (i_data		),
		.i_addr (i_addr[3:0]),
		.i_cen  (~i_addr[4] ),
		.i_wen  (i_wen		),
		.i_oen  (~i_addr[4] ),
		.i_clk  (i_clk		)
	);

endmodule




