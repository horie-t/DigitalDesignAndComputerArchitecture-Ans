/**
 * コントローラ
 */
module Controller
  (input logic clk, reset,
   input logic 	equalD,
   output logic pcSrcD, branchD,
   output logic regDstE, aluSrcE, 
   output logic [2:0] aluControlE,
   output logic memWriteM,
   output logic regWriteW, memToRegW);

   logic [1:0] aluOp;

   // デコード・ステージ
   logic       memToRegD, memWriteD, aluSrcD, regDstD, regWriteD;
   logic [2:0] aluControlD;
         
   MainDec mainDec(op, memToRegD, memWriteD, branchD, aluSrcD, regDstD, regWriteD, aluOp);
   AluDec aluDec(funct, aluOp, aluControlD);

   assign pcSrcD = branchD & equalD;
   
   // 実行ステージ
   logic       regWriteE, memToRegE, memWriteE;
   
   FlopReset exeReg(clk, reset | flushE,
		    {regWriteD, memToRegD, memWriteD, aluControlD, aluSrcD, regDstD},
		    {regWriteE, memToRegE, memWriteE, aluControlE, aluSrcE, regDstE});
   
   // メモリ・アクセス・ステージ
   logic       regMemWriteM, memToRegM;
   
   FlopReset memReg(clk, reset,
		    {regWriteM, memToRegM, memWriteM},
		    {regWriteM, memToRegM, memWriteM});
   
   // レジスタ書き戻しステージ
   FlopReset wbReg(clk, reset,
		   {regWriteM, memToRegM},
		   {regWriteW, memToRegW});

endmodule // Controller
