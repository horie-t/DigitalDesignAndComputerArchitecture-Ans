module FloatAdder(input logic [31:0] a, b,
		  output logic [31:0] s);

   logic a_sign, b_sign, s_sing;	// 符号
   logic [7:0] a_exp, b_exp, s_exp;	// 指数部
   logic [23:0] a_sig, b_sig, s_sig;	// 仮数部(ケチ表現の1を復帰後)

   /*
    * 入力を各部分に分割
    */
   assign a_sign = a[31];
   assign b_sign = b[31];
   
   assign a_exp = a[30:23];
   assign b_exp = b[30:23];

   assign a_sig = {1'b1, a[22:0]};
   assign b_sig = {1'b1, b[22:0]};
   
   logic signed [8:0] diff_ab_exp; // a, bの指数部の差分
   logic [7:0] 	      abs_diff_ab_exp; // a, bの指数部の差分の絶対値
   assign diff_ab_exp = a_exp - b_exp;
   assign abs_diff_ab_exp = diff_ab_exp[8] ? (~diff_ab_exp + 1) : diff_ab_exp;

   /*
    * 入力値の大きい方に仮数部を合わせる
    */
   logic [23:0] large_sig, small_sig, small_sig_adjust;
   logic [7:0] 	large_exp;
   
   assign large_sig = diff_ab_exp[8] ? b_sig : a_sig;
   assign small_sig = diff_ab_exp[8] ? a_sig : b_sig;

   assign small_sig_adjust = small_sig >> abs_diff_ab_exp;

   assign large_exp = diff_ab_exp[8] ? b_exp : a_exp;

   /*
    * 加算
    */
   logic [24:0] sum_sig;
   assign sum_sig = large_sig + small_sig_adjust;

   /*
    * 結果を正規化
    */
   assign s_sign = a_sign;
   assign s_exp = sum_sig[24] ? large_exp + 1 : large_exp;
   assign s_sig = sum_sig[24] ? sum_sig >> 1 : sum_sig;

   /*
    * 結果を出力
    */
   assign s = {a_sign, s_exp ,sum_sig[22:0]};
   
endmodule // FloatAdder

