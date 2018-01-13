/**
 * 3入力セレクタ
 */
module Mux3
  #(parameter WIDTH = 8)
   (input logic [WIDTH - 1:0] d0, d1, d2, // 入力信号0,1,2
    input logic [1:0]          s, // 選択信号。sの値の信号が選択されます。
    output logic [WIDTH - 1:0] y); // 出力信号

   always_comb
     case (s)
       2'b00: y = d0;
       2'b01: y = d1;
       2'b10: y = d2;
       default: y = 32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx;
     endcase // case (s)
   
endmodule // Mux3
