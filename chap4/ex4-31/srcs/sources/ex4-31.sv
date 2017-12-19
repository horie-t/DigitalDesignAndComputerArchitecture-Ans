/**
 * 図3.42のHDL
 */
module mod(input logic clk,
	   input logic 	a, b, c, d,
	   output logic x, y);
   
   logic A, B, C, D;
   logic X, Y;
   
   always_ff @(clk)
     begin
	A <= a;
	B <= b;
	C <= c;
	D <= d;
     end

   always_comb
     begin
	X = A & B | C;
	Y = ~(X | D);
     end

   always_ff @(clk)
     begin
	x <= X;
	y <= Y;
     end

endmodule // mod
