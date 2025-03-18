// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: cla.v
//	* Date			: 2025-03-18 13:40:48
//	* Description	: 
// ==================================================

module cla
(
	output 		  o_c,
	output [31:0] o_s,
	input  [31:0] i_a,
	input  [31:0] i_b,
	input         i_c
);

	wire [8:0] internal_c;

	assign internal_c[0] = i_c;
	assign o_c			 = internal_c[8];

	genvar i;
	generate
		for(i=0; i<8; i=i+1) begin
			cla_block
			u_cla_block(
				.o_c (internal_c[i+1] ),
				.o_s (o_s[4*(i+1)-1-:4]),
				.i_a (i_a[4*(i+1)-1-:4]),
				.i_b (i_b[4*(i+1)-1-:4]),
				.i_c (internal_c[i]   )
			);
		end
	endgenerate

endmodule

module cla_block
(
	output 		 o_c,
	output [3:0] o_s,
	input  [3:0] i_a,
	input  [3:0] i_b,
	input  		 i_c
);

	wire dummy_c;
	assign {dummy_c, o_s} = i_a + i_b + i_c;

	// Bitwise P & G
	wire [3:0] p;
	wire [3:0] g;
	assign 	   p = i_a ^ i_b;
	assign 	   g = i_a & i_b;

	// Group P & G
	wire       grp_p;
	wire 	   grp_g;
	assign 	   grp_p = &p;
	assign     grp_g = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0]))))));
	assign     o_c   = grp_g | (grp_p & i_c);

endmodule
