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
