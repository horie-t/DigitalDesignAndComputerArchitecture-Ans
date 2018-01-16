module AluDec
  (input logic [5:0] funct,     // 命令functフィールド
   input logic [1:0]  aluOp,    // ALU命令
   output logic [2:0] aluControl); // ALU制御信号

   always_comb
     case (aluOp)
       2'b00: aluControl <= 3'b010; // add(lw/sw/addiに対応)
       2'b01: aluControl <= 3'b110; // sub(beqに対応)
       default:
         case (funct)           // R形式命令
           6'b100000: aluControl <= 3'b010; // add
           6'b100010: aluControl <= 3'b110; // sub
           6'b100100: aluControl <= 3'b000; // and
           6'b100101: aluControl <= 3'b001; // or
           6'b101010: aluControl <= 3'b111; // slt
           default: aluControl <= 3'bxxx;   // 不正なfunct
         endcase // case (funct)
     endcase // case (aluOp)
   
endmodule // AluDec
