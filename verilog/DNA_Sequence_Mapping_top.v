`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:13:45 12/02/2016 
// Design Name: 
// Module Name:    DNA_Sequence_Mapping_top 
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

module DNA_Sequence_Mapping_top(clk,
										  reset,
										  button,
										  VGA_R, VGA_G, VGA_B,
										  VGA_HS, VGA_VS						  
    );
input clk, reset;
input button;
output [`D_WIDTH-1:0] VGA_R, VGA_G, VGA_B;
	output VGA_HS, VGA_VS;
	
wire [99:0] reference;
wire [15:0] short_read,short_read1,short_read2,short_read3;
wire [15:0] ref_seq1,ref_seq2,ref_seq3,ref_seq4,ref_seq5,ref_seq6,ref_seq7,ref_seq8,ref_seq9,ref_seq10;
wire [7:0] sr_index1,sr_index2,sr_index3,sr_index4,sr_index5,sr_index6,index_to_send;
wire [1:0] A,T,G,C;
		  assign  A=2'b00;
		  assign G=2'b01;
		  assign C=2'b10;
		  assign T=2'b11;
		  
//assign reference={A,C,T,G,A,G,T,C,T,C,G,A,T,C,C,T,A,G,G,A,A,T,T,C,C,A,G,T,C,A,A,G,A,C,T,G,G,A,G,A,T,C,T,G,A,C,C,T,G,A};
//assign reference={A,A,A,T,G,G,T,C,G,A,A,G,C,C,T,A,A,G,A,G,C,T,T,T,C,G,C,T,A,G,C,T,G,C,A,G,T,C,G,C,T,A,T,G,A,C,C,T,G,T};
/*assign short_read1={G,T,C,A,G,A,C,G};
assign short_read2={A,G,A,C,T,G,G,A};
assign short_read3={T,C,T,G,A,C,C,T};*/
//assign short_read2={A,G,A,C,T,G,G,A,G,A};
//assign short_read3={T,C,T,G,A,C,C,T,G,A};

/*
assign short_read1={C,C,A,G,A,C,T,G};
assign short_read2={T,C,T,A,A,C,T,G};
assign short_read3={G,T,C,T,C,T,A,G};*/


assign reference={T,G,T,C,C,A,G,T,A,T,G,C,C,T,G,A,C,G,T,C,G,A,T,C,G,C,A,T,T,C,G,A,G,A,A,T,C,C,G,A,A,T,A,A,A,G,T,A,T,T};

assign short_read1={T,G,G,T,A,A,A,T};
assign short_read2={A,G,T,C,C,G,T,A};
assign short_read3={C,G,T,C,G,A,T,C};

assign ref_seq1={G,A,A,T,A,A,A,G};
//assign ref_seq2={C,A,G,A,A,C,T,G};

assign ref_seq2={T,G,T,C,C,A,G,T};
assign ref_seq3={A,A,T,C,C,G,A,A};

assign ref_seq4={C,G,T,C,G,A,T,C};
assign ref_seq5={A,T,T,C,G,A,G,A};

assign ref_seq6={A,G,C,T,C,T,G,A};
assign ref_seq7={T,C,T,G,A,C,C,T};
assign ref_seq8={T,C,T,G,A,C,C,T};
assign ref_seq9={T,C,T,G,A,C,C,T};


assign sr_index1=8'd38;

assign sr_index2=8'd0;
assign sr_index3=8'd33;

assign sr_index4=8'd16;
assign sr_index5=8'd26;

