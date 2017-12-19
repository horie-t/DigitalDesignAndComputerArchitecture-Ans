/**
 * 演習問題2.26の図のHDLモジュール
 */
module mod(input logic a, b, c, d, e,
	   output logic y);

   assign y = ~(~(~(a & b) & ~(c & d)) & e);

endmodule // mod
