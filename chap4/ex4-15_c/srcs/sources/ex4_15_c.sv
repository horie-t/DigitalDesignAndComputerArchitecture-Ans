/**
 * Y = ~A + BD + ~B~D + ~CD のHDLモジュール
 */
module mod(input logic a, b, c, d,
	   output logic y);

   assign y = ~A | B & D | ~B & ~D | ~C & D;

endmodule // mod
