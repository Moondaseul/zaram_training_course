// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: sram_extended_tb.v
//	* Date			: 2025-03-19 13:59:53
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
`include	"sram_extended.v"

module sram_extended_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire [63:0] o_data;
	reg  [63:0] i_data;
	reg  [5:0]  i_addr;
	reg 		i_cen;
	reg 		i_wen;
	reg 		i_oen;
	reg	  	    i_clk;

	sram_extended
	u_sram_extended(
		.o_data (o_data),
		.i_data (i_data),
		.i_addr (i_addr),
		.i_cen  (i_cen ),
		.i_wen  (i_wen ),
		.i_oen  (i_oen ),
		.i_clk  (i_clk )
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
			taskState = "Init";
			i_data    = 0;
			i_addr	  = 0;
			i_cen	  = 0;
			i_wen	  = 0;
			i_oen	  = 0;
			i_clk 	  = 0;
		end
	endtask

	task memWR;
		input [63:0] ti_data;
		input [5:0]  ti_addr;
		begin
			taskState = "memWR";
			i_data	  = ti_data;
			i_addr    = ti_addr;
			i_cen	  = 1;
			i_wen 	  = 1;
			i_oen	  = 0;
			#(1000/`CLKFREQ);
		end
	endtask

	task memRD;
		input [5:0] ti_addr;
		begin
			taskState = "memRD";
			i_addr    = ti_addr;
			i_cen     = 1;
			i_wen     = 0;
			i_oen     = 1;
			#(1000/`CLKFREQ);
		end
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		#(4*1000/`CLKFREQ);

		for (i=0; i<2**6; i++) begin
			memWR(i, i);
		end

		for(i=0; i<2**6; i++) begin
			memRD(i);
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
			$dumpfile("sram_extended_tb.vcd");
			$dumpvars;
		end
	end

endmodule

