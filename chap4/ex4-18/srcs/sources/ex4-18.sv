/**
 * 演習問題2.28の関数を実装するHDLモジュール
 */ 
module mod(input logic a, b, c, d,
	   output logic y);

   assign y = a & b | a & c & d | a & ~c & ~d;

endmodule // mod