assign sr_index6=8'd76;
/*
assign short_read1={C,C,A,G,A,C,T,G};
assign short_read2={T,C,T,A,A,C,T,G};
assign short_read3={G,T,C,T,C,T,A,G};

assign ref_seq1={C,C,A,G,T,C,T,A};
assign ref_seq2={C,A,G,A,A,C,T,G};

assign ref_seq3={T,C,T,A,G,A,G,G};
assign ref_seq4={C,A,G,A,A,C,T,G};

assign ref_seq5={G,T,C,T,A,G,A,G};
assign ref_seq6={A,G,C,T,C,T,G,A};

assign ref_seq7={A,G,C,T,C,T,G,A};
assign ref_seq8={T,C,T,G,A,C,C,T};
assign ref_seq9={T,C,T,G,A,C,C,T};
assign ref_seq10={T,C,T,G,A,C,C,T};


assign sr_index1=8'd6;
assign sr_index2=8'd32;

assign sr_index3=8'd14;
assign sr_index4=8'd32;

assign sr_index5=8'd12;
assign sr_index6=8'd76;*/
/*
assign ref_seq1={G,T,A,A,G,A,C,G};
assign ref_seq2={G,T,C,A,A,A,C,G};
assign ref_seq3={A,G,A,C,T,G,G,A};
assign ref_seq4={A,G,A,C,T,G,G,A};
assign ref_seq5={A,G,A,C,T,G,G,A};
assign ref_seq6={T,C,T,G,A,C,C,T};
assign ref_seq7={T,C,T,G,A,C,C,T};
assign ref_seq8={T,C,T,G,A,C,C,T};
assign ref_seq9={T,C,T,G,A,C,C,T};
assign ref_seq10={T,C,T,G,A,C,C,T};
*/

reg index_start;
wire [15:0] seq1_fifo;
//wire [15:0] seq1;
wire [7:0] index;
wire SW_done;
wire empty;
wire fifo_read;
reg index_done;
reg SW_start;
reg start_scoreboard;
reg initial_state;
wire indexing_done;


reg [3:0] index_count[15:0];
reg [3:0]count;
wire [7:0] all_index[127:0];
wire [15:0] seqindex1, seqindex2, seqindex3, seqindex4, seqindex5;
reg [3:0] address;
wire [15:0] seq1;
reg [3:0] sr_count,ref_count;
reg [27:0] count_clk;
reg button1;
reg sw_finish;
reg[3:0] index_count2;
		
