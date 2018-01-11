/**
 * レジスタ・ファイル
 * 
 * 2つのポートから読み出し、1つのポートに書き込む。
 * 書き込みは、クロックの立ち上がりで、イネーブルが有効な時に行う。
 * 
 * レジスタ0は0になる。
 * 
 * パイプライン化したプロセッサでは、書き込みは立ち下がりで行う。
 */
module RegisterFile
  (input logic clk,             // クロック
   input logic 	       writeEnabel3, // 書き込みイネーブル
   input logic [4:0]   readAddress1, readAddress2, // 読み出しアドレス1, 読み出しアドレス2, 
   input logic [4:0]   writeAddres3, // 書き込みアドレス3
   input logic [31:0]  writeData3, // 書き込み値3
   output logic [31:0] readData1, readData2);     // 読み出し値1, 読み出し値2

   logic [31:0]        registerFile[31:0];       // レジスタファイル

   always_ff @(posedge clk)
     if (writeEnabel3) registerFile[writeAddres3] <= writeData3;

   assign readData1 = (readAddress1 != 0) ? registerFile[readAddress1] : 0;
   assign readData2 = (readAddress2 != 0) ? registerFile[readAddress2] : 0;

endmodule // RegisterFile

