/**
 * イネーブル付きフリップ・フロップ
 * (リセット機能付き)
 */
module FlopEnable
  #(parameter WIDTH = 8)	// 入力ビット幅
   (input logic clk, reset, en,	// クロック、リセット、イネーブル
    input logic [WIDTH - 1:0]  d, // 入力
    output logic [WIDTH - 1:0] q); // 出力

   always_ff @(posedge clk)
     if (reset) q <= 32'b0;
     else if (en) q <= d;

endmodule // FlopEnable
