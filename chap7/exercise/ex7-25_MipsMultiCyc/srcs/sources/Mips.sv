/**
 * MIPS CPUモジュール
 */
module Mips
  (input logic clk, reset, 	// クロック、リセット
   output logic [31:0] memoryAddress, writeData, // メモリ・アドレス、メモリ書き込み値
   output logic memoryWriteEnable,		 // メモリ書き込みイネーブル
   input logic [31:0] readData);		 // メモリ読み込み値
   

   logic programCounterWriteEnable;	// プログラム・カウンタの書き込みイネーブル
   logic instrOrDataAddress;		// memoryAddressが命令アドレスか、データアドレスか(1の時は命令)
   logic instrReadEnable;		// 命令読み込みイネーブル
   logic regFileWriteEnable;   // レジスタ・ファイル書き込みイネーブル
   logic aluSrcASel; // ALUのソースAがレジスタrsかPCか(1の時レジスタrs)
   logic [1:0] aluSrcBSel; // ALUのソースB(00: , 01: 4, 10: 命令即値, 11: )
   logic [2:0] aluControl;	// ALU制御
   logic       aluResultZero;	// ALU演算結果ゼロ

   DataPath dp(clk, reset, programCounterWriteEnable, 
	       memoryAddress, instrOrDataAddress, instrReadEnable, readData, writeData,
	       regFileWriteEnable,
	       aluSrcASel, aluSrcBSel, aluControl, aluResultZero);
   
endmodule // Mips
