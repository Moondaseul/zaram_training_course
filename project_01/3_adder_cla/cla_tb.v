// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: cla_tb.v
//	* Date			: 2025-03-18 13:46:32
//	* Description	: 
// ==================================================

// --------------------------------------------------
//	Define Global Variables
// --------------------------------------------------
`define	CLKFREQ		100		// Clock Freq. (Unit: MHz)
`define	SIMCYCLE	`NVEC	// Sim. Cycles
`define NVEC		20		// # of Test Vector

// --------------------------------------------------
//	Includes
// --------------------------------------------------
`include	"cla.v"

module cla_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire        o_c;
	wire [31:0] o_s;
	reg  [31:0] i_a;
	reg  [31:0] i_b;
	reg         i_c;

	cla
	u_cla(
		.o_c (o_c),
		.o_s (o_s),
		.i_a (i_a),
		.i_b (i_b),
		.i_c (i_c)
	);

// --------------------------------------------------
// 	Test Vector Configuration
// --------------------------------------------------
	reg vo_c[0:`NVEC-1];
	reg     [31:0] vo_s[0:`NVEC-1];
	reg     [31:0] vi_a[0:`NVEC-1];
	reg     [31:0] vi_b[0:`NVEC-1];
	reg     [31:0] vi_c[0:`NVEC-1];

	initial begin
		$readmem("./vec/o_c.vec", vo_c);
		$readmem("./vec/o_s.vec", vo_s);
		$readmem("./vec/i_a.vec", vi_a);
		$readmem("./vec/i_b.vec", vi_b);
		$readmem("./vec/i_c.vec", vi_c);
	end
// --------------------------------------------------
// 	Task
// --------------------------------------------------
	reg [4*32-1:0] taskState;
	reg [31:0]     temp_o_s;
	reg			   temp_o_c;
	integer  	   err = 0;

	task init;
		begin
			taskState = "Init";
			i_a 	  = 0;
			i_b		  = 0;
			i_c 	  = 0;
		end
	endtask

	task vecInsert;
		input [$clog2(`NVEC)-1:0] i;
		begin
			$sformat(taskState, "VEC[%3d]", i);
			i_a = vi_a[i];
			i_b = vi_b[i];
			i_c = vi_c[i];
			{temp_o_c, temp_o_s} = vi_a[i] + vi_b[i] + vi_c[i];
		end
	endtask
	
	task vecVerify;
		input [$clog2(`NVEC)-1:0] i;
		begin
			#(0.1*1000/`CLKFREQ);
			if(o_c != vo_c[i]) begin $display("[Idx: %3d] Mismatched o_c", i); end
			if(o_s != vo_s[i]) begin $display("[Idx: %3d] Mismatched o_s", i); end
			if((o_c != vo_c[i]) || (o_s != vo_s[i])) begin err++; end
			#(0.9*1000/`CLKFREQ);
		end
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	integer		i, j;
	initial begin
		init();

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
			$dumpfile("cla_tb.vcd");
			$dumpvars;
		end
	end

endmodule

