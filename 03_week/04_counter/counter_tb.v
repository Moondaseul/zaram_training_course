// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: counter_tb.v
//	* Date			: 2025-03-17 11:38:16
//	* Description	: 
// ==================================================

// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		100		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define BW_DATA		32		// Bitwidth of ~~
`define BW_ADDR		5		// Bitwidth of ~~
`define BW_CTRL		4		// Bitwidth of ~~
`define NVEC		100		// # of Test Vector

// --------------------------------------------------
//	Includes
// --------------------------------------------------
`include	"counter.v"

module counter_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	parameter	UPBND = 11;

	wire [$clog2(UPBND+1)-1:0] o_cnt;
	reg						   i_mode;
	reg						   i_clk;
	reg				     	   i_rstn;

	updw_cnt
	#(
		.UPBND (UPBND)
	)
	u_updw_cnt(
		.o_cnt  (o_cnt ),
		.i_mode (i_mode),
		.i_clk  (i_clk ),
		.i_rstn (i_rstn)
	);

// --------------------------------------------------
// 	Clock
// --------------------------------------------------
	always #(500/`CLKFREQ) i_clk = ~i_clk;

// --------------------------------------------------
// 	Task
// --------------------------------------------------
	reg	[8*16-1:0] taskState;
	task init;
		begin
			taskState = "Init";
			i_mode	  = 1;
			i_clk	  = 0;
			i_rstn	  = 0;
		end
	endtask

	task resetNCycle;
		input [31:0] i;
		begin
			taskState = "Reset_On";
			#(i*1000/`CLKFREQ);
			taskState = "Reset_Off";
			i_rstn = 1;
		end
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		resetNCycle(4);
		for (i=0; i<3*UPBND; i++) begin
			#(1000/`CLKFREQ);
		end
	    i_mode = 0;
		for (i=0; i<3*UPBND; i++) begin
			#(1000/`CLKFREQ);
		end
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
			$dumpfile("counter_tb.vcd");
			$dumpvars;
		end
	end

endmodule

