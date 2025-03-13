module block
(
	output reg	o_q,
	input 		i_d,
	input		i_clk
);

	reg		n1;
	always @(posedge i_clk) begin
		n1   = i_d;
		o_q  = n1;
	end

endmodule

module nonblock
(
	output reg	o_q,
	input 		i_d,
	input		i_clk
);

	reg		n1;
	always @(posedge i_clk) begin
		n1  <= i_d;
		o_q <= n1;
	end

endmodule
