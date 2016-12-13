`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:56:11 11/21/2016 
// Design Name: 
// Module Name:    vga_params 
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

module sync_module
(
	input VGA_CLK,
	output VGA_HS, VGA_VS, valid,
	output [`P_WIDTH-1:0] X, Y//P_width =11 bits
);

reg [`P_WIDTH-1:0] Count_H;
always @ (posedge VGA_CLK)
	if(Count_H == `H_TOTAL)
		Count_H <= 0;
	else
		Count_H <= Count_H + 1'b1;

reg [`P_WIDTH-1:0] Count_V;
always @ (posedge VGA_CLK)
	if(Count_V == `V_TOTAL)
		Count_V <= 0;
	else if(Count_H == `H_TOTAL)
		Count_V <= Count_V + 1'b1;

reg valid_r;
always @ (posedge VGA_CLK)
	if( (Count_H > `H_SYNC+`H_BACK && Count_H < `H_SYNC+`H_BACK+`H_ACT+1) &&
		(Count_V > `V_SYNC+`V_BACK && Count_V < `V_TOTAL-1) )
		valid_r <= 1'b1;
	else
		valid_r <= 1'b0;

assign VGA_HS = (Count_H <= `H_SYNC) ? 1'b0 : 1'b1;
assign VGA_VS = (Count_V <= `V_SYNC) ? 1'b0 : 1'b1;
assign valid = valid_r;

assign X = valid_r ? (Count_H-`H_SYNC-`H_BACK-1) : `P_WIDTH'd0;
assign Y = valid_r ? (Count_V-`V_SYNC-`V_BACK-1) : `P_WIDTH'd0;

endmodule
