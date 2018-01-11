/**
 * 4入力セレクタ
 */
module Mux4
  #(parameter WIDTH = 8)
   (input logic [WIDTH - 1:0] d0, d1, d2, d3, // 入力値0, 1, 2, 3
    input logic [1:0] 	       s,	      // 選択値
    output logic [WIDTH - 1:0] y);	      // 出力値

   always_comb
     case (s)
       2'b00: y = d0;
       2'b01: y = d1;
       2'b10: y = d2;
       2'b11: y = d3;
     endcase // case (s)

endmodule // Mux4
