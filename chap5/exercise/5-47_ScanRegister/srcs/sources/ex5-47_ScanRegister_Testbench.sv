module ScanReg4_Testbench();
   logic clk;			      // クロック信号
   logic test_mode;		      // テスト・モード信号
   logic s_in, s_out, s_out_expected; // スキャン信号
   logic [3:0] d, q, q_expected;      // レジスタ入出力
   
   logic [31:0] vectornum, errors; // テストベクタカウンタ、エラー数
   logic [10:0] testvectors[100:0]; // テストベクタ(入力と期待値のビット幅の和)
   
   ScanReg4 r4(clk, test_mode, s_in, d, s_out, q);
   
   // クロックの生成
   always
     begin
	clk = 1; #5; clk = 0; #5;
     end

   // テスト開始時、テスト・ベクタを読み込む
   initial begin
      $readmemb("ex5-47_ScanRegister.tv", testvectors);
      vectornum = 0;
      errors = 0;
   end

   // クロックの立ち上がりエッジでテスト・ベクタを与える
   always @(posedge clk)
     begin
	#1; {test_mode, s_in, d, s_out_expected, q_expected} = testvectors[vectornum];
     end
   
   // クロックの立ち下がりエッジで結果をチェック
   always @(negedge clk)
     begin
	if (s_out !== s_out_expected || q !== q_expected) 
	  begin
	     $display("Error: inputs = %b", {test_mode, s_in, d});
	     $display(" output = %b (%b expected)", {s_out, q}, {s_out_expected, q_expected});
	     errors = errors + 1;
	  end

	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 11'bx)
	  begin
	     $display("%d test completed with %d errors", vectornum, errors);
	     $finish;
	  end

     end // always @ (negedge clk)
   
endmodule // ScanReg4_Testbench
