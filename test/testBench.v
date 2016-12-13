`timescale 1ns / 1ps

module testOR;
	// Inputs
	reg a;
	reg b;
	// Outputs
	wire c;
	// Instantiate the Unit Under Test (UUT)
	orgate uut (
		.a(a), 
		.b(b), 
		.c(c)
	);
	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
	end
	always begin
		#100 a=1;
		#100 b=1;
		#100 a=0;
	end
      
endmodule

