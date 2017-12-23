/**
 * 32bit ALU
 */
module ALU32(input logic [31:0] a, b,
	     input logic [2:0] 	 f,
	     output logic 	 c_out, zero,
	     output logic [31:0] y);

   always_comb
     begin
	logic [31:0] b_sel, sum;
	
	b_sel = f[2] ? ~b : b;
	{c_out, sum} = a + b_sel + f[2];
	case (f[1:0])
	  2'b00: y = a & b_sel;
	  2'b01: y = a | b_sel;
	  2'b10: y = sum;
	  2'b11: y = sum[31];
	endcase // case (f[1:0])
	
	zero = ~(|y);
     end // always_comb

endmodule
