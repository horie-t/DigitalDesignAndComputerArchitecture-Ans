module FloatAdder(input logic [31:0] a, b,
		  output logic [31:0] s);

   logic [7:0] a_exp, b_exp;
   logic [22:0] a_sig, b_sig;

   logic signed [8:0] diff_ab_exp;
   
   assign a_exp = a[30:23];
   assign b_exp = b[30:23];
//   assign a_exp = a[7:0];
//   assign b_exp = b[7:0];

   assign diff_ab_exp = a_exp - b_exp;
   
   assign s = {24'b0, diff_ab_exp};
   
endmodule // FloatAdder

