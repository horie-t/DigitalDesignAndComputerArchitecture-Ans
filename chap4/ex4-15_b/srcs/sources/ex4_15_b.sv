/**
 * Y = ~A のHDLモジュール
 */
module mod(input logic a,
	   output logic y);

   assign y = ~a;

endmodule // mod
