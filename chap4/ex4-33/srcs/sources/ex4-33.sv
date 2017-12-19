/**
 * 演習問題3.23の図3.70のFSM
 */
module mod(input logic clk, reset,
	   input logic 	a, b,
	   output logic y);

   typedef enum logic [1:0] {S0, S1, S2} statetype;
   statetype [1:0] state, nextstate;

   // レジスタ
   always_ff @(posedge clk, posedge reset)
     if (reset) state <= S0;
     else state <= nextstate;

   // 状態遷移
   always_comb
     case (state)
       S0:
	 if (a) nextstate = S1;
	 else nextstate = S0;
       S1:
	 if (b) nextstate = S2;
	 else nextstate = S0;
       S2:
	 if (a & b) nextstate = S2;
	 else nextstate = S0;
     endcase // case (state)

   // 出力
   always_comb
     if (state == S2 & a & b)
       y = 1;
     else
       y = 0;

endmodule // mod

	   
       
	
