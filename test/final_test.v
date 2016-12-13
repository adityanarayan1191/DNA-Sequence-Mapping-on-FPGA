`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:40:41 12/02/2016
// Design Name:   DNA_Sequence_Mapping_top
// Module Name:   X:/EC551/EC551_Project/indexing/final_test.v
// Project Name:  indexing
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DNA_Sequence_Mapping_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module final_test;

	// Inputs
	reg clk;
	reg reset;
	reg button;
	// Outputs
	wire [3:0] VGA_R;
	wire [3:0] VGA_G;
	wire [3:0] VGA_B;
	wire VGA_HS;
	wire VGA_VS;

	// Instantiate the Unit Under Test (UUT)
	DNA_Sequence_Mapping_top uut (
		.clk(clk), 
		.reset(reset), 
		.button(button),
		.VGA_R(VGA_R), 
		.VGA_G(VGA_G), 
		.VGA_B(VGA_B), 
		.VGA_HS(VGA_HS), 
		.VGA_VS(VGA_VS)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		button = 0;
        #10 reset =1;
        #20 reset =0; 
		  #72 button = 1;
		  #20 button=0;
		  
		  #5000 button = 1;
		  #200 button=0;
		  
		  		  #5000 button = 1;
		  #200 button=0;
		  
		  
		// Wait 100 ns for global reset to finish
		#5000 $finish;
        
		// Add stimulus here

	end
       always
    begin
    #10 clk = 1'b0;
    #10 clk = 1'b1;      
    end  

endmodule

