/**
 * データパス
 */
module DataPath
  (input logic clk, reset, 	// クロック、リセット
   output logic [31:0] memoryAddress, // メモリアドレス
   input logic         instrOrDataAddress, // 命令アドレスか、データアドレスか
   input logic 	       instrReadEnable, // 命令読み込みイネーブル(イネーブル時にreadDataが命令として扱われる)
   input logic [31:0]  readData, // メモリ読み込み値
   input logic [2:0]   aluControl,// ALU制御
   output logic        aluResultZero); // ALU出力ゼロ
   
   logic [31:0] pc, pcNext; // プログラム・カウンタ値(PC)、次のPC、
   logic [31:0] instr, memoryLoadData;		    // 命令値、メモリ・ロード・データ
   logic [31:0] regFileData1, regFileData2; // レジスタ・ファイル読み込み値1, 2
   logic [31:0] rfData1, rfData2;	    // レジスタ・ファイル読み込み値1, 2(デコード・フェーズ)
   logic [31:0] instrSignImmediate;	    // 命令の符号拡張即値
   logic [31:0] aluResult, aluOut;	    // ALU演算結果、ALU演算結果(メモリ書き込みフェーズ)
      
   // 命令フェッチ
   FlopReset #(32) programCounterReg(clk, reset, pcNext, pc); // プログラム・カウンタ・レジスタ
   
   assign memoryAddress = instrOrDataAddress ? pc : aluOut;
   
   FlopEnable #(32) instrReg(clk, reset, instrReadEnable, readData, instr);
   FlopReset #(32) memDataReg(clk, reset, readData, memoryLoadData);

   // デコード
   RegisterFile regFile(clk, regFileWriteEnable, 
			instr[25:21], instr[20:16]/* TMP */, instr[15:11]/* TMP */,
			readData/* TMP */, regFileData1, regFileData2);
   FlopReset #(32) rfData1Reg(clk, reset, regFileData1, rfData1);
   FlopReset #(32) rfData2Reg(clk, reset, regFileData2, rfData2);

   SignExtend se(instr[15:0], instrSignImmediate);

   // 実行
   Alu alu(rfData1, instrSignImmediate, aluControl, aluResult, zero);

   FlopReset #(32) aluResultZero(clk, reset, aluResult, aluOut);
   
endmodule
