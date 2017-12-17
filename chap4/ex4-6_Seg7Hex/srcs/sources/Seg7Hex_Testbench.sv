module Seg7Hex_Testbench();
   logic clk;
   logic [3:0] data;
   logic [6:0] segments, segs_expected;
   logic [7:0] AN;
   logic [31:0] vectornum, errors;
   logic [10:0] testvectors[100:0];

   // テストするデバイスをインスタン化
   Seg7Hex seg7hex(data, segments, AN);

   // クロックの生成
   always
     begin
	clk = 1; #5; clk = 0; #5;
     end
   
   // テスト開始時、テスト・ベクタを読み込む
   initial begin
      $readmemb("Seg7Hex.tv", testvectors);
      vectornum = 0;
      errors = 0;
   end
   
   // クロックの立ち上がりエッジでテスト・ベクタを与える
   always @(posedge clk)
     begin
	#1; {data, segs_expected} = testvectors[vectornum];
     end
   
   // クロックの立ち下がりエッジで結果をチェック
   always @(negedge clk)
     begin
	if (segments !== segs_expected) 
	  begin
	     $display("Error: inputs = %b", data);
	     $display(" output = %b (%b expected)", segments, segs_expected);
	     errors = errors + 1;
	  end

	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 11'bx)
	  begin
	     $display("%d test completed with %d errors", vectornum, errors);
	     $finish;
	  end

     end // always @ (negedge clk)

endmodule
   
