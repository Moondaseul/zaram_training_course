// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: spsram_doubled_tb.v
//	* Date			: 2025-03-17 15:26:16
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
`include	"spsram_doubled.v"

module spsram_doubled_tb;
// --------------------------------------------------
//	DUT Signals & Instantiate
// --------------------------------------------------
	wire [31:0] o_data;
	reg  [31:0] i_data;
	reg  [4:0]  i_addr;
	reg 		i_cen;
	reg 		i_wen;
	reg 		i_oen;
	reg			i_clk;

	spsram_doubled
	u_spsram_doubled(
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
	always #(500/`CLKFREQ) i_clk = ~ i_clk;

// --------------------------------------------------
// 	Task
// --------------------------------------------------
	reg [8*32-1:0] taskState;
	task init;
		begin
			i_data = 0;
			i_addr = 0;
			i_cen  = 0;
			i_wen  = 0;
			i_oen  = 0;
			i_clk  = 0;
		end
	endtask

	task memWR;
		input [31:0] ti_data;
		input [4:0]  ti_addr;
		begin
			@(negedge i_clk) begin
				i_data = ti_data;
				i_addr = ti_addr;
				i_cen  = 1;
				i_wen  = 1;
				i_oen  = 0;
			end
		end
	endtask

	task memRD;
		input [31:0] ti_addr;
		begin
			@(negedge i_clk) begin
				i_addr = ti_addr;
				i_cen  = 1;
				i_wen  = 0;
				i_oen  = 1;
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
			memWR(i, i);
		end

		for (i=0; i<`SIMCYCLE; i++) begin
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
			$dumpfile("spsram_doubled_tb.vcd");
			$dumpvars;
		end
	end

endmodule

