/**
 * コントローラ
 */
module Controller
  (input logic clk, reset,		   // クロック、リセット
   input logic [5:0]  opField, functField, // 命令コード、ファンクション・コード
   output logic       pcSrcSel, // プログラム・カウンタの選択ステージ(1の時、レジスタ書き戻し)
   output logic       programCounterWriteEnable, // プログラム・カウンタ書き込みイネーブル
   output logic       instrOrDataAddress, // memoryAddressが命令アドレスか、データアドレスか(1の時は命令)
   output logic       memoryWriteEnable,// メモリ書き込みイネーブル 
   output logic       instrReadEnable, // 命令読み込みイネーブル(イネーブル時にreadDataが命令として扱われる)
   output logic       regFileWriteEnable, //レジスタ・ファイル書き込みイネーブル
   output logic       regDstFieldSel, // 宛先レジスタのフィールドがrtかrdか(1の時rd)
   output logic       memToRegSel,// メモリからレジスタへの書き込みかどうか(0の時はR形式の結果書き込み)
   output logic       aluSrcASel, // ALUのソースAがレジスタrsかPCか(1の時レジスタrs)
   output logic [1:0] aluSrcBSel, // ALUのソースB(00: , 01: 4, 10: 命令即値, 11: )
   output logic [2:0] aluControl, // ALU制御
   input logic 	      aluResultZero); // ALU結果ゼロ

   logic programCounterWrite, branchInstr;
   logic [1:0] aluOp;

   MainController mainController(clk, reset, opField, pcSrcSel, programCounterWrite, branchInstr, 
				 instrOrDataAddress, memoryWriteEnable, instrReadEnable,
				 regFileWriteEnable, regDstFieldSel, memToRegSel, aluSrcASel, aluSrcBSel, aluOp);
   AluDec aluDec(functField, aluOp, aluControl);
   
   assign programCounterWriteEnable = programCounterWrite | branchInstr & aluResultZero;
   
endmodule // Controller
