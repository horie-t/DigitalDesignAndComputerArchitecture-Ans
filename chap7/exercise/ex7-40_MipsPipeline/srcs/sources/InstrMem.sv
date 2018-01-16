/**
 * 命令メモリ
 * 
 * シミュレーションでは、memfile.datからデータを読み込む。
 */
module InstrMem
  (input logic [5:0] addr,         // アドレス(pc[7:2]を受け取る)
   output logic [31:0] readData);     // 命令データ

   logic [31:0] ram[63:0];

   initial
     $readmemh("memfile.dat", ram);

   assign readData = ram[addr];          // ワード整列

endmodule // InstrMem

