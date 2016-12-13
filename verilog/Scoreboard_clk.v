`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:00:52 12/01/2016 
// Design Name: 
// Module Name:    Scoreboard_clk 
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Aditya Narayan
// 
// Create Date:    14:24:35 10/27/2016 
// Design Name: 
// Module Name:    Scoreboard 
// Project Name: Smith Waterman
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
module Scoreboard_clk(
							clk,
							reset,
							start_scoreboard,
							sequence1,
							sequence2,
							score,
							seq1_out,
							seq2_out,
							out_valid,
							SW_done
							);


	parameter n=8;
	parameter m=8;
	
	parameter match_score = 2;
	parameter mismatch_score = 1;
	parameter gap_penalty = 1;
	
	 input clk;
    input reset;
	 input start_scoreboard;
    input [3*n-1:0] sequence1;
    input [3*n-1:0] sequence2;
    output reg [31:0] score;
	 output reg [2:0] seq1_out;
	 output reg [2:0] seq2_out;
	reg [n:0]count_clock;
	output out_valid;
	output SW_done;
	//assign sequence1=45'b000001010111000000011010111011111000001011000;
	//assign sequence2=45'b000001010111000000011010111011111000001011000;
	/*******just testing these out*****/
	reg tracing;
	reg start_tracing; 
	reg [n:0] trace_index;
	//reg [2:0]seq1_out,seq2_out;
	
	
	//wire start;
	wire [31:0] final_score[((n+1)*(n+1))-1:0];
	
	wire [3*n-1:0] seq1[(n*n):0];
	wire [3*n-1:0] seq2[(n*n):0];
	assign seq1[0]=sequence1;
	assign seq2[0]=sequence2;
	
	genvar j;
	generate
	for (j=0;j<n+1;j=j+1) begin : for_1
		assign final_score[j]=32'd0;
		assign final_score[(n+1)*j]=32'd0;
	end
	endgenerate
	

	genvar i; 
	generate
	for(i=0;i<n*n;i=i+1) begin : for_2
		SW_PE_clk #(match_score,mismatch_score,gap_penalty) SW_instance(.clk(clk),
																							 .reset(reset),
																							 .seq1(seq1[i][3*n-1:3*n-3]),
																							 .seq2(seq2[i][3*n-1:3*n-3]),
																							 .diag_score(final_score[i+(i/n)]),
																							 .left_score(final_score[i+(i/n)+n+1]),
																							 .top_score(final_score[i+(i/n)+1]),
																							 .score(final_score[i+(i/n)+n+2]));
								
		assign seq2[i+1] = ((i+1)%n==0)?{seq2[i][3*n-4:0],seq2[i][3*n-1:3*n-3]}:seq2[i];
		assign seq1[i+1] = {seq1[i][3*n-4:0],seq1[i][3*n-1:3*n-3]};
	end
	endgenerate
	
	reg dont_count;
	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			score <= 32'd0;
			count_clock <= 0;
			dont_count <= 1;
		end
		else begin
			if (start_scoreboard) begin
				count_clock <=0;
				dont_count <= 0;
			end
			if (count_clock ==((2*n)-1))begin
				score <= final_score[(n+1)*(n+1)-1];
				count_clock <= 0;
				start_tracing <=1'b1;
				dont_count <= 1'b1;
			end
			else begin
				start_tracing <=1'b0;
				if (!dont_count)
					count_clock <= count_clock+1;
			end
		end
	end
	
	//reg [3*n-1:0] seq1_trace,seq2_trace;
	wire [n:0] next_index;
	wire [2:0] seq1_trace[n-1:0];
	wire [2:0] seq2_trace[n-1:0];
	
	genvar k;
	generate
	for (k=0;k<n;k=k+1) begin : for_3
		assign seq1_trace[k] = sequence1[3*k+2:3*k];
		assign seq2_trace[k] = sequence2[3*k+2:3*k];
	end
	endgenerate
	
	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			tracing <= 1'b0;
			trace_index <= 0;
		end
		else begin
			if (start_tracing) begin
				tracing <=1'b1;
				trace_index <= (n+1)*(n+1)-1;
			end
			
			if (tracing) begin
				trace_index <= next_index;
			end
			//if (final_score[next_index]==0)
			//if (trace_index==n+2)
			//if(trace_index==0 &&!start_tracing)
			if(((trace_index/(n+1)==0) || (trace_index%(n+1)==0)) && !start_tracing)
				tracing <=1'b0;
		end	
	end
	wire [3*n-1:0] a,b;
	reg [3*n-1:0] new_a,new_b;
	assign a = trace_index%(n+1);
	assign b = trace_index/(n+1);
	reg start_seqout, deletion;
	reg [7:0] count;
	reg tracing2, tracing3;
	traceback_compare #(n) t1(.curr_index(trace_index),
								.top_score(final_score[trace_index-n-1]),
								.diag_score(final_score[trace_index-n-2]),
								.left_score(final_score[trace_index-1]),
								.current_score(final_score[trace_index]),
								.next_index(next_index));
								
	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			seq1_out <= 3'd0;
			seq2_out <= 3'd0;		
			new_a <= 1;
			new_b <= 1;
			start_seqout <= 1'b0;
			count <= 8'd0;
			tracing2 <=0;
			tracing3 <=0;
		end
		
		else begin
			start_seqout <= 1'b0;
			tracing2<=tracing;
			tracing3<=tracing2;
			if (tracing) 
				start_seqout <= 1'b1;
			if (start_seqout)begin
				new_a <= a;
				new_b <= b;
				count <= count+1;
				//sequence1_out <= sequence1_out>>(3*count) + seq1_trace[n-new_a];
				if (new_a != a)
					seq1_out <= seq1_trace[n-new_a];
				else
					seq1_out <= 3'b010;
				if (new_b != b)
					seq2_out <= seq2_trace[n-new_b];
				else
					seq2_out <= 3'b010;
			end
			else begin
				seq1_out <= 3'd0;
				seq2_out <= 3'd0;
				count <= 0;
			end
			if (start_scoreboard) begin
				new_a <=1;
				new_b <=1;
			end
		end
	end
	assign out_valid=tracing3;
	assign SW_done=(!tracing2) & tracing3;
endmodule

