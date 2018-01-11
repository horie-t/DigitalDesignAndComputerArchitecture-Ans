/**
 * データパス
 */
module DataPath
  (input logic clk, reset, 	// クロック、リセット
   output logic [31:0] memoryAddress, // メモリアドレス
   input logic 	       instrReadEnable, // 命令読み込みイネーブル(イネーブル時にreadDataが命令として扱われる)
   input logic [31:0]  readData);       // メモリ読み込み値

   logic [31:0] pc, pcNext, instr; // プログラム・カウンタ値(PC)、次のPC、命令値
   logic [31:0] regFileData1, regFileData2; // レジスタ・ファイル読み込み値1, 2
   logic [31:0] rfData1, rfData2;	    // レジスタ・ファイル読み込み値1, 2(デコード・フェーズ)
   logic [31:0] instrSignImmediate;		    // 命令の符号拡張即値
   
   
   // 命令フェッチ
   FlopReset #(32) programCounterReg(clk, reset, pcNext, pc); // プログラム・カウンタ・レジスタ
   
   assign memoryAddress = pc;	// TMP
   
   FlopEnable #(32) instrReg(clk, reset, instrReadEnable, readData, instr);

   // デコード
   RegisterFile regFile(clk, regFileWriteEnable, 
			instr[25:21], instr[20:16]/* TMP */, instr[15:11]/* TMP */,
			readData/* TMP */, regFileData1, regFileData2);
   FlopReset #(32) rfData1Reg(clk, reset, regFileData1, rfData1);
   FlopReset #(32) rfData2Reg(clk, reset, regFileData2, rfData2);

   SignExtend se(instr[15:0], instrSignImmediate);
   
endmodule
   
