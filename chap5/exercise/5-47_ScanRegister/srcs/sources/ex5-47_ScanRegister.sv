module ScanReg4(input logic clk, test,
		input logic 	   s_in,
		input logic [3:0]  d,
		output logic 	   s_out,
		output logic [3:0] q);

   always_ff @(posedge clk)
     begin
	if (test) q <= {q[2:0], s_in};
	else q <= d;
     end

   assign s_out = q[3];

endmodule // ScanReg4
