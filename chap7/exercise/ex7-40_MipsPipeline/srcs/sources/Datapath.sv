/**
 * データパス
 * 
 * 信号線の命名規則
 * 末尾の大文字は以下のステージを表す
 * F: フェッチ、D: デコード、E: 実行、M: メモリアクセス、W: レジスタ書き戻し
 */
module Datapath
  (input logic clk, reset,
   input logic 	       stallF,
   output logic [31:0] pcF, 
   input logic [31:0]  instrF,
   input logic 	       stallD, 
   input logic [1:0]   pcSrcD,
   input logic 	       forwardAD, forwardBD,
   output logic        equalD,
   output logic [4:0]  rsD, rtD, // 命令のrs, rt, rdフィールド
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
   
   /* フェッチ・ステージ */
   word_t pcPlus4F;	// 1ワード先のプログラム・カウンタ
   logic [3:0] pcJumpPreF;	// J命令アドレスのPrefix
      
   /* デコード・ステージ */
   word_t instrD, pcPlus4D;
   logic [3:0] pcJumpPreD;	// J命令アドレスのPrefix
   word_t pcJumpD;		// J命令の飛び先アドレス
   logic [5:0] opcode, funct; // 命令のopcodeとfunctフィールド
   logic [4:0] shamt;	            // 命令のshamt
   regNum_t rdD;		    // 命令のrs, rt, rdフィールド
   logic [15:0] imm;		    // 命令のImmフィールド
   word_t signImmD, pcBranchD;	    // 符号拡張Imm、分岐アドレス
   word_t regRsData, regRtData;	    // レジスタに保存されているrs, rtの値
   word_t rsDataD, rtDataD;	    // フォワーディングを加味したrs, rtの値
   
   /* 実行ステージ */
   word_t rsDataE, rtDataE, rdDataE, signImmE;
   word_t srcAForwardE, srcBForwardE, srcBE;
   regNum_t rdE;
   word_t aluOutE;
   logic aluZero;

   /* レジスタ書き戻しステージ */
   word_t readDataW, aluOutW, resultW;
   
   /*
    * PCの選択
    */
   Mux3 #(32) pcSrcMux(pcPlus4F, pcBranchD, pcJumpD, pcSrcD, pcNext);

   /*
    * フェッチ・ステージ
    */
   FlopEnable #(32) pcReg(clk, reset, ~stallF, pcNext, pcF);
   assign pcPlus4F = pcF + 32'd4;
   assign pcJumpPreF = pcF[31:28];
      
   /* 
    * デコード・ステージ
    */
   FlopEnable #(32 * 2 + 4) decReg(clk, (reset | pcSrcD), ~stallD, 
				   {instrF, pcPlus4F, pcJumpPreF}, 
				   {instrD, pcPlus4D, pcJumpPreD});
   assign {opcode, rsD, rtD, rdD, shamt,funct} = instrD;
   assign imm = instrD[15:0];

   RegisterFile regFile(~clk, regWriteW, rsD, rtD, writeRegW, resultW, regRsData, regRtData);
   Mux2 #(32) rsMux(regRsData, aluOutM, forwardAD, rsDataD);
   Mux2 #(32) rtMux(regRtData, aluOutM, forwardBD, rtDataD);
   assign equalD = rsDataD == rtDataD;
   
   SignExtend se(imm, signImmD);
   assign pcBranchD = signImmD << 2 + pcPlus4D;
   assign pcJumpD = {pcJumpPreD, instrD[25:0], 2'b00};
   
   /*
    * 実行ステージ
    */
   FlopReset #(32 * 3 + 5 * 3) exeReg(clk, (reset | flushE),
				      {rsDataD, rtDataD, rsD, rtD, rdD, signImmD},
				      {rsDataE, rtDataE, rsE, rtE, rdE, signImmE});

   Mux2 #(5) writeRegMux(rtE, rdE, regDstE, writeRegE);
   
   Mux3 #(32) srcAForwardMux(rsDataE, resultW, aluOutM, forwardAE, srcAForwardE);
   Mux3 #(32) srcBForwardMux(rtDataE, resultW, aluOutM, forwardBE, srcBForwardE);
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
   FlopReset #(32 * 2 + 5) wbReg(clk, reset,
				 {readDataM, aluOutM, writeRegM},
				 {readDataW, aluOutW, writeRegW});

   Mux2 #(32) resultMux(readDataW, aluOutW, memToRegW, resultW);
   
endmodule // Datapath
