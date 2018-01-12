/**
 * データパス
 */
module DataPath
  (input logic clk, reset, 	// クロック、リセット
   input logic 	       programCounterWriteEnable, // プログラム・カウンタ書き込みイネーブル
   input logic 	       branchInstr, // ブランチ命令
   output logic [31:0] memoryAddress, // メモリアドレス
   input logic 	       instrOrDataAddress, // memoryAddressが命令アドレスか、データアドレスか(1の時は命令)
   input logic 	       instrReadEnable, // 命令読み込みイネーブル(イネーブル時にreadDataが命令として扱われる)
   input logic [31:0]  readData, // メモリ読み込み値
   output logic [31:0] writeData, // メモリ書き込み値
   input logic 	       regFileWriteEnable, //レジスタ・ファイル書き込みイネーブル
   input logic 	       regDstFieldSel, // 宛先レジスタのフィールドがrtかrdか(1の時rd)
   input logic 	       memToRegSel, // メモリからレジスタへの書き込みかどうか(0の時はR形式の結果書き込み)
   input logic 	       aluSrcASel, // ALUのソースAがレジスタrsかPCか(1の時レジスタrs)
   input logic [1:0]   aluSrcBSel, // ALUのソースB(00: , 01: 4, 10: 命令即値, 11: )
   input logic [2:0]   aluControl);    // ALU制御

   logic [31:0] pc, pcNext; // プログラム・カウンタ値(PC), 次のPC
   logic [31:0] instr, memoryLoadData;		    // 命令値、メモリ・ロード・データ
   logic [4:0] 	regDst;				    // 宛先レジスタ番号
   logic [31:0] regFileData1, regFileData2; // レジスタ・ファイル読み込み値1, 2
   logic [31:0] regFileData3;		    // レジスタ・ファイル書き込み値3
   logic [31:0] rfData1, rfData2;	    // レジスタ・ファイル読み込み値1, 2(デコード・フェーズ)
   logic [31:0] instrSignImmediate;	    // 命令の符号拡張即値
   logic [31:0] instrSignImmediateShift;    // 命令の符号拡張即値x4
   logic [31:0] aluSrcA, aluSrcB;	    // ALUの入力A, B
   logic [31:0] aluResult, aluOut;	    // ALU演算結果、ALU演算結果(メモリ書き込みフェーズ)

   // プログラム・カウンタ
   Mux2 #(32) pcSrcMux(aluOut, aluResult, pcSrcSel, pcNext);
   FlopEnable #(32) programCounterReg(clk, reset, 
				      programCounterWriteEnable | branchInstr & aluResultZero, 
				      pcNext, pc);

   // メモリ・アクセス
   assign memoryAddress = instrOrDataAddress ? pc : aluOut;
   FlopEnable #(32) instrReg(clk, reset, instrReadEnable, readData, instr);
   FlopReset #(32) memDataReg(clk, reset, readData, memoryLoadData);

   // レジスタ・アクセス
   Mux2 #(5) regDstMux(instr[20:16], instr[15:11], regDstFieldSel, regDst);
   Mux2 #(32) memToRegMux(aluOut, memoryLoadData, memToRegSel, regFileData3);
   
   RegisterFile regFile(clk, regFileWriteEnable, 
			instr[25:21], instr[20:16], regDst,
			regFileData3, regFileData1, regFileData2);
   
   FlopReset #(32) rfData1Reg(clk, reset, regFileData1, rfData1);
   FlopReset #(32) rfData2Reg(clk, reset, regFileData2, rfData2);

   SignExtend se(instr[15:0], instrSignImmediate);

   assign writeData = rfData2;
   
   // 実行
   Sl2 sl2(instrSignImmediate, instrSignImmediateShift);
   
   Mux2 #(32) srcAMux(pc, instrSignImmediate, aluSrcASel, aluSrcA);
   Mux4 #(32) srcBMux(rfData2, 32'd4, instrSignImmediate, instrSignImmediateShift, aluSrcBSel, aluSrcB);
   
   Alu alu(aluSrcA, aluSrcB, aluControl, aluResult, aluResultZero);

   FlopReset #(32) aluResultReg(clk, reset, aluResult, aluOut);
   
endmodule
