module ScanReg4(input logic clk, test,
		input logic 	   s_in,
		input logic [3:0]  d,
		output logic 	   s_out,
		output logic [3:0] q);

   logic [3:0] r;
   
   always_ff @(posedge clk)
     begin
	if (test) r <= {r[2:0], s_in};
	else r <= d;
     end

   always_comb
     begin
	q <= r;
	s_out <= r[3];
     end

endmodule // ScanReg4
