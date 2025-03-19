// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: fsm_tb.v
//	* Date			: 2025-03-19 12:24:06
//	* Description	: 
// ==================================================

// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		100		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define NVEC		50		// # of Test Vector
`define DEBUG

// --------------------------------------------------
//	Includes
// --------------------------------------------------
`include	"fsm.v"

module fsm_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire [1:0] o_light_a;
	wire [1:0] o_light_b;
	reg 	   i_traff_a;
	reg		   i_traff_b;
	reg 	   i_mode_p;
	reg 	   i_mode_r;
	reg 	   i_clk;
	reg 	   i_rstn;

	fsm
	u_fsm(
		.o_light_a (o_light_a),
		.o_light_b (o_light_b),
		.i_traff_a (i_traff_a),
		.i_traff_b (i_traff_b),
		.i_mode_p  (i_mode_p ),
		.i_mode_r  (i_mode_r ),
		.i_clk     (i_clk    ),
		.i_rstn    (i_rstn   )
	);

// -------------------------------------------------
// 	Clock
// -------------------------------------------------
	always #(500/`CLKFREQ) i_clk = ~i_clk;

// -------------------------------------------------
// 	Task
// -------------------------------------------------
	reg [8*32-1:0] taskState;
	task init;
		begin
			taskState = "Init(Reset)";
			i_traff_a = 1'b0;
			i_traff_b = 1'b0;
			i_mode_p  = 1'b0;
			i_mode_r  = 1'b0;
			i_clk     = 1'b0;
			i_rstn    = 1'b0;
		end
	endtask

	task reset_n_cycle;
		input [3:0] n;
		begin
			#(n*1000/`CLKFREQ);
			taskState = "Operate";
			i_rstn = 1'b1;
		end
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();
		reset_n_cycle(10);

		for (i=0; i<`SIMCYCLE; i++) begin
			{i_traff_a, i_traff_b} = $urandom;
			{i_mode_p, i_mode_r}   = 2'b00;
			#(1000/`CLKFREQ);
		end

		for (i=0; i<`SIMCYCLE; i++) begin
			{i_traff_a, i_traff_b} = $urandom;
			{i_mode_p, i_mode_r}   = 2'b01;
			#(1000/`CLKFREQ);
		end

		for (i=0; i<`SIMCYCLE; i++) begin
			{i_traff_a, i_traff_a} = $urandom;
			{i_mode_p, i_mode_r}   = 2'b01;
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
			$dumpfile("fsm_tb.vcd");
			$dumpvars;
		end
	end

endmodule

