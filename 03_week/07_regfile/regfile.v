// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: regfile.v
//	* Date			: 2025-03-17 15:33:00
//	* Description	: 
// ==================================================

module regfile
#(
	parameter MIF_FILE = "regfile.mif",
	parameter BW_DATA  = 32,
	parameter BW_ADDR  = 5
)
(
	output [BW_DATA-1:0] o_rd_data0,
	output [BW_DATA-1:0] o_rd_data1,
	input  [BW_ADDR-1:0] i_rd_addr0,
	input  [BW_ADDR-1:0] i_rd_addr1,
	input  [BW_DATA-1:0] i_wr_data,
	input  [BW_ADDR-1:0] i_wr_addr,
	input				 i_wr_en,
	input 				 i_clk
);

	reg [BW_DATA-1:0] rf_arr[0:2**BW_ADDR-1];
	`ifdef MEM_INIT
		initial begin 
			$readmemb(MIF_FILE, rf_arr);
		end
	`endif

	assign o_rd_data0 = rf_arr[i_rd_addr0];
	assign o_rd_data1 = rf_arr[i_rd_addr1];

	always @(posedge i_clk) begin
		if(i_wr_en) begin
			rf_arr[i_wr_addr] <= i_wr_data;
		end else begin
			rf_arr[i_wr_addr] <= rf_arr[i_wr_data];
		end
	end
endmodule

