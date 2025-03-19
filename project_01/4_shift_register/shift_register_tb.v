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
		.i_load    (i_load   ),
		.i_ser_in  (i_ser_in ),
		.i_par_in  (i_par_in ),
		.i_clk     (i_clk    ),
		.i_rstn    (i_rstn   )
	);

// -------------------------------------------------
// 	Clock
// -------------------------------------------------
	always #(500/`CLKFREQ) i_clk = ~i_clk;

// --------------------------------------------------
// 	Task
// --------------------------------------------------
	reg    [8*32-1:0]  taskState;
	reg    [7:0] 	   err;
	integer   	       i;
	integer		       j;

	task init;
		begin
			taskState = "Init";
			i_load    = 0;
			i_ser_in  = 0;
			i_par_in  = 0;
			i_clk	  = 0;
			i_rstn	  = 0;
			err	  	  = 0;
		end
	endtask

	task resetNCycle;
		input [9:0] i;
		begin
			taskState = "Reset";
			i_rstn    = 1'b0;
			#(i*1000/`CLKFREQ);
			i_rstn    = 1'b1;
		end
	endtask

	task serial_to_parallel;
		input [7:0] ti_serial;
		begin
			taskState = "Ser2Par";
			i_load    = 0;
			for(i=0; i<8; i++) begin
				i_ser_in = ti_serial[7-i];
				#(1000/`CLKFREQ);
			end
			// Verification
			if(i==7 && i_clk) begin
				if(o_par_out == ti_serial) begin
					$display("Pass");
				end else begin
					$display("Fail");
					err++;
				end
			end
		end
	endtask

	task parallel_to_serial;
		input [7:0] ti_parallel;
		begin
			taskState = "Par2Ser";
			i_load    = 1;
			i_par_in  = ti_parallel;
			#(1000/`CLKFREQ);
			for(i=0; i<8; i++) begin
				i_load = 0;
				#(1000/`CLKFREQ);
			end
			// Verification
			if(i<8 && i_clk) begin
				if(o_ser_out == ti_parallel[i]) begin
					$display("Pass");
				end else begin
					$display("Fail");
				end
			end
		end
	endtask

// --------------------------------------------------
//	Test Stimulus
// --------------------------------------------------
	initial begin
		init();
		resetNCycle(4);

		for(j=0; j<`SIMCYCLE; j++) begin
			serial_to_parallel($urandom);
		end

		for (j=0; j<`SIMCYCLE; j++) begin
			parallel_to_serial($urandom);
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


