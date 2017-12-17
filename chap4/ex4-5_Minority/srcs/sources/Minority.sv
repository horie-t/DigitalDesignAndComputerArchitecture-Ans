/**
 * 小数決モジュール
 */
module minority(input logic a, b, c,
		output logic y);

   always_comb
     if (~a && ~b 
	 || ~a && ~c 
	 || ~b && ~c) 
       y = 1;
     else
       y = 0;

endmodule // minority

   
