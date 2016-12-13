`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:57:46 11/21/2016 
// Design Name: 
// Module Name:    vga_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "vga_params.v"




//* Display a rectangle
module vga_module
(
	input CLOCK_100,
	//input[1:0] switch,
	input [44:0] seq1,
	input [44:0] seq2,
	input [3:0] index10,
	input [3:0] index1,
	output [`D_WIDTH-1:0] VGA_R, VGA_G, VGA_B,
	output VGA_HS, VGA_VS
);
wire VGA_CLK;
pll_module clk
(
	.i_clock100MHz(CLOCK_100),
	.o_clock50MHz(VGA_CLK)
);

wire [`P_WIDTH-1:0] X,Y;
wire valid;
sync_module sync
(
	.VGA_CLK(VGA_CLK),
	.VGA_HS(VGA_HS),
	.VGA_VS(VGA_VS),
	.X(X), .Y(Y),
	.valid(valid)
);

vga_control_module3 control
(
	.VGA_CLK(VGA_CLK),
	//.switch(switch),
	.seq1(seq1),
	.seq2(seq2),
	.index10(index10),
	.index1(index1),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.X(X), .Y(Y),
	.valid(valid)
);

endmodule

module pll_module
(
	input i_clock100MHz,
	output reg o_clock50MHz
);

always @ (posedge i_clock100MHz)
	o_clock50MHz <= ~o_clock50MHz;

endmodule