// ==================================================
//	[ VLSISYS Lab. ]
//	* Author		: Daseul Moon (daseul@sm.ac.kr)
//	* Filename		: riscv_cpu.v
//	* Date			: 2025-03-19 17:04:52
//	* Description	: 
// ==================================================

`ifndef NOINC
`include "../common/riscv_configs.v"
`include "../common/riscv_dmem_interface.v"
`include "riscv_ctrl.v"
`include "riscv_datapath.v"

module riscv_cpu
#(
	parameter REGISTER_INIT = 0
)
(
	output [`XLEN-1:0] o_cpu_imem_pc,
	output [`XLEN-1:0] o_cpu_dmem_addr,
	output 			   o_cpu_dmem_wr_en,
	output [3:0] 	   o_cpu_dmem_byte_sel,
	output [`XLEN-1:0] o_cpu_dmem_wr_data,
	input  [`XLEN-1:0] i_cpu_imem_instr,
	input  [`XLEN-1:0] i_cpu_dmem_rd_data,
	input			   i_clk,
	input		       i_rstn
);

	wire 			   alu_zero;
	wire [2:0]		   src_imm;
	wire [1:0] 		   src_pc;
	wire [1:0] 		   src_rd;
	wire 			   src_alu_a;
	wire 		  	   src_alu_b;
	wire 			   reg_wr_en;
	wire [3:0]    	   alu_ctrl;

	wire 