always @ (posedge clk or posedge reset) begin
	if(reset) begin
		index_count[0] <= 1;
		index_count[1] <= 2;
		index_count[2] <= 2;
		index_count[3] <= 2;
		index_count[4] <= 2;
		index_count[5] <= 2;
		index_count[6] <= 2;
		index_count[7] <= 2;
		index_count[8] <= 2;
		index_count[9] <= 2;
		index_count[10] <= 2;
		index_count[11] <= 2;
		index_count[12] <= 2;
		index_count[13] <= 2;
		index_count[14] <= 2;
		index_count[15] <= 2;
		address <=0;
		index_start <= 1'b0;
		count<=0;
		sr_count<=0;
		ref_count<=0;
		index_done<=0;
		count_clk<=0;
	end
	
	else begin
		if (button && count_clk==28'd0) begin
			button1<=1;
		end
		else button1<=0;
		if(button) count_clk<=count_clk+1;
		else count_clk<=0;

		
		
		if (count!=1 && count!=0) begin
			count <= count-1;
			ref_count<=ref_count+1;
		end
		if (count==1) begin
			index_start<=0;
			index_done<=1;
		end
		if(button1) begin
			index_start <= 1'b1;
			count <= index_count[address];
			sr_count<=sr_count+1;
			ref_count<=ref_count+1;
			index_done<=0;
			address<=address+1;
		end
	end
end

assign short_read=(sr_count==4'd1)?short_read1:
						(sr_count==4'd2)?short_read2:
						(sr_count==4'd3)?short_read3:15'd0;
						
assign seq1=(ref_count==4'd1)?ref_seq1:
				(ref_count==4'd2)?ref_seq2:
				(ref_count==4'd3)?ref_seq3:
				(ref_count==4'd4)?ref_seq4:
				(ref_count==4'd5)?ref_seq5:
				(ref_count==4'd6)?ref_seq6:
				(ref_count==4'd7)?ref_seq7:
				(ref_count==4'd8)?ref_seq8:
				(ref_count==4'd9)?ref_seq9:
				(ref_count==4'd10)?ref_seq10:15'd0;
				
assign index_to_send=(index_count2==4'd1)?sr_index1:
							(index_count2==4'd2)?sr_index2:
							(index_count2==4'd3)?sr_index3:
							(index_count2==4'd4)?sr_index4:
							(index_count2==4'd5)?sr_index5:
							(index_count2==4'd6)?sr_index6:8'd0;

always @ (posedge clk or posedge reset) begin
if (reset) begin
	initial_state<=1;
	SW_start<=0;
	sw_finish<=0;
	index_count2<=0;
end
else begin
	if (!empty | !initial_state)
		initial_state <=0;
	if (index_start && !SW_start)
		SW_start<=1;
	else
		SW_start<=0;
		
	if(fifo_read)
		start_scoreboard<=1;
	else
		start_scoreboard<=0;
		
	if(SW_done) sw_finish<=1;
	if(SW_start) sw_finish<=0;
	
	if(fifo_read) index_count2<=index_count2+1;
	
end

end
/*
memory_basepair m1(.clk(clk),
						 .reference(reference),
						 .reset(reset),
						 .shortread(short_read),
						 .index(index),
						 .sequence(seq1),
						 .start(index_start1),
						 .index_done(index_done));*/

assign first_read=initial_state & !empty;
assign fifo_read = first_read | (sw_finish &!empty);
assign indexing_done = index_done & empty;
fifo f1(.clk(clk),
		  .rst(reset), 
		  .buf_in(seq1), 
		  .buf_out(seq1_fifo), 
		  .wr_en(index_start),//should come from indexing
		  .rd_en(fifo_read),//should come from SW
		  .buf_empty(empty), 
		  .buf_full(), 
		  .fifo_counter());

wire [23:0] SR;
wire [23:0] seq1_SW;
/*
assign SR={1'b1,short_read[1:0],
			  1'b1,short_read[3:2],
   		  1'b1,short_read[5:4],
			  1'b1,short_read[7:6],
			  1'b1,short_read[9:8],
			  1'b1,short_read[11:10],
			  1'b1,short_read[13:12],
			  1'b1,short_read[15:14]};
			  
assign seq1_SW={1'b1,seq1_fifo[1:0],
			  1'b1,seq1_fifo[3:2],
   		  1'b1,seq1_fifo[5:4],
			  1'b1,seq1_fifo[7:6],
			  1'b1,seq1_fifo[9:8],
			  1'b1,seq1_fifo[11:10],
			  1'b1,seq1_fifo[13:12],
			  1'b1,seq1_fifo[15:14]};*/
			  
assign SR={1'b1,short_read[15:14],
			  1'b1,short_read[13:12],
   		  1'b1,short_read[11:10],
			  1'b1,short_read[9:8],
			  1'b1,short_read[7:6],
			  1'b1,short_read[5:4],
			  1'b1,short_read[3:2],
			  1'b1,short_read[1:0]};
			  
assign seq1_SW={1'b1,seq1_fifo[15:14],
			  1'b1,seq1_fifo[13:12],
   		  1'b1,seq1_fifo[11:10],
			  1'b1,seq1_fifo[9:8],
			  1'b1,seq1_fifo[7:6],
			  1'b1,seq1_fifo[5:4],
			  1'b1,seq1_fifo[3:2],
			  1'b1,seq1_fifo[1:0]};
			  
SW_top #(8)SW(.clk(clk),
					.button(button1),
					.reset(reset),
					.seq1(seq1_SW),
					//.seq1(seq1_fifo),
					.seq2(SR),
					//.seq2(short_read),
					.start_scoreboard(start_scoreboard),
					.index(index_to_send),
					.indexing_done(indexing_done),
					.VGA_R(VGA_R), 
					.VGA_G(VGA_G), 
					.VGA_B(VGA_B),
					.VGA_HS(VGA_HS), 
					.VGA_VS(VGA_VS),
					.SW_done(SW_done));
endmodule
