`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:41:55 12/02/2016
// Design Name:   memory_basepair
// Module Name:   X:/EC551/EC551_Project/indexing/test_memory.v
// Project Name:  indexing
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: memory_basepair
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////


module test_memory;

    // Inputs
    reg clk;
    reg [99:0] reference;
    reg reset;
    reg [19:0] shortread;
	 wire [19:0] sequence;

    // Outputs
    wire [7:0] index;
	reg[1:0] A,T,G,C;
    // Instantiate the Unit Under Test (UUT)
    memory_basepair uut (
        .clk(clk),
        .reference(reference), 
        .reset(reset),
        .shortread(shortread),     
        .index(index),
		  .sequence(sequence)
    );
    always
    begin
    #10 clk = 1'b0;
    #10 clk = 1'b1;      
    end  

    initial begin
        // Initialize Inputs  
        clk = 0;
		  A=2'b00;
		  G=2'b01;
		  C=2'b10;
		  T=2'b11;
        //reference = 100'b0011100100011011101101001011111000010100001010111100011011000001001110010100010010111001001111100100;
			//reference = {A,G,T,C,C,A,G,T,C,T,A,G,A,G,G,T,C,A,G,A,A,C,T,G,A,C,C,T,T,A,A,G,G,A,T,C,C,T,A,G,C,T,C,T,G,A,C,T,C,A};
			reference={A,C,T,G,A,G,T,C,T,C,G,A,T,C,C,T,A,G,G,A,A,T,T,C,C,A,G,T,C,A,A,G,A,C,T,G,G,A,G,A,T,C,T,G,A,C,C,T,G,A};
        //shortread = 20'b00010100011011000100;
		  shortread={G,A,G,T,C,A,G,A,C,C};
		  //shortread={C,C,A,G,A,C,T,G,A,G};
      reset = 0;

        #10 reset =1;
        #20 reset =0;  
        // Wait 100 ns for global reset to finish
        #5000 $finish;

        // Add stimulus here

    end
      
endmodule