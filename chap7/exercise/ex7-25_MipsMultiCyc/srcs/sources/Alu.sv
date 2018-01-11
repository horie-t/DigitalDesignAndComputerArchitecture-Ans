/**
 * ALU
 */
module Alu
  (input logic [31:0] a, b,     // 入力A, B
   input logic [2:0]   control, // 制御信号
   output logic [31:0] out,     // 出力
   output logic        zero); // ゼロ信号(outが0の時)
   
   logic [31:0] sum, b_sel;     // 和、bの選択値

   assign b_sel = control[2] ? ~b : b;
   assign sum = a + b_sel + control[2];
   
   always_comb
     case (control[1:0])
       2'b00: out = a & b_sel;
       2'b01: out = a | b_sel;
       2'b10: out = sum;
       2'b11: out = sum[31];
     endcase // case (control[1:0])
   
   assign zero = (out == 32'b0);

endmodule // alu
