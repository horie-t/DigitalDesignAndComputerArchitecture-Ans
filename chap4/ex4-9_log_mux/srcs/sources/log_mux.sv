module log_mux(input logic a, b, c,
	       output logic y);

   mux8 m({a, b, c}, 1, 0, 0, 1, 1, 1, 0, 0, y);

endmodule // log_mux
