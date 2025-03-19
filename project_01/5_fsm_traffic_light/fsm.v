// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: fsm.v
//	* Date			: 2025-03-19 12:09:34
//	* Description	: 
// ==================================================

module fsm
(
	output reg [1:0] o_light_a,
	output reg [1:0] o_light_b,
	input 			 i_traff_a,
	input		     i_traff_b,
	input  			 i_mode_p,
	input			 i_mode_r,
	input			 i_clk,
	input			 i_rstn
);

	// Light_A & Light_B
	parameter S_S0 = 2'b00;
	parameter S_S1 = 2'b01;
	parameter S_S2 = 2'b10;
	parameter S_S3 = 2'b11;

	parameter M_S0 = 1'b0;
	parameter M_S1 = 1'b1;

	parameter L_R = 2'b00;
	parameter L_G = 2'b01;
	parameter L_Y = 2'b10;

	// For Mode FSM Output
	reg		  mode;

	// Main State Register
	reg [1:0] nState;
	reg [1:0] cState;
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			cState <= S_S0;
		end else begin
			cState <= nState;
		end
	end
	
	// Sub State Register
	reg		nMode;
	reg		cMode;
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			cMode <= M_S0;
		end else begin
			cMode <= nMode;
		end
	end

	// Next State Logic
	always @(*) begin
		case(cState)
			S_S0: nState = i_traff_a ? S_S0 : S_S1;
			S_S1: nState = S_S2;
			S_S2: nState = (mode | i_traff_b) ? S_S2 : S_S3;
			S_S3: nState = S_S0;
		endcase
	end

	// Next Mode Logic
	always @(*) begin
		case(cMode)
			M_S0: nMode = i_mode_p ? M_S1 : M_S0;
			M_S1: nMode = i_mode_r ? M_S0 : M_S1;
		endcase
	end
	
	// Output Logic (Light)
	always @(*) begin
		case(cState)
			S_S0: {o_light_a, o_light_b} = {L_G, L_R};
			S_S1: {o_light_a, o_light_b} = {L_Y, L_R};
			S_S2: {o_light_a, o_light_b} = {L_R, L_G};
			S_S3: {o_light_a, o_light_b} = {L_R, L_Y};
		endcase
	end

	// Output Logic (Mode)
	always @(*) begin
		case(cMode)
			M_S0: mode = 1'b0;
			M_S1: mode = 1'b1;
		endcase
	end

	`ifdef DEBUG
		reg [8*8-1:0] strLA;
		reg [8*8-1:0] strLB;
		always @(*) begin
			case(o_light_a)
				L_G: strLA = "GREEN";
				L_R: strLA = "RED";
				L_Y: strLA = "YELLOW";
			endcase
			case(o_light_b)
				L_G: strLB = "GREEN";
				L_R: strLB = "RED";
				L_Y: strLB = "YELLOW";
			endcase
		end
	`endif
endmodule


