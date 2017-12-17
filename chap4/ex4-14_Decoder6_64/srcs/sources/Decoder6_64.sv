module decoder6_64(input logic [5:0] a,
		   output logic [63:0] y);

   genvar i, j, k;
   logic [3:0] low, mid, hi;

   decoder2_4 dec_l(a[1:0], low);
   decoder2_4 dec_m(a[3:2], mid);
   decoder2_4 dec_h(a[5:4], hi);

   generate
      for (i = 0; i < 4; i = i + 1) begin :hiloop
	 for (j = 0; j < 4; j = j + 1) begin :midloop
	    for (k = 0; k < 4; k = k + 1) begin :lowloop
	       assign y[i * 16 + j * 4 + k] = hi[i] & mid[j] & low[k];
	    end
	 end
      end
      
   endgenerate
   
endmodule // decoder6_64
   
   
   
