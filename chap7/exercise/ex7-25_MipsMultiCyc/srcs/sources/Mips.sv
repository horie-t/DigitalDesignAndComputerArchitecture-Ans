/**
 * MIPS CPUモジュール
 */
module Mips
  (input logic clk, reset, 	// クロック、リセット
   output logic [31:0] memoryAddress, writeData, // メモリ・アドレス、メモリ書き込み値
   output logic memoryWriteEnable,		 // メモリ書き込みイネーブル
   input logic [31:0] readData);		 // メモリ読み込み値
   

   logic [2:0] aluControl;	// ALU制御
   logic       aluResultZero;	// ALU演算結果ゼロ

   DataPath dp(clk, reset, memoryAddress, instrWriteEnable, readData, aluControl, aluResultZero);
   
endmodule // Mips
