module PriorityEncoder16(input logic [15:0] SW,
			 output logic [3:0] LED,
			 output logic 	    NONE_LED);

   PriorityEncoder #(4) encoder(SW, LED, NONE_LED);

endmodule // PriorityEncoder16

/**
 * 2^N の入力を受け付けるプライオリティ・エンコーダ。(演習問題5.7の解答のモジュール)
 * Nビットの2進の値を出力する
 * 
 * @param OUT_WIDTH 出力のビット幅
 * 
 * @param in 入力信号
 * @param out 出力信号(inの最上位の1のビット位置を出力)
 * @paran none 入力信号に1が1つもない時に有効になる。
 */
module PriorityEncoder
  #(parameter OUT_WIDTH = 3)
   (input logic [2 ** OUT_WIDTH - 1:0] in,
    output logic [OUT_WIDTH - 1:0] out,
    output logic none);

   // 再帰的な設計にすると、大抵は遅延時間は対数で増加するようになる。
   // その代わり、回路の規模が、入力に比例して大きくってしまう。
   generate
      if (OUT_WIDTH == 1)
	begin
	   // 基底条件(最低2つの入力はあるはず)
	   assign out[0] = in[1];
	   assign none = ~(|in);
	end
      else
	begin
	   // 入力を上位と下位の半分に分割して、再帰的に処理する。
	   // 半分に分割することによりlog_2の遅延時間で済むようになる。
	   logic [2 ** (OUT_WIDTH - 1) - 1:0] high, low;
	   logic msb; // 出力の最上位ビット
	   
	   assign high = in[2 ** OUT_WIDTH - 1:2 ** (OUT_WIDTH - 1)];
	   assign low = in[2 ** (OUT_WIDTH - 1):0];

	   // 上位の入力に1があれば、出力の最上位ビットは1になる。
	   assign msb = |high;

	   // 例: 10000000の時、出力の最上位ビットを1、出力の残りを上位半分のビット(1000)で再帰処理する。
	   logic [OUT_WIDTH - 2:0] out_child;
	   PriorityEncoder #(OUT_WIDTH - 1) childEncoder(msb ? high : low, out_child, none);

	   assign out = {msb, out_child};
	end // else: !if(OUT_WIDTH == 1)

   endgenerate

endmodule // PriorityEncoder
