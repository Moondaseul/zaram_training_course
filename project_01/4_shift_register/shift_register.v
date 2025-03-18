// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: shift_register.v
//	* Date			: 2025-03-18 19:13:21
//	* Description	: 
// ==================================================

module shift_register
(
	output [7:0] o_par_out,
	output 	     o_ser_out,
	input		 i_load,
	input		 i_ser_in,
	input  [7:0] i_par_in,
	input 		 i_clk,
	input		 i_rstn
);

	assign       o_ser_out = o_par_out[7];

`ifdef BY_GENERATE
	genvar i;
	generate 
		for (i=0; i<8; i=i+1) begin
			shift_register_unit
			u_shift_register_unit(
				.o_out    (o_par_out[i]				    ),
				.i_load   (i_load				        ),
				.i_ser_in (i ? o_par_out[i-1] : i_ser_in),
				.i_par_in (i_par_in[i]			        ),
				.i_clk    (i_clk						),
				.i_rstn   (i_rstn						)
			);
		end
	endgenerate
`else
	shift_register_unit
	u_shift_register_unit_0(
		.o_out    (o_par_out[0]),
		.i_load   (i_load      ),
		.i_ser_in (i_ser_in    ),
		.i_par_in (i_par_in[0] ),
		.i_clk    (i_clk       ),
		.i_rstn   (i_rstn      )
	);

	shift_register_unit
	u_shift_register_unit_1(
		.o_out    (o_par_out[1]),
		.i_load   (i_load      ),
		.i_ser_in (o_par_out[0]),
		.i_par_in (i_par_in[1] ),
		.i_clk    (i_clk       ),
		.i_rstn   (i_rstn      )
	);	

    shift_register_unit
	u_shift_register_unit_2(
		.o_out    (o_par_out[2]),
		.i_load   (i_load      ),
		.i_ser_in (o_par_out[1]),
		.i_par_in (i_par_in[2] ),
		.i_clk    (i_clk       ),
		.i_rstn   (i_rstn      )
	);
    
	shift_register_unit
	u_shift_register_unit_3(
		.o_out    (o_par_out[3]),
		.i_load   (i_load      ),
		.i_ser_in (o_par_out[2]),
		.i_par_in (i_par_in[3] ),
		.i_clk    (i_clk       ),
		.i_rstn   (i_rstn      )
	);	

	shift_register_unit
	u_shift_register_unit_4(
		.o_out    (o_par_out[4]),
		.i_load   (i_load      ),
		.i_ser_in (o_par_out[3]),
		.i_par_in (i_par_in[4] ),
		.i_clk    (i_clk       ),
		.i_rstn   (i_rstn      )
	);

    shift_register_unit
	u_shift_register_unit_5(
		.o_out    (o_par_out[5]),
		.i_load   (i_load      ),
		.i_ser_in (o_par_out[4]),
		.i_par_in (i_par_in[5] ),
		.i_clk    (i_clk       ),
		.i_rstn   (i_rstn      )
	);
    
	shift_register_unit
	u_shift_register_unit_6(
		.o_out    (o_par_out[6]),
		.i_load   (i_load      ),
		.i_ser_in (o_par_out[5]),
		.i_par_in (i_par_in[6] ),
		.i_clk    (i_clk       ),
		.i_rstn   (i_rstn      )
	);	

	shift_register_unit
	u_shift_register_unit_7(
		.o_out    (o_par_out[7]),
		.i_load   (i_load      ),
		.i_ser_in (o_par_out[6]),
		.i_par_in (i_par_in[7] ),
		.i_clk    (i_clk       ),
		.i_rstn   (i_rstn      )
	);
`endif

endmodule

module shift_register_unit
(
	output reg o_out,
	input      i_load,
	input	   i_ser_in,
	input	   i_par_in,
	input 	   i_clk,
	input	   i_rstn
);

	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			o_out <= 0;
		end else begin
			o_out <= i_load ? i_par_in : i_ser_in;
		end
	end
endmodule

