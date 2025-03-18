// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: shift_register_tb.v
//	* Date			: 2025-03-18 19:25:25
//	* Description	: 
// ==================================================

// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		100		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define NVEC		10		// # of Test Vector
`define BY_GENERATE

// --------------------------------------------------
//	Includes
// --------------------------------------------------
`include	"shift_register.v"

module shift_register_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire [7:0] o_par_out;
	wire 	   o_ser_out;
	reg	       i_load;
	reg	  	   i_ser_in;
	reg  [7:0] i_par_in;
	reg		   i_clk;
	reg   	   i_rstn;

	shift_register
	u_shift_register(
		.o_par_out (o_par_out),
		.o_ser_out (o_ser_out),
		.i_load    (i_load),
		.i_ser_in  (i_ser_in),
		.i_par_in  (i_par_in),
		.i_clk     (i_clk),
		.i_rstn    (i_rstn)
	);

// -------------------------------------------------
// 	Clock
// -------------------------------------------------
	always #(500/`CLKFREQ) i_clk = ~i_clk;

// --------------------------------------------------
// 	Task
// --------------------------------------------------




// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		resetNCycle(4);

		for (i=0; i<`SIMCYCLE; i++) begin
			vecInsert(i);
			vecVerify(i);
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
			$dumpfile("shift_register_tb.vcd");
			$dumpvars;
		end
	end

endmodule

