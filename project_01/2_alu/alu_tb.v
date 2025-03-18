// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: alu_tb.v
//	* Date			: 2025-03-18 13:20:36
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
`include	"alu.v"

module alu_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire [31:0] o_y;
	wire        o_c;
	reg  [31:0] i_a;
	reg  [31:0] i_b;
	reg  [2:0]  i_f;

	alu
	u_alu(
		.o_y (o_y),
		.o_c (o_c),
		.i_a (i_a),
		.i_b (i_b),
		.i_f (i_f)
	);

// --------------------------------------------------
// 	Task
// ---------------------------------------------------
	reg [8*32-1:0] taskState;
	task init;
		begin
			taskState = "Init";
			i_a 	  = 0;
			i_b		  = 0;
			i_f 	  = 0;
		end
	endtask

	task fcode;
		input [8*32-1:0] ti_fcode_string;
		input [2:0]      ti_fcode;
		begin
			taskState = ti_fcode_string;
			i_a       = $urandom;
			i_b		  = $urandom;
			i_f		  = ti_fcode;
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
		for (i=0; i<`SIMCYCLE; i++) begin
			fcode("A & B", 3'b000  );
			fcode("A | B", 3'b001  );
			fcode("A + B", 3'b010  );
			fcode("A & ~B", 3'b100 );
			fcode("A | ~B", 3'b101 );
			fcode("A - B", 3'b110  );
			fcode("A<B?1:0", 3'b111);
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
			$dumpfile("alu_tb.vcd");
			$dumpvars;
		end
	end

endmodule

