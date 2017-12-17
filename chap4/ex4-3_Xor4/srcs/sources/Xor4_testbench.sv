`timescale 1ns / 1ps

module Xor4Testbench();
   logic clk;
   logic [3:0] a;
   logic       y, yexpected;
   logic [31:0] vectornum, errors;
   logic [4:0] 	testvectors[10000:0];
   
   // テストするデバイスをインスタン化
   Xor4 xor4(a, y);

   // クロックの生成
   always
     begin
	clk = 1; #5; clk = 0; #5;
     end
   
   // テスト開始時、テスト・ベクタを読み込む
   initial begin
      $readmemb("Xor4.tv", testvectors);
      vectornum = 0;
      errors = 0;
   end
   
   // クロックの立ち上がりエッジでテスト・ベクタを与える
   always @(posedge clk)
     begin
	#1; {a[0], a[1], a[2], a[3], yexpected} = testvectors[vectornum];
     end
   
   // クロックの立ち下がりエッジで結果をチェック
   always @(negedge clk)
     begin
	if (y !== yexpected) 
	  begin
	     $display("Error: inputs = %b", {a[0], a[1], a[2], a[3]});
	     $display(" output = %b (%b expected)", y, yexpected);
	     errors = errors + 1;
	  end

	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 5'bx)
	  begin
	     $display("%d test completed with %d errors", vectornum, errors);
	     $finish;
	  end

     end // always @ (negedge clk)

endmodule // Xor4Testbench
