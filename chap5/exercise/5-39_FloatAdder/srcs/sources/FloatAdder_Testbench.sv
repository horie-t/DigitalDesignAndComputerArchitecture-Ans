module FloatAdder_Testbench();
   logic clk;

   logic [31:0] a, b, s, s_expected;
   
   logic [31:0] vectornum, errors;
   logic [95:0] testvectors[100:0];

   FloatAdder adder(a, b, s);
   
   // クロックの生成
   always
     begin
	clk = 1; #5; clk = 0; #5;
     end
   
   // テスト開始時、テスト・ベクタを読み込む
   initial begin
      $readmemh("FloatAdder.tv", testvectors);
      vectornum = 0;
      errors = 0;
   end
   
   // クロックの立ち上がりエッジでテスト・ベクタを与える
   always @(posedge clk)
     begin
	#1; {a, b, s_expected} = testvectors[vectornum];
     end
   
   // クロックの立ち下がりエッジで結果をチェック
   always @(negedge clk)
     begin
	if (s !== s_expected) 
	  begin
	     $display("Error: inputs = %h", {a, b});
	     $display(" output = %h (%h expected)", s, s_expected);
	     errors = errors + 1;
	  end

	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 96'bx)
	  begin
	     $display("%d test completed with %d errors", vectornum, errors);
	     $finish;
	  end

     end // always @ (negedge clk)

endmodule
   
