/**
 * コントローラ
 */
module Controller
  (input logic clk, reset,
   input logic [5:0]  op, funct,
   input logic 	      equalD,
   output logic [1:0] pcSrcD,
   output logic       jumpOrBranchD, 
   input logic 	      flushE, 
   output logic       regDstE, aluSrcE, memToRegE, regWriteE,
   output logic [2:0] aluControlE,
   output logic       memToRegM, memWriteM, regWriteM,
   output logic       regWriteW, memToRegW);

   /* デコード・ステージ */
   logic       memToRegD, memWriteD, jumpD, branchD, aluSrcD, regDstD, regWriteD;
   logic [1:0] aluOp;
   logic [2:0] aluControlD;
   /* 実行ステージ */
   logic       memWriteE;
   
   MainDec mainDec(op, memToRegD, memWriteD, jumpD, branchD, aluSrcD, regDstD, regWriteD, aluOp);
   AluDec aluDec(funct, aluOp, aluControlD);

   assign jumpOrBranchD = jumpD | branchD;
   
   always_comb
     if (jumpD)
       pcSrcD = 2'b10;
     else if (branchD & equalD)
       pcSrcD = 2'b01;
     else
       pcSrcD = 2'b00;
   
   FlopReset #(8) exeReg(clk, reset | flushE,
			{regWriteD, memToRegD, memWriteD, aluControlD, aluSrcD, regDstD},
			{regWriteE, memToRegE, memWriteE, aluControlE, aluSrcE, regDstE});
   
   FlopReset #(3) memReg(clk, reset,
			{regWriteE, memToRegE, memWriteE},
			{regWriteM, memToRegM, memWriteM});
   
   FlopReset #(2) wbReg(clk, reset,
		       {regWriteM, memToRegM},
		       {regWriteW, memToRegW});
   
endmodule // Controller
