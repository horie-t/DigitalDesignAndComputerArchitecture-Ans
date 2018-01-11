/**
 * マルチサイクル版MIPSマシン
 */
module MipsMCTop
  (input logic clk, reset,	// クロック、リセット
   output logic [31:0] writeData, memoryAddress, // メモリ書き込み値、メモリアドレス
   output logic        memoryWriteEnable); // メモリ書き込みイネーブル

   logic [31:0] readData;	// メモリ読み込み値

   // プロセッサとメモリをインスタンス化
   Mips mips(clk, reset, memoryAddress, writeData, memoryWriteEnable, readData);
   Memory mem(clk, memoryWriteEnable, memoryAddress, writeData, readData);

endmodule // MipsMCTop

   
   
