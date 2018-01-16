module MainDec
  (input logic [5:0] op,        // 命令opフィールド
   output logic       memToReg, memWrite, // メモリからレジスタへ、メモリ書き込みイネーブル
   output logic       branch, // ブランチ信号、ゼロ以下ブランチ信号
   output logic       aluSrc, // ALU srcB選択信号
   output logic       regDst, regWrite, // dstレジスタ選択信号、レジスタ書き込みイネーブル
   output logic [1:0] aluOp);             // ALU命令

   logic [10:0] controls;

   assign {regWrite, regDst, aluSrc, branch, memWrite, memToReg, aluOp}
     = controls;

   always_comb
     case (op)
       6'b000000: controls <= 11'b11000000010; // R形式命令
       6'b100011: controls <= 11'b10010001000; // lw命令
       6'b101011: controls <= 11'b00010010000; // sw命令
       6'b000100: controls <= 11'b00001000001; // beq命令
       6'b001000: controls <= 11'b10010000000; // addi命令
       default: controls <= 11'bxxxxxxxxxxx;   // 不正な命令
     endcase // case (op)
   
endmodule // MainDec
