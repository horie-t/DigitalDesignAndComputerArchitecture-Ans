/**
 * 4入力XOR
 */
module Xor4(input logic [3:0] a,
	    output logic y);

   assign y = ^a;

   // リダクション演算子を使わない場合は以下の通り。
   // assign y = a[0] ^ a[1] ^ a[2] ^ a[3];
      
endmodule // Xor4
