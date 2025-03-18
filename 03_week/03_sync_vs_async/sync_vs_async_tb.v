// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: sync_vs_async_tb.v
//	* Date			: 2025-03-17 11:00:18
//	* Description	: 
// ==================================================

// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		100		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define BW_DATA		32		// Bitwidth of ~~
`define NVEC 		100

// --------------------------------------------------
//	Includes
// --------------------------------------------------
`include	"sync_vs_async.v"

module sync_vs_async_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire [`BW_DATA-1:0] o_q_sync;
	wire [`BW_DATA-1:0] o_q_async;
	reg	 [`BW_DATA-1:0] i_d;
	reg					i_clk;
	reg					i_rstn;

	dff_sync
	#(
		.BW_DATA	(`BW_DATA)
	)
	u_dff_sync(
		.o_q    (o_q_sync),
		.i_d    (i_d	 ),
		.i_clk  (i_clk	 ),
		.i_rstn (i_rstn	 )
	);

	dff_async
	#(
		.BW_DATA	(`BW_DATA)
	)
	u_dff_aysnc(
		.o_q    (o_q_async),
		.i_d    (i_d      ),
		.i_clk  (i_clk	  ),
		.i_rstn (i_rstn	  )
	);

// -------------------------------------------------
//	Clock
// -------------------------------------------------
	always	#(500/`CLKFREQ) i_clk = ~i_clk;

	task 	resetReleaseAfterNCycle;
		input [31:0]	n;
		begin
			#(n*1000/`CLKFREQ);
			i_rstn = 1;
		end	
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		i_d    = 0;
		i_clk  = 0;
		i_rstn = 0;
		resetReleaseAfterNCycle(4);

		for (i=0; i<`SIMCYCLE; i++) begin
			j	= $urandom_range(0,10);
			#((j*0.1)*1000/`CLKFREQ);
			i_d	   = $urandom;
			i_rstn = $urandom;
			#((1-(j*0.1))*1000/`CLKFREQ);
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
			$dumpfile("sync_vs_async_tb.vcd");
			$dumpvars;
		end
	end

endmodule
