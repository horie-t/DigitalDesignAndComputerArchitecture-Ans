/**
 * パイプライン版MIPSマシン
 */
module MipsPLTop
  (input logic clk, reset,      // クロック、リセット
   output logic [31:0] writeData, dataAddr, // 書き込みデータ、データアドレス
   output logic       memWrite);           // 書き込みするかどうか
   
   logic [31:0] pc, instr, readData; // プログラム・カウンタ、命令データ、読み出しデータ

   Mips mips(clk, reset, pc, instr, memWrite, dataAddr, writeData, readData);
   InstrMem imem(pc[7:2], instr);
   DataMem dmem(clk, memWrite, dataAddr, writeData, readData);

endmodule // MipsPLTop
