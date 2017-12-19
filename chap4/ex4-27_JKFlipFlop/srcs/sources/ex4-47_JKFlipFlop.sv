module JkFlipFlop(input logic clk, J, K,
		  output logic Q);

   always_ff @(posedge clk)
     if (J & K)
       Q <= ~Q;
     else if (J)
       Q <= 1'b1;
     else if (K)
       Q <= 1'b0;
     else			
       // ~J & ~K
       Q <= Q;

endmodule // JkFlipFlop

   
