/**
 * メイン・コントローラ
 */
module MainController
  (input clk, reset,			   // クロック、リセット
   input logic [5:0]  opField, // 命令コード
   output logic       pcSrcSel, // プログラム・カウンタの選択ステージ(1の時、レジスタ書き戻し)
   output logic       programCounterWrite, // プログラム・カウンタ書き込み
   output logic       branchInstr, // ブランチ命令
   output logic       instrOrDataAddress, // memoryAddressが命令アドレスか、データアドレスか(1の時は命令)
   output logic       memoryWriteEnable, // メモリ書き込みイネーブル
   output logic       instrReadEnable, // 命令読み込みイネーブル(イネーブル時にreadDataが命令として扱われる)
   output logic       regFileWriteEnable, //レジスタ・ファイル書き込みイネーブル
   output logic       memToRegSel, // メモリからレジスタへの書き込みかどうか(0の時はR形式の結果書き込み) 
   output logic       regDstFieldSel, // 宛先レジスタのフィールドがrtかrdか(1の時rd)
   output logic       aluSrcASel, // ALUのソースAがレジスタrsかPCか(1の時レジスタrs)
   output logic [1:0] aluSrcBSel, // ALUのソースB(00: , 01: 4, 10: 命令即値, 11: )
   output logic [1:0] aluOp);	  // ALUデコーダの制御

   typedef enum       logic [3:0] {S0Fetch, S1Decode, S2MemAddr, S3MemRead, S4MemWriteback} state_t;

   state_t opState;

   always_ff @(posedge clk, posedge reset)
     if (reset) opState <= S0Fetch;
     else
       case (opState)
	 S0Fetch: 
	   opState <= S1Decode;
	 S1Decode: 
	   opState <= S2MemAddr;
	 S2MemAddr:
	   opState <= S3MemRead;
	 S3MemRead:
	   opState <= S4MemWriteback;
	 S4MemWriteback:
	   opState <= S0Fetch;
	 default:
	   opState <= S0Fetch;
       endcase // case (opState)

   always_comb
     case (opState)
       S0Fetch:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 0;
	    instrReadEnable = 1;
	    programCounterWrite = 1;
	    branchInstr = 0;
	    regFileWriteEnable = 0;
	    regDstFieldSel = 0;
	    memToRegSel = 0;
	 end
       S1Decode:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 0;
	    instrReadEnable = 0;
	    programCounterWrite = 0;
	    branchInstr = 0;
	    regFileWriteEnable = 0;
	    regDstFieldSel = 0;
	    memToRegSel = 0;
	 end
       S2MemAddr:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b1;
	    aluSrcBSel = 2'b10;
	    aluOp = 2'b00;
	    pcSrcSel = 0;
	    instrReadEnable = 0;
	    programCounterWrite = 0;
	    branchInstr = 0;
	    regFileWriteEnable = 0;
	    regDstFieldSel = 0;
	    memToRegSel = 0;
	 end
       S3MemRead:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 0;
	    instrReadEnable = 0;
	    programCounterWrite = 0;
	    branchInstr = 0;
	    regFileWriteEnable = 1;
	    regDstFieldSel = 0;
	    memToRegSel = 0;
	 end // case: S3MemRead
       S4MemWriteback:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 0;
	    instrReadEnable = 0;
	    programCounterWrite = 0;
	    branchInstr = 0;
	    regFileWriteEnable = 1;
	    regDstFieldSel = 0;
	    memToRegSel = 1;
	 end
       default:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 0;
	    instrReadEnable = 0;
	    programCounterWrite = 0;
	    branchInstr = 0;
	    regFileWriteEnable = 0;
	    regDstFieldSel = 0;
	    memToRegSel = 0;
	 end
     endcase // case (opState)
   
endmodule // MainController
