/**
 * リセット付きフリップ・フロップ
 */
module FlopReset
  #(parameter WIDTH = 8)	   // 入出力ビット幅
   (input logic clk, reset,	// クロック、リセット
    input logic [WIDTH - 1:0]  d, // 入力
    output logic [WIDTH - 1:0] q); // 出力

   always_ff @(posedge clk, posedge reset)
     if (reset) q <= 0;
     else q <= d;
   
endmodule // FlopReset
