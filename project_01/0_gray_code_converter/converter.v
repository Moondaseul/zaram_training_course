// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: converter.v
//	* Date			: 2025-03-18 11:06:20
//	* Description	: 
// ==================================================

module bin_to_gray
#(
	parameter BW_DATA = 8
)
(
	output [BW_DATA-1:0] o_data,
	input  [BW_DATA-1:0] i_data
);

	assign o_data[BW_DATA-1] = i_data[BW_DATA-1];

	genvar i;
	generate
		for (i=0; i<BW_DATA-1; i=i+1) begin
			assign o_data[i] = i_data[i+1] ^ i_data[i];
		end
	endgenerate

endmodule

module gray_to_bin
#(
	parameter BW_DATA = 8
)
(
	output [BW_DATA-1:0] o_data,
	input  [BW_DATA-1:0] i_data
);

	assign o_data[BW_DATA-1] = i_data[BW_DATA-1];

	genvar i;
	generate 
		for (i=BW_DATA-2; i>=0; i=i-1) begin
			assign o_data[i] = o_data[i+1] ^ i_data[i];
		end
	endgenerate

endmodule
	
