/**
 * MIPS CPUモジュール
 */
module Mips
  (input logic clk, reset, 	// クロック、リセット
   output logic [31:0] memoryAddress, writeData, // メモリ・アドレス、メモリ書き込み値
   output logic memoryWriteEnable,		 // メモリ書き込みイネーブル
   input logic [31:0] readData);		 // メモリ読み込み値

   DataPath dp(clk, reset, memoryAddress, instrWriteEnable, readData);
   
endmodule // Mips
