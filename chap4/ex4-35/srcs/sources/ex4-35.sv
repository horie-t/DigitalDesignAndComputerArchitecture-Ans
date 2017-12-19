/**
 * 演習問題3.25のMealyマシン制御のかたつむりの娘
 */
module snail_daughter(input logic clk, reset,
		      input logic  a,
		      output logic y);

   typedef logic [2:0] {S0, S1, S2, S3, S4} statetype;
   statetype [2:0] state, nextstate;

   // レジスタ
   always_ff @(clk, reset)
     if (reset) state <= S0;
     else state <= nextstate;

   // 次状態
   always_comb
     case (state)
       S0: 
	 if (a) state = S1;
	 else state = S0;
       S1:
	 if (a) state = S2;
	 else state = S0;
       S2:
	 if (a) state = S4;
	 else state = S3;
       S3:
	 if (a) state = S1;
	 else state = S0;
       S4:
	 if (a) state = S4;
	 else state = S3;
       default: state = S0;
     endcase // case (state)

   // 出力
   always_comb
     if (state == S3 & a
	 | state == S4 & ~a)
       y = 1;
     else
       y = 0;

endmodule // snail_daughter

       
   
