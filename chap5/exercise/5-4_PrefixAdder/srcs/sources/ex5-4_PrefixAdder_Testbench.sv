`timescale 1ns / 1ps

module PrefixAdder_Testbench();
   logic clk;
   logic [15:0] a, b, s, s_expected;
   logic [31:0] vectornum, errors;
   logic [47:0] testvectors[100:0];

   // テストするデバイスをインスタンス化
   PrefixAdder16 adder16(a, b, s);

   // クロックの生成
   always
     begin
	clk = 1; #5; clk = 0; #5;
     end

   // テスト開始時、テスト・ベクタを読み込む
   initial 
     begin
	$readmemb("ex5-4_PrefixAdder.tv", testvectors);
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
	     $display("Error: inputs = %b", {a, b});
	     $display(" output = %b (%b expected)", s, s_expected);
	     errors = errors + 1;
	  end

	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 48'bx)
	  begin
	     $display("%d test completed with %d errors", vectornum, errors);
	     $finish;
	  end

     end // always @ (negedge clk)
   
endmodule
   
