`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:01:35 12/01/2016 
// Design Name: 
// Module Name:    SW_PE_clk 
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
module SW_PE_clk(
	 input clk,
	 input reset,
	 input [2:0] seq1,
	 input [2:0] seq2,
    input [31:0] diag_score,
    input [31:0] left_score,
    input [31:0] top_score,
    output reg[31:0] score
    );
	
	parameter match_score = 2;
	parameter mismatch_score = 1;
	parameter gap_penalty = 1;
	
	wire [31:0] score1,score2,score3,score_wire;
	wire [31:0] stemp1,stemp2,stemp3;

	assign stemp1 = ((seq1==seq2)?(diag_score+match_score):(diag_score-mismatch_score))&32'b10000000000000000000000000000000;
	assign stemp2 = (left_score-gap_penalty)&32'b10000000000000000000000000000000;
	assign stemp3 = (top_score-gap_penalty)&32'b10000000000000000000000000000000;
	
	assign score1 = (stemp1==8'd0)?((seq1==seq2)?(diag_score+match_score):(diag_score-mismatch_score)):32'd0;
	assign score2 = (stemp2==8'd0)?(left_score-gap_penalty):32'd0;
	assign score3 = (stemp3==8'd0)?(top_score-gap_penalty):32'd0;

	assign score_wire = ((score1>score2)?((score1>score3)?score1:score3):((score2>score3)?score2:score3));
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			score <= 32'd0;
		end
		else
			score <= score_wire;
	end
	
endmodule
