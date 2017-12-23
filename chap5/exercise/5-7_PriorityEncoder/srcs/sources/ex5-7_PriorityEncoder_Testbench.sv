`timescale 1ns / 1ps

module PriorityEncoder_Testbench();
   logic clk;
   logic [15:0] in;
   logic [3:0] 	out, out_expected;
   logic 	none, none_expected;
   logic [31:0] vectornum, errors;
   logic [20:0] testvectors[100:0];

   // テストするデバイスをインスタンス化
   PriorityEncoder #(4) encoder(in, out, none);
   
   // クロックの生成
   always
     begin
	clk = 1; #5; clk = 0; #5;
     end

   // テスト開始時、テスト・ベクタを読み込む
   initial 
     begin
	$readmemb("ex5-7_PriorityEncoder.tv", testvectors);
	vectornum = 0;
	errors = 0;
     end

   // クロックの立ち上がりエッジでテスト・ベクタを与える
   always @(posedge clk)
     begin
	#1; {in, out_expected, none_expected} = testvectors[vectornum];
     end
   
   // クロックの立ち下がりエッジで結果をチェック
   always @(negedge clk)
     begin
	if (out !== out_expected || none !== none_expected) 
	  begin
	     $display("Error: inputs = %b", in);
	     $display(" output = %b (%b expected)", {out, none}, {out_expected, none_expected});
	     errors = errors + 1;
	  end

	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 21'bx)
	  begin
	     $display("%d test completed with %d errors", vectornum, errors);
	     $finish;
	  end

     end // always @ (negedge clk)
   
endmodule // PriorityEncoder_Testbench

