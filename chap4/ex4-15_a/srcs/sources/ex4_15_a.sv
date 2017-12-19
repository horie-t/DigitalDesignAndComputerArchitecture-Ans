/**
 * Y = AC + BCのHDLモジュール
 */
module mod(input logic a, b, c,
	   output logic y);

   assign y = a & c | b & c;

endmodule // mod
