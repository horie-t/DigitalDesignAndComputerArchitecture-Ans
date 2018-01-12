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

   typedef enum       logic [3:0] {S0Fetch, S1Decode, S2MemAddr, S3MemRead, S4MemWriteback,
				   S5MemWrite, S6Execute, S7ALUWriteback, S8Branch} state_t;
   parameter OPlw = 6'b100011;	// lw命令
   parameter OPRtype = 6'b000000; // R形式命令
   parameter OPsw = 6'b101011;	  // sw命令
   parameter OPbeq = 6'b000100;	  // beq命令
   parameter OPaddi = 6'b001000; // addi命令
   parameter OPj = 6'b000010; // J命令

   state_t opState;

   always_ff @(posedge clk, posedge reset)
     if (reset) opState <= S0Fetch;
     else
       case (opState)
	 S0Fetch: 
	   opState <= S1Decode;
	 S1Decode:
	   if (opField == OPlw | opField == OPsw)
	     opState <= S2MemAddr;
	   else if (opField == OPRtype)
	     opState <= S6Execute;
	   else if (opField == OPbeq)
	     opState <= S8Branch;
	 S2MemAddr:
	   if (opField == OPlw)
	     opState <= S3MemRead;
	   else if (opField == OPsw)
	     opState <= S5MemWrite;
	 S3MemRead:
	   opState <= S4MemWriteback;
	 S4MemWriteback:
	   opState <= S0Fetch;
	 S5MemWrite:
	   opState <= S0Fetch;
	 S6Execute:
	   opState <= S7ALUWriteback;
	 S7ALUWriteback:
	   opState <= S0Fetch;
	 S8Branch:
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
	    pcSrcSel = 1'b0;
	    instrReadEnable = 1'b1;
	    programCounterWrite = 1'b1;
	    branchInstr = 1'b0;
	    regFileWriteEnable = 1'b0;
	    regDstFieldSel = 1'b0;
	    memToRegSel = 1'b0;
	 end
       S1Decode:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 1'b0;
	    instrReadEnable = 1'b0;
	    programCounterWrite = 1'b0;
	    branchInstr = 1'b0;
	    regFileWriteEnable = 1'b0;
	    regDstFieldSel = 1'b0;
	    memToRegSel = 1'b0;
	 end
       S2MemAddr:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b1;
	    aluSrcBSel = 2'b10;
	    aluOp = 2'b00;
	    pcSrcSel = 1'b0;
	    instrReadEnable = 1'b0;
	    programCounterWrite = 1'b0;
	    branchInstr = 1'b0;
	    regFileWriteEnable = 1'b0;
	    regDstFieldSel = 1'b0;
	    memToRegSel = 1'b0;
	 end
       S3MemRead:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 1'b0;
	    instrReadEnable = 1'b0;
	    programCounterWrite = 1'b0;
	    branchInstr = 1'b0;
	    regFileWriteEnable = 1'b1;
	    regDstFieldSel = 1'b0;
	    memToRegSel = 1'b0;
	 end
       S4MemWriteback:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 1'b0;
	    instrReadEnable = 1'b0;
	    programCounterWrite = 1'b0;
	    branchInstr = 1'b0;
	    regFileWriteEnable = 1'b1;
	    regDstFieldSel = 1'b0;
	    memToRegSel = 1'b1;
	 end
       S5MemWrite:
	 begin
	    instrOrDataAddress = 1'b1;
	    memoryWriteEnable = 1'b1;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 1'b0;
	    instrReadEnable = 1'b0;
	    programCounterWrite = 1'b0;
	    branchInstr = 1'b0;
	    regFileWriteEnable = 1'b0;
	    regDstFieldSel = 1'b0;
	    memToRegSel = 1'b0;
	 end
       S6Execute:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b1;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b10;
	    pcSrcSel = 1'b0;
	    instrReadEnable = 1'b0;
	    programCounterWrite = 1'b0;
	    branchInstr = 1'b0;
	    regFileWriteEnable = 1'b0;
	    regDstFieldSel = 1'b0;
	    memToRegSel = 1'b0;
	 end
       S7ALUWriteback:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 1'b0;
	    instrReadEnable = 1'b0;
	    programCounterWrite = 1'b0;
	    branchInstr = 1'b0;
	    regFileWriteEnable = 1'b1;
	    regDstFieldSel = 1'b1;
	    memToRegSel = 1'b0;
	 end
       S8Branch:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b1;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b01;
	    pcSrcSel = 1'b1;
	    instrReadEnable = 1'b0;
	    programCounterWrite = 1'b0;
	    branchInstr = 1'b1;
	    regFileWriteEnable = 1'b0;
	    regDstFieldSel = 1'b0;
	    memToRegSel = 1'b0;
	 end
       default:
	 begin
	    instrOrDataAddress = 1'b0;
	    memoryWriteEnable = 1'b0;
	    aluSrcASel = 1'b0;
	    aluSrcBSel = 2'b00;
	    aluOp = 2'b00;
	    pcSrcSel = 1'b0;
	    instrReadEnable = 1'b0;
	    programCounterWrite = 1'b0;
	    branchInstr = 1'b0;
	    regFileWriteEnable = 1'b0;
	    regDstFieldSel = 1'b0;
	    memToRegSel = 1'b0;
	 end
     endcase // case (opState)
   
endmodule // MainController
