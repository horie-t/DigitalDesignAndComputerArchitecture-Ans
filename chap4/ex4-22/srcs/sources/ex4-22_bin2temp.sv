/**
 * 演習問題2.38の2進->温度計コード変換器。
 * 解答のブール論理式を直接実装したら保守性が悪すぎるのでcase文を使う。
 * 最適化は、ツールの方がやると期待。
 */
module bin2temp(input logic [2:0] a,
		output logic [6:0] y);

   always_comb
     case (a)
       3'b000: y = 7'b000_0000;
       3'b001: y = 7'b000_0001;
       3'b010: y = 7'b000_0011;
       3'b011: y = 7'b000_0111;
       3'b100: y = 7'b000_1111;
       3'b101: y = 7'b001_1111;
       3'b110: y = 7'b011_1111;
       3'b111: y = 7'b111_1111;
       default: y = 7'bxxx_xxxx;
     endcase // case (a)

endmodule // bin2temp

       
