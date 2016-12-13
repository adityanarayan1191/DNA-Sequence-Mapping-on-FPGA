`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:02:01 12/01/2016 
// Design Name: 
// Module Name:    traceback_compare 
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
module traceback_compare(curr_index,
								 top_score,
								 diag_score,
								 left_score,
								 current_score,
								 //seq1,
								// seq2,
								// seq1_out,
								// seq2_out,
								 next_index
    );
	 parameter n =4;
	input [31:0] top_score, diag_score, left_score, current_score;
	input [n:0] curr_index;
	
	output [n:0] next_index;
	
	assign next_index = (diag_score<top_score)?((top_score>left_score)?curr_index-n-1:curr_index-1):((diag_score<left_score)?curr_index-1:curr_index-n-2);
endmodule
