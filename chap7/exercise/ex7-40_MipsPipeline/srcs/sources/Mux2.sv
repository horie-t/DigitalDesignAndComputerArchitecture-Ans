/**
 * 2入力セレクタ
 * 
 * sが真の時、d1が選択されます。
 */
module Mux2
  #(parameter WIDTH = 8)
   (input logic [WIDTH - 1:0] d0, d1, // 入力値0, 1
    input logic                s,     // 選択信号
    output logic [WIDTH - 1:0] y);    // 選択値

   assign y = s ? d1 : d0;

endmodule // Mux2
