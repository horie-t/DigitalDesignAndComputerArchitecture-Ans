/**
 * データ・メモリ
 * 
 * バイト単位のアクセスはできない
 */
module DataMem
  (input logic clk, writeEn,         // クロック、書き込みイネーブル
   input logic [31:0]  addr, writeData, // アドレス、書き込みデータ
   output logic [31:0] readData);     // 読み出しデータ

   logic [31:0] ram[63:0];      // メモリ(64ワードのみ)

   always_ff @(posedge clk)
     if (writeEn) ram[addr[31:2]] <= writeData;
   
   assign readData = ram[addr[31:2]];    // ワード整列したアクセスのみ
                           
endmodule // dmem
