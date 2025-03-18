// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: fsm_moore.v
//	* Date			: 2025-03-17 13:15:40
//	* Description	: 
// ==================================================

module fsm_moore
(
	output reg	o_out,
	input 		i_seq, // current seq
	input		i_clk,
	input 		i_rstn
);

	localparam	S_IDLE = 3'b000; // initial
	localparam	S_H	   = 3'b001; // detect '1'
	localparam  S_HL   = 3'b010; // detect '10'
	localparam  S_HLH  = 3'b011; // detect '101'
	localparam  S_HLHH = 3'b100; // detect '1011' (output active)

	reg 		[2:0] cState; // current state
	reg			[2:0] nState; // next state

	reg				  seq;	  // input seq storage 

	// State Register
	always @(posedge i_clk or negedge i_rstn) begin
		if(!i_rstn) begin
			cState <= 0;
			seq    <= 0;
		end else begin
			cState <= nState; // posedege cState --> nState
			seq    <= i_seq;  // storage current seq
		end
	end

	// Next State Logic
	always @(*) begin
		if(seq==1'b0) begin
			case(cState)
				S_IDLE : nState = S_IDLE;
				S_H    : nState = S_HL;
				S_HL   : nState = S_IDLE;
				S_HLH  : nState = S_HL;
				S_HLHH : nState = S_IDLE;
			endcase
		end else begin
			case(cState)
				S_IDLE : nState = S_H;
				S_H    : nState = S_H;
				S_HL   : nState = S_HLH;
				S_HLH  : nState = S_HLHH;
				S_HLHH : nState = S_H;
			endcase
		end
	end

	// Ouput Logic
	always @(*) begin
		case(cState) 
			S_HLHH  : o_out = 1'b1; // '1011' --> output = 1
			default : o_out = 1'b0;
		endcase
	end

	`ifdef DEBUG // storage FSM state(string) --> simul stateMonitor
		reg [32*8-1:0] stateMonitor;
		always @(*) begin
			case(cState)
				S_IDLE : stateMonitor = "S_IDLE";
				S_H    : stateMonitor = "S_H";
				S_HL   : stateMonitor = "S_HL";
				S_HLH  : stateMonitor = "S_HLH";
				S_HLHH : stateMonitor = "S_HLHH";
			endcase
		end
	`endif

endmodule



