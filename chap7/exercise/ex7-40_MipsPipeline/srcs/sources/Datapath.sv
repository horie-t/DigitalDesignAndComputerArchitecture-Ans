/**
 * データパス
 */
module Datapath
  (input logic clk, reset,
   input logic 	       stallF,
   output logic [31:0] pcF, instrF,
   input logic 	       stallD, pcSrcD,
   input logic [1:0]   forwardAD, forwardBD,
   output logic        equalD,
   output logic [4:0]  rsD, rtD,
   input logic 	       flushE, regDstE, aluSrcE,
   input logic [2:0]   aluControlE,
   input logic [1:0]   forwardAE, forwardBE,
   output logic [4:0]  writeRegE,
   output logic [4:0]  rsE, rtE,
   output logic [31:0] aluOutM, writeDataM,
   input logic [31:0]  readDataM,
   output logic [4:0]  writeRegM,
   input logic 	       regWriteW,
   input logic 	       memToRegW,
   output logic [4:0]  writeRegW);
   
   typedef logic [31:0] word_t;	// MIPSの1ワード
   typedef logic [4:0] 	regNum_t; // レジスタ番号
   
   /*
    * 信号線の命名規則
    * 末尾の大文字は以下のステージを表す
    * F: フェッチ、D: デコード、E: 実行、M: メモリアクセス、W: レジスタ書き戻し
    */

   word_t pcNext;		// 次のプログラム・カウンタ
   Mux2 #(32) pcSrcMux(pcPlus4F, pcBranchD, pcSrcD, pcNext);

   /*
    * フェッチ・ステージ
    */
   word_t pcF;		// プログラム・カウンタ
   word_t pcPlus4F;	// 1ワード先のプログラム・カウンタ
   word_t instrF;	// 命令
   FlopEnable #(32) pcReg(clk, reset, ~stallF, pcNext, pcF);
   assign pcPlus4F = pcF + 32'd4;
   
   /* 
    * デコード・ステージ
    */
   word_t instrD, pcPlus4D;
   logic [5:0] opcode, shamt,funct; // 命令のopcode, shamtとfunctフィールド
   regNum_t rsD, rtD, rdD;	    // 命令のrs, rt, rdフィールド
   logic [15:0] imm;		    // 命令のImmフィールド
   word_t signImmD, pcBranchD;	    // 符号拡張Imm、分岐アドレス
   word_t regRsData, regRtData;	    // レジスタに保存されているrs, rtの値
   word_t rsDataD, rtDataD;	    // フォワーディングを加味したrs, rtの値
   logic 	equalD;		    // rs, rtの値が等しいかどうか
   
   FlopEnable #(32 * 2) decReg(clk, reset | pcSrcD, ~stallD, 
			       {instrF, pcPlus4F}, {instrD, pcPlus4D});
   assign {opcode, rs, rt, rd, funct} = instrD;
   assign imm = instrD[15:0];

   RegisterFile(~clk, regWriteW, rs, rt, writeRegW, resultW, regRsData, regRtData);
   Mux2 #(32) rsMux(regRsData, aluOutM, forwardAD, rsDataD);
   Mux2 #(32) rtMux(regRtData, aluOutM, forwardBD, rtDataD);
   
   SignExtend(imm, signImmD);
   assign pcBranchD = signImmD << 2 + pcPlus4D;

   /*
    * 実行ステージ
    */
   word_t rsDataE, rtDataE, rdDataE, signImmE;
   word_t srcAForwardE, srcBForwardE, srcBE;
   regNum_t rsE, rtE, rdE, writeRegE;
   word_t aluOutE;
   logic aluZero;
   
   FlopReset #(32 * 3 + 5 * 3) exeReg(clk, reset | flushE,
				      {rsDataD, rtDataD, rsD, rtD, rdD, signImmD},
				      {rsDataE, rtDataE, rsE, rtE, rdE, signImmE});

   Mux2 #(32) writeRegMux(rtE, rdE, regDstE, writeRegE);
   
   Mux3 #(32) srcAForwardMux(rsDataE, ResultW, aluOutM, forwardAE, srcAForwardE);
   Mux3 #(32) srcBForwardMux(rtDataE, ResultW, aluOutM, forwardBE, srcAForwardE);
   Mux2 #(32) srcBMux(srcBForwardE, signImmE, aluSrcE, srcBE);

   Alu alu(srcAForwardE, srcBE, aluControlE, aluOutE, aluZero);
   
   /*
    * メモリ・アクセス・ステージ
    */
   FlopReset #(32 * 2 + 5) memReg(clk, reset,
				  {aluOutE, srcBE, writeRegE},
				  {aluOutM, writeDataM, writeRegM});

   /*
    * レジスタ書き戻しステージ
    */
   word_t readDataW, aluOutM;
   regNum_t writeRegW;
   word_t resultW;
   
   FlopReset #(32 * 2 + 5) wbReg(clk, reset,
				 {readDataM, aluOutM, writeRegM},
				 {readDataW, aluOutW, writeRegW});

   Mux2 #(32) resultMux(readDataW, aluOutW, memToRegW, resultW);
   
endmodule // Datapath
