/**
 * 演習問題2.35の機能を実装するHDLモジュール
 */
module mod(input logic [3:0] a,
	   output logic p, d);

   assign p = a[3] & ~a[2] & ~a[1] & a[0] 
     | ~a[3] & a[2] & a[0]
     | ~a[3] & ~a[2] & a[1]
     | a[2] & a[1] & ~a[0];

   assign d = a[3] & ~a[2] & ~a[1]
     | ~a[3] & a[2] & a[1] & ~a[0]
     | ~a[3] & ~a[2] & ~a[1] & ~a[0]
     | ~a[2] & a[1] & ~a[0];

endmodule // mod
