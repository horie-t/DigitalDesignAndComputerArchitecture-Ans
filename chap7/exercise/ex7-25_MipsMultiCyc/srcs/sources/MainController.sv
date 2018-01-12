/**
 * メイン・コントローラ
 */
module MainController
  (input logic [5:0] opField, // 命令コード
   output logic       programCounterWrite, // プログラム・カウンタ書き込み
   output logic       branchInstr, // ブランチ命令
   output logic       instrOrDataAddress, // memoryAddressが命令アドレスか、データアドレスか(1の時は命令)
   output logic       instrReadEnable, // 命令読み込みイネーブル(イネーブル時にreadDataが命令として扱われる)
   output logic       regFileWriteEnable, //レジスタ・ファイル書き込みイネーブル
   output logic       regDstFieldSel, // 宛先レジスタのフィールドがrtかrdか(1の時rd)
   output logic       aluSrcASel, // ALUのソースAがレジスタrsかPCか(1の時レジスタrs)
   output logic [1:0] aluSrcBSel); // ALUのソースB(00: , 01: 4, 10: 命令即値, 11: )


endmodule // MainController
