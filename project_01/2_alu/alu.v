// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: alu.v
//	* Date			: 2025-03-18 13:13:22
//	* Description	: 
// ==================================================

module alu
(
	output reg [31:0] o_y,
	output      	  o_c,
	input 	   [31:0] i_a,
	input  	   [31:0] i_b,
	input  	   [2:0]  i_f
);

	wire [31:0] b_mux;
	wire [31:0] sum;

	assign b_mux      = i_f[2] ? ~i_b : i_b;
	assign {o_c, sum} = i_a + b_mux + i_f[2];

	always @(*) begin
		case(i_f[1:0])
			2'b00: o_y = i_a & b_mux;
			2'b01: o_y = i_a | b_mux;
			2'b10: o_y = i_a + b_mux;
			2'b11: o_y = {{31{1'b0}}, sum[31]};
		endcase
	end

endmodule
	
