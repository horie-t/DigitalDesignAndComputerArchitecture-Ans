module PriorityEncoder
  #(parameter OUT_WIDTH = 3)
   (input logic [2 ** OUT_WIDTH - 1:0] in,
    output logic [OUT_WIDTH - 1:0] out,
    output logic none);

   generate
      if (OUT_WIDTH == 1)
	begin
	   assign out[0] = in[1];
	   assign none = ~(|in);
	end
      else
	begin
	   logic [2 ** (OUT_WIDTH - 1) - 1:0] high, low;
	   logic msb;
	   
	   assign high = in[2 ** OUT_WIDTH - 1:2 ** (OUT_WIDTH - 1)];
	   assign low = in[2 ** (OUT_WIDTH - 1):0];

	   assign msb = |high;
	   assign out[OUT_WIDTH - 1] = msb;
	   
	   logic [OUT_WIDTH - 2:0] high_child, low_child;
	   logic 		   high_none, low_none;
	   PriorityEncoder #(OUT_WIDTH - 1) highEncoder(high, high_child, high_none);
	   PriorityEncoder #(OUT_WIDTH - 1) lowEncoder(low, low_child, low_none);
	   
	   assign out[OUT_WIDTH - 2:0] = msb ? high_child : low_child;
	   assign none = msb ? 1'b0 : low_none;
	end // else: !if(OUT_WIDTH == 1)
      

   endgenerate

endmodule // PriorityEncoder
