/**
 * 質問2.2の月の日数関数のHDLモジュール。
 */
module dayMonth(input logic [3:0] a,
		output logic y);

   always_comb
     // 「にしむくさむらい」の時は0
     if (a == 4'd2 | a == 4'd4 | a == 4'd6 | a == 4'd9 | a == 4'd11)
       y = 1'b0;
     else
       y = 1'b1;

endmodule // dayMonth

       
       
	 
	
