module mod(input logic [7:0] a,
	   output logic [2:0] y,
	   output logic       none);

   always_comb
     begin
	y[2] = a[7] | a[6] | a[5] | a[4];
	y[1] = a[7] | a[6] | ~y[2] & (a[3] | a[2]);
	y[0] = a[7] | a[5] | ~y[2] & (a[3] | a[1]) | ~y[2] & ~y[1] & a[1];
	none = ~y[2] & ~y[1] & ~y[0] & ~a[0];
     end

endmodule // mod
