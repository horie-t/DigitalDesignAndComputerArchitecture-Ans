/**
 * データパス
 */
module DataPath
  (input logic clk, reset, 	// クロック、リセット
   input logic 	       programCounterWriteEnable, // プログラム・カウンタ書き込みイネーブル
   output logic [31:0] memoryAddress, // メモリアドレス
   input logic 	       instrOrDataAddress, // memoryAddressが命令アドレスか、データアドレスか(1の時は命令)
   input logic 	       instrReadEnable, // 命令読み込みイネーブル(イネーブル時にreadDataが命令として扱われる)
   input logic [31:0]  readData, // メモリ読み込み値
   output logic [31:0] writeData, // メモリ書き込み値
   input logic 	       regFileWriteEnable, //レジスタ・ファイル書き込みイネーブル
   input logic 	       aluSrcASel, // ALUのソースAがレジスタrsかPCか(1の時レジスタrs)
   input logic [1:0]   aluSrcBSel, // ALUのソースB(00: , 01: 4, 10: 命令即値, 11: )
   input logic [2:0]   aluControl,// ALU制御
   output logic        aluResultZero); // ALU出力ゼロ
   
   logic [31:0] pc; // プログラム・カウンタ値(PC)
   logic [31:0] instr, memoryLoadData;		    // 命令値、メモリ・ロード・データ
   logic [31:0] regFileData1, regFileData2; // レジスタ・ファイル読み込み値1, 2
   logic [31:0] rfData1, rfData2;	    // レジスタ・ファイル読み込み値1, 2(デコード・フェーズ)
   logic [31:0] instrSignImmediate;	    // 命令の符号拡張即値
   logic [31:0] aluSrcA, aluSrcB;	    // ALUの入力A, B
   logic [31:0] aluResult, aluOut;	    // ALU演算結果、ALU演算結果(メモリ書き込みフェーズ)

   // プログラム・カウンタ
   FlopEnable #(32) programCounterReg(clk, reset, programCounterWriteEnable, aluResult, pc);

   // メモリ・アクセス
   assign memoryAddress = instrOrDataAddress ? pc : aluOut;
   FlopEnable #(32) instrReg(clk, reset, instrReadEnable, readData, instr);
   FlopReset #(32) memDataReg(clk, reset, readData, memoryLoadData);

   // レジスタ・アクセス
   RegisterFile regFile(clk, regFileWriteEnable, 
			instr[25:21], instr[20:16]/* TMP */, instr[20:16],
			memoryLoadData, regFileData1, regFileData2);
   FlopReset #(32) rfData1Reg(clk, reset, regFileData1, rfData1);
   FlopReset #(32) rfData2Reg(clk, reset, regFileData2, rfData2);

   SignExtend se(instr[15:0], instrSignImmediate);

   assign writeData = rfData2;	// TMP
   
   // 実行
   Mux2 #(32) srcAMux(pc, instrSignImmediate, aluSrcASel, aluSrcA);
   Mux4 #(32) srcBMux(32'b0/* TMP */, 32'd4, instrSignImmediate, 32'b0/* TMP */, aluSrcBSel, aluSrcB);
   Alu alu(aluSrcA, aluSrcB, aluControl, aluResult, aluResultZero);

   FlopReset #(32) aluResultReg(clk, reset, aluResult, aluOut);
   
endmodule
