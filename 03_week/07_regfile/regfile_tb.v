// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: regfile_tb.v
//	* Date			: 2025-03-17 15:36:08
//	* Description	: 
// ==================================================

// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		100		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define NVEC		2**5		// # of Test Vector
`define MEM_INIT
// --------------------------------------------------
//	Includes
// --------------------------------------------------
`include	"regfile.v"

module regfile_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	parameter BW_DATA = 32;
	parameter BW_ADDR = 5;

	wire [BW_DATA-1:0] o_rd_data0;
	wire [BW_DATA-1:0] o_rd_data1;

	reg  [BW_ADDR-1:0] i_rd_addr0;
	reg  [BW_ADDR-1:0] i_rd_addr1;
    reg  [BW_DATA-1:0] i_wr_data;
	reg  [BW_ADDR-1:0] i_wr_addr;
	reg 			   i_wr_en;
	reg			       i_clk;

	regfile 
	#(
		.MIF_FILE ("regfile.mif"),
		.BW_DATA  (BW_DATA      ),
		.BW_ADDR  (BW_ADDR	    )
	)
	u_regfile(
		.o_rd_data0 (o_rd_data0),
		.o_rd_data1 (o_rd_data1),
		.i_rd_addr0 (i_rd_addr0),
		.i_rd_addr1 (i_rd_addr1),
		.i_wr_data  (i_wr_data ),
		.i_wr_addr  (i_wr_addr ),
		.i_wr_en	(i_wr_en   ),
		.i_clk		(i_clk	   )
	);
// --------------------------------------------------
// 	Clock
// --------------------------------------------------
	always #(500/`CLKFREQ) i_clk = ~i_clk;

// --------------------------------------------------
// 	Task
// --------------------------------------------------
	reg [8*32-1:0] taskState;
	task init;
		begin
			i_rd_addr0 = 0;
			i_rd_addr1 = 0;
			i_wr_data  = 0;
			i_wr_en    = 0;
			i_clk	   = 0;
		end
	endtask

	task rfWR;
		input [BW_DATA-1:0] ti_wr_data;
		input [BW_ADDR-1:0] ti_wr_addr;
		begin
			@(negedge i_clk) begin
				i_wr_data = ti_wr_data;
				i_wr_addr = ti_wr_addr;
				i_wr_en   = 1;
			end
		end
	endtask

	task rfRD;
		input [BW_ADDR-1:0] ti_rd_addr0;
		input [BW_ADDR-1:0] ti_rd_addr1;
		begin
			@(negedge i_clk) begin
				i_rd_addr0 = ti_rd_addr0;
				i_rd_addr1 = ti_rd_addr1;
				i_wr_en    = 0;
			end
		end
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		#(4*1000/`CLKFREQ);
		for (i=0; i<`SIMCYCLE; i++) begin
			rfWR(i, i);
		end

		for (i=0; i<`SIMCYCLE; i++) begin
			rfRD(i, i);
		end

		for (i=0; i<`SIMCYCLE; i++) begin
			rfWR(i, i);
			#(1000/`CLKFREQ);
			rfRD(i, i);
		end
		#(1000/`CLKFREQ);
		$finish;
	end

// --------------------------------------------------
//	Dump VCD
// --------------------------------------------------
	reg	[8*32-1:0]	vcd_file;
	initial begin
		if ($value$plusargs("vcd_file=%s", vcd_file)) begin
			$dumpfile(vcd_file);
			$dumpvars;
		end else begin
			$dumpfile("regfile_tb.vcd");
			$dumpvars;
		end
	end

endmodule

