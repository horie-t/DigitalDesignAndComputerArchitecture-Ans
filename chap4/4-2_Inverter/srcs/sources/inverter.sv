/**
 * @brief インバータ
 */
module inv(input logic [3:0] a,
	   output logic [3:0] y);
   assign y = ~a;
endmodule
