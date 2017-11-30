/**
 * @brief トップ・モジュール
 */
module topModule(input logic clk,
		 input logic  reset,
		 input logic  manualClk,
		 output logic y);

   /*
    * チャタリング・防止の出力を擬似的なクロック信号にしてから、
    * FSMに渡す。
    */
   logic pseudoClk;
   eliminateChatter eliCht(clk, reset, manualClk, pseudoClk);
   
   divideby3FSM fsm(pseudoClk, reset, y);

endmodule // topModule

/**
 * @brief 3進有限状態マシン
 */
module divideby3FSM(input logic clk,
		    input logic  reset,
		    output logic y);

   typedef enum logic [1:0] {S0, S1, S2} statetype;
   statetype [1:0] state, nextstate;

   // 状態レジスタ
   always_ff @(posedge clk, posedge reset)
     if (reset) state <= S0;
     else state <= nextstate;

   // 次の状態の論理回路
   always_comb
     case (state)
       S0: nextstate = S1;
       S1: nextstate = S2;
       S2: nextstate = S0;
       default: nextstate = S0;
     endcase // case (state)

   // 出力の論理回路
   assign y = (state == S0);

endmodule // divideby3FSM

/**
 * 簡易的なチャタリング防止回路
 */
module eliminateChatter(input logic clk,
			input logic  reset,
			input logic  a,
			output logic y);
   /*
    * このやり方は、あくまで簡易的なもの。欠点が以下の通り存在する。
    * ・加算回路を内部に持つので、規模が大きくなる。
    * ・enableの周期で論理が動くので応答が遅れがち(指の動きよりは圧倒的に速いが)
    * ・enableの間隔以下の動きも拾ってしまう事があるので、チャタリング
    *   防止としては、完全ではない。
    * 
    * 本当は、分周した遅いクロックをシステムからもらって、
    * シフトレジスタを使って、一定時間、入力の変化が連続
    * してから応答するようにした方がよい。
    */

   /*
    * 約30Hzのパルスを作る。
    * (15'h7FFF(32767)までカウント。100MHzで動かすと約32msで一周する)
    */
   logic [14:0] count;
   logic 	enable = (count == 15'h7FFF);
   always_ff @(posedge clk, posedge reset)
     if (reset) count <= 15'h0;
     else count <= count + 15'h1;

   logic 	ff1, ff2;
   always_ff @(posedge clk, posedge reset)
     if (reset)
       begin
	  ff1 <= 1'b0;
	  ff2 <= 1'b0;
       end
     else if (enable)
       begin
	  ff1 <= a;
	  ff2 <= ff1;
       end

   // ff1 & ff2で立ち上がりを検出し、
   // enableとの論理和で1クロック分の信号になる。
   logic tmp = ff1 & ~ff2 & enable;
   always_ff @(posedge clk, posedge reset)
     if (reset) y <= 1'b0;
     else y <= tmp;

endmodule // eliminateChatter
