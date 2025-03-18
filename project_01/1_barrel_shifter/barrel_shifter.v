// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: barrel_shifter.v
//	* Date			: 2025-03-18 11:56:47
//	* Description	: 
// ==================================================

module barrel_shifter
(
	output [7:0] o_y,
	input  [7:0] i_a,
	input  [2:0] i_k
);

	wire [7:0] pass_or_shift4;
	wire [7:0] pass_or_shift2;

	genvar i;
	generate 
		for (i=0; i<8; i=i+1) begin
			mux2
			u_mux2_0(
				.o_out (pass_or_shift4[i]),
				.i_in0 (i_a[i] 		     ),
				.i_in1 (i_a[(i+4)%8]     ),
				.i_sel (i_k[2]			 )
			);
		end

		for (i=0; i<8; i=i+1) begin
			mux2
			u_mux2_1(
				.o_out (pass_or_shift2[i]	   ),
				.i_in0 (pass_or_shift4[i]	   ),
				.i_in1 (pass_or_shift4[(i+2)%8]),
				.i_sel (i_k[1] 				   )
			);
		end

		for (i=0; i<8; i=i+1) begin
			mux2
			u_mux2_2(
				.o_out (o_y[i]			  	   ),
				.i_in0 (pass_or_shift2[i]	   ),
				.i_in1 (pass_or_shift2[(i+1)%8]),
				.i_sel (i_k[0]				   )
			);
		end
	endgenerate

endmodule

module mux2
(
	output o_out,
	input  i_in0,
	input  i_in1,
	input  i_sel
);

	assign o_out = i_sel ? i_in1 : i_in0;

endmodule
