// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: converter_tb.v
//	* Date			: 2025-03-18 11:17:39
//	* Description	: 
// ==================================================

// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		100		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define NVEC		100		// # of Test Vector

// --------------------------------------------------
//	Includes
// --------------------------------------------------
`include	"converter.v"

module converter_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	parameter BW_DATA = 8;

	wire [BW_DATA-1:0] o_data_gray;
	wire [BW_DATA-1:0] o_data_bin;
	reg  [BW_DATA-1:0] i_data;

	bin_to_gray
	#(
		.BW_DATA (BW_DATA)
	)
	u_bin_to_gray(
		.o_data (o_data_gray),
		.i_data (i_data     )
	);

	gray_to_bin
	#(
		.BW_DATA (BW_DATA)
	)
	u_gray_to_bin(
		.o_data (o_data_bin     ),
		.i_data (o_data_gray    )
	);
// --------------------------------------------------
// 	Task
// --------------------------------------------------
	task init;
		begin
			i_data = 0;
		end
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		for (i=0; i<`SIMCYCLE; i++) begin
			i_data = i;
			#(1000/`CLKFREQ);
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
			$dumpfile("converter_tb.vcd");
			$dumpvars;
		end
	end

endmodule

