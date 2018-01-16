/**
 * レジスタ・ファイル
 * 
 * 2つのポートから読み出し、1つのポートに書き込む。
 * 書き込みは、クロックの立ち上がりで、イネーブルが有効な時に行う。
 * 
 * レジスタ0は0になる。
 * 
 * パイプライン化したプロセッサでは、書き込みは立ち下がりで行うので、反転したクロックを与える事。
 */
module RegisterFile
  (input logic clk,             // クロック
   input logic 	       writeEn3, // 書き込みイネーブル
   input logic [4:0]   readAddr1, readAddr2, // 読み出しアドレス1, 読み出しアドレス2, 
   input logic [4:0]   writeAddr3, // 書き込みアドレス3
   input logic [31:0]  writeData3, // 書き込み値3
   output logic [31:0] readData1, readData2);     // 読み出し値1, 読み出し値2

   logic [31:0]        regFile[31:0];       // レジスタファイル

   always_ff @(posedge clk)
     if (writeEn3) regFile[writeAddr3] <= writeData3;

   assign readData1 = (readAddr1 != 0) ? regFile[readAddr1] : 0;
   assign readData2 = (readAddr2 != 0) ? regFile[readAddr2] : 0;

endmodule // RegisterFile

