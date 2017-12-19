module TrafficSig(input logic clk, reset,
		  input logic 	     Ta, Tb,
		  output logic [1:0] La, Lb);

   typedef enum logic [1:0] {S0, S1, S2, S3} sigstate;
   sigstate [1:0] state, nextstate;

   typedef enum logic [1:0] {green, yellow, red} sigcolor;

   // 状態レジスタ
   always_ff @(posedge clk, posedge reset)
     if (reset) 
       state <= S0;
     else
       state <= nextstate;

   // 次の状態の論理回路
   always_comb
     case (state)
       S0:
	 if (Ta)
	   nextstate = S0;
	 else
	   nextstate = S1;
       S1:
	 nextstate = S2;
       S2:
	 if (Tb)
	   nextstate = S2;
	 else
	   nextstate = S3;
       S3:
	 nextstate = S0;
     endcase // case (state)

   // 出力の論理回路
   always_comb
     case (state)
       S0:
	 begin
	    La = green;
	    Lb = red;
	 end
       S1:
	 begin
	    La = yello;
	    Lb = red;
	 end
       S2:
	 begin
	    La = red;
	    Lb = green;
	 end
       S3:
	 begin
	    La = red;
	    Lb = yellow;
	 end
     endcase // case (state)

endmodule // TrafficSig
   
