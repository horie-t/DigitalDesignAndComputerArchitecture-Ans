/**
 * 符号拡張モジュール
 */
module SignExtend
  (input logic [15:0] a,        // 入力
   output logic [31:0] y);      // 出力

   assign y = {{16{a[15]}}, a};
   
endmodule // SignExtend
