/**
 * MIPS CPUモジュール
 */
module Mips
  (input logic clk, reset, 	// クロック、リセット
   output logic [31:0] memoryAddress, writeData, // メモリ・アドレス、メモリ書き込み値
   output logic memoryWriteEnable,		 // メモリ書き込みイネーブル
   input logic [31:0] readData);		 // メモリ読み込み値

   logic [5:0] opField, functField; // 命令のopフィールド、functフィールド
   logic       pcSrcSel;	 // プログラム・カウンタの選択ステージ(1の時、レジスタ書き戻し)
   logic       programCounterWriteEnable;	// プログラム・カウンタの書き込みイネーブル
   logic       instrOrDataAddress;		// memoryAddressが命令アドレスか、データアドレスか(1の時は命令)
   logic       instrReadEnable;		// 命令読み込みイネーブル
   logic       regFileWriteEnable;   // レジスタ・ファイル書き込みイネーブル
   logic       regDstFieldSel; // 宛先レジスタのフィールドがrtかrdか(1の時rd)
   logic       memToRegSel; // メモリからレジスタへの書き込みかどうか(0の時はR形式の結果書き込み)
   logic       aluSrcASel; // ALUのソースAがレジスタrsかPCか(1の時レジスタrs)
   logic [1:0] aluSrcBSel; // ALUのソースB(00: , 01: 4, 10: 命令即値, 11: )
   logic [2:0] aluControl;	// ALU制御
   logic       aluResultZero;	// ALU結果ゼロ

   Controller c(clk, reset, opField, functField, pcSrcSel, programCounterWriteEnable, 
		instrOrDataAddress, instrReadEnable, memoryWriteEnable,
		regFileWriteEnable, regDstFieldSel, memToRegSel, aluSrcASel, aluSrcBSel, aluControl, aluResultZero);
   DataPath dp(clk, reset, pcSrcSel, programCounterWriteEnable, 
	       memoryAddress, instrOrDataAddress, instrReadEnable, readData, writeData,
	       opField, functField, regFileWriteEnable, regDstFieldSel, memToRegSel,
	       aluSrcASel, aluSrcBSel, aluControl, aluResultZero);
   
endmodule // Mips
