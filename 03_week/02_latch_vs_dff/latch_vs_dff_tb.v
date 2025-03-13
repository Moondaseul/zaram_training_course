`define CLKFREQ		100
`define SIMCYCLE	50

`include	"02_latch_vs_dff.v"

module latch_vs_dff_tb;

	wire	o_q_lat;
	wire	o_q_dff;
	reg		i_d;
	reg		i_clk;

	latch
	u_latch(
		.o_q (),
		.i_d (),
		.i_clk ()
	);

	dff
	u_dff(
		.o_q (),
		.i_d (),
		.i_clk ()
	);

	always #(500/`CLKFREQ) i_clk = ~i_clk;

	task init;
		begin
			i_d		= 0;
			i_clk 	= 0;
		end
	endtask

	integer		i,j;
	initial begin
		init();
		for(i=0; i<`SIMCYCLE; i++) begin
			j	= $urandom_range(0,10);
			#((j*0.1) * 1000/`CLKFREQ);
			i_d	= $urandom;
			#((1-(j*0.1)) * 1000/`CLKFREQ);
		end
		$finish;
	end

	reg [8*32-1:0] vcd_file;
	initial begin
		if($value$plusargs("vcd_file=%s", vcd_file)) begin
			$dumpfile(vcd_file);
			$dumpvars;
		end else begin
			$dumpfile("latch_vs_dff_tb.vcd");
			$dumpvars;
		end
	end
endmodule

