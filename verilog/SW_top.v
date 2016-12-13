`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:13:41 12/01/2016 
// Design Name: 
// Module Name:    SW_top 
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

module SW_top(clk,
				  button,
				  reset,
				  seq1,
				  seq2,
				  start_scoreboard,
				  index,
				  indexing_done,
				  VGA_R, VGA_G, VGA_B,
				  VGA_HS, VGA_VS,
				  SW_done
    );
	 parameter n=10;
	 input clk,reset,button;
	 input start_scoreboard;
	 input [7:0] index;
	 input indexing_done;
	 output [`D_WIDTH-1:0] VGA_R, VGA_G, VGA_B;
	 output VGA_HS, VGA_VS;
	 output SW_done;
	 input [3*n-1:0] seq1,seq2;
	 wire [31:0] score;
	 wire [2:0] A,T,C,G;
	 reg [7:0] index_VGA;
	 
	 reg [3:0] index10,index1;
	 assign A=3'b100;
	 assign G=3'b101;
	 assign C=3'b110;
	 assign T=3'b111;
	 //wire [44:0] seq1_out,seq2_out;
	 reg [44:0] seq1_out,seq2_out;
	 reg [44:0] seq1_VGA,seq2_VGA;
	 reg [44:0] seq1_disp,seq2_disp;

		wire [2:0] seq1_out_SW,seq2_out_SW;
		wire out_valid;
	 //assign seq1=45'b000001010111000000011010111011111000001011000;
	// assign seq2=45'b000001010111000000011010111011111000001011000;
	//assign seq1={A,C,A,C,G,C,T,A};
	//assign seq2={A,C,A,C,A,C,T,A};
	
	//assign seq1={A,C,T,G,G,T,A,C,T,A};
	//assign seq2={A,C,T,G,G,A,C,T,G,A};
	
	wire clock;
	reg start_SW;
	wire align_done;
	reg align_done1;
	 Scoreboard_clk #(n,n) M1(
							.clk(clk),
							.reset(reset),
							.start_scoreboard(start_scoreboard),
							.sequence1(seq1),
							.sequence2(seq2),
							.score(score),
							.seq1_out(seq1_out_SW),
							.seq2_out(seq2_out_SW),
							.out_valid(out_valid),
							.SW_done(SW_done)
							);

//reg [31:0] count;
reg [3:0] count;
reg [31:0] final_score;
always @(posedge clk or posedge reset) begin
	if (reset) begin
		seq1_out <=0;
		seq2_out <=0;
		count <=0;
		start_SW<=0;
		seq1_VGA <=0;
		seq2_VGA <=0;
		final_score <= 0;
		index10<=4'd10;
		index1<=4'd10;
		align_done1<=0;
	end
	else begin
		if (button) begin
			seq1_out<=0;
			seq2_out<=0;
			final_score<=0;
		end
		if (out_valid) begin
			seq1_out<={seq1_out>>3}+{seq1_out_SW,42'd0};
			seq2_out<={seq2_out>>3}+{seq2_out_SW,42'd0};
		end	
		if (start_scoreboard && count==4'd0) begin
			start_SW<=1;
		end
		else start_SW<=0;
		if(start_scoreboard) count<=count+1;
		
		
		if(SW_done) begin

			if(score>final_score) begin
				seq1_disp <= seq1_out;
				seq2_disp <= seq2_out;
				final_score<=score;
				seq1_out<=0;
				seq2_out<=0;
				index10<=index/10;
				index1<=index%10;
			end
		end
		if(align_done) align_done1<=1;
		else align_done1<=0;
		if(align_done1) begin
			seq1_VGA <= seq1_disp;
			seq2_VGA <= seq2_disp;
		end
	end
end

assign align_done=SW_done & indexing_done;

vga_module M2
(
	.CLOCK_100(clk),
	.seq1(seq1_VGA),
	.seq2(seq2_VGA),
	.index10(index10),
	.index1(index1),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G), 
	.VGA_B(VGA_B),
	.VGA_HS(VGA_HS), 
	.VGA_VS(VGA_VS)
);
endmodule
