/**
 * @brief 3つの入力に対するブール関数の例
 * 
 * @param a 入力
 * @param b 入力
 * @param c 入力
 * 
 * @param y 出力
 */
module sillyfunction(input logic a, b, c,
		     output logic y);

   assign y = ~a & ~b & ~c |
	      a & ~b & ~c |
	      a & ~b & c;

endmodule
