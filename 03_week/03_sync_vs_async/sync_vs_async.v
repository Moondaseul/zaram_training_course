// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: sync_vs_async.v
//	* Date			: 2025-03-17 10:53:08
//	* Description	: 
// ==================================================

module dff_sync
#(
	parameter	BW_DATA	= 32
)
(
	output reg [BW_DATA-1:0]	o_q,
	input	   [BW_DATA-1:0]	i_d,
	input						i_clk,
	input						i_rstn
);

	always @(posedge i_clk) begin
		if(!i_rstn) begin
			o_q <= 1'b0;
		end else begin
			o_q <= i_d;
		end
	end
endmodule

module dff_async
#(
	parameter	BW_DATA	= 32
)
(
	output reg [BW_DATA-1:0]	o_q,
	input	   [BW_DATA-1:0]    i_d,
	input						i_clk,
	input       				i_rstn
);

	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			o_q <= 1'b0;
		end else begin
			o_q <= i_d;
		end
	end
endmodule

