// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: spsram.v
//	* Date			: 2025-03-17 13:59:31
//	* Description	: 
// ==================================================

module spsram
#(
	parameter BW_DATA  =  32, // momory bandwidth
	parameter BW_ADDR  =  4   // address bandwidth
)
(
	output	[BW_DATA-1:0] o_data,
	input   [BW_DATA-1:0] i_data,
	input   [BW_ADDR-1:0] i_addr,
	input				  i_cen, // chip enable (active high)
	input 				  i_wen, // write enable (active high)
	input  				  i_oen, // output enable (active high)
	input 				  i_clk
);

	// Memory Write
    reg [BW_DATA-1:0] mem[0:2**BW_ADDR-1];
	always @(posedge i_clk) begin
		if(i_cen && i_wen) begin
			mem[i_addr] <= i_data;
		end else begin
			mem[i_addr] <= mem[i_addr];
		end
	end

	// Memory Read
	`ifdef SPSRAM_ASYNC
		assign o_data = !i_oen ? 'bz :
						i_cen && !i_wen ? mem[i_addr] : 'bx;
	`else
		reg [BW_DATA-1:0] o_data;
		always @(posedge i_clk) begin
			if(i_oen) begin
				if(i_cen && !i_wen) begin
					o_data <= mem[i_addr];
				end else begin
					o_data <= 'bx;
				end
			end else begin
				o_data <= 'bz;
			end
		end
	`endif
endmodule

