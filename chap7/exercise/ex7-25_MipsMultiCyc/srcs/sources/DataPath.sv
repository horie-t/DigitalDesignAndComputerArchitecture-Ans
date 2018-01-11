/**
 * データパス
 */
module DataPath
  (input logic clk, reset, 	// クロック、リセット
   output logic [31:0] memoryAddress, // メモリアドレス
   input logic 	       instrReadEnable, // 命令読み込みイネーブル(イネーブル時にreadDataが命令として扱われる)
   input logic [31:0]  readData);       // メモリ読み込み値

   logic [31:0] pc, pcNext, instr; // プログラム・カウンタ値、次のプログラム・カウンタ値、命令値
      
   FlopReset #(32) programCounterReg(clk, reset, pcNext, pc); // プログラム・カウンタ・レジスタ
   FlopEnable #(32) instrReg(clk, reset, instrReadEnable, readData, instr);

   assign memoryAddress = pc;
   
endmodule
   
