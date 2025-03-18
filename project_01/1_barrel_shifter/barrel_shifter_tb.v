// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: barrel_shifter_tb.v
//	* Date			: 2025-03-18 12:42:14
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
`include	"barrel_shifter.v"

module barrel_shifter_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire [7:0] o_y;
	reg  [7:0] i_a;
	reg  [2:0] i_k;

	barrel_shifter
	u_barrel_shifter(
		.o_y (o_y),
		.i_a (i_a),
		.i_k (i_k)
	);

// -------------------------------------------------
// 	Task
// -------------------------------------------------
	task init;
		begin
			i_a = 0;
			i_k = 0;
		end
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	integer  	err;
	reg [7:0]   temp;
	initial begin
		init();
		err = 0;
		#(1000/`CLKFREQ);

		for (i=0; i<`SIMCYCLE; i++) begin
			{i_a, i_k} = $urandom;
			temp = (i_a << (8-i_k)) | (i_a >> i_k);
			#(1000/`CLKFREQ);
			if (o_y != temp) begin
				err++;
			end
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
			$dumpfile("barrel_shifter_tb.vcd");
			$dumpvars;
		end
	end

endmodule

