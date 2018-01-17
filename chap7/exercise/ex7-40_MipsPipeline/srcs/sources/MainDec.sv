module MainDec
  (input logic [5:0] op,        // 命令opフィールド
   output logic       memToReg, memWrite, // メモリからレジスタへ、メモリ書き込みイネーブル
   output logic       jump,		  // ジャンプ信号
   output logic       branch, // ブランチ信号、ゼロ以下ブランチ信号
   output logic       aluSrc, // ALU srcB選択信号
   output logic       regDst, regWrite, // dstレジスタ選択信号、レジスタ書き込みイネーブル
   output logic [1:0] aluOp);             // ALU命令

   logic [8:0] controls;

   assign {regWrite, regDst, aluSrc, branch, memWrite, memToReg, jump, aluOp}
     = controls;

   always_comb
     case (op)
       6'b000000: controls <= 9'b110000010; // R形式命令
       6'b100011: controls <= 9'b101001000; // lw命令
       6'b101011: controls <= 9'b001010000; // sw命令
       6'b000100: controls <= 9'b000100001; // beq命令
       6'b001000: controls <= 9'b101000000; // addi命令
       6'b000010: controls <= 9'b000000100; // J命令
       default: controls <= 9'bxxxxxxxxx;   // 不正な命令
     endcase // case (op)
   
endmodule // MainDec
