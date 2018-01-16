/**
 * MIPS CPUモジュール
 */
module Mips
  (input logic clk, reset,
   output logic [31:0] pc,
   input logic [31:0]  instr,
   output logic        memWrite,
   output logic [31:0] dataAddr, writeData, 
   input logic [31:0] readData);

   /* コントローラ出力 */
   logic branchD, pcSrcD, regDstE, aluSrcE, memToRegE, regWriteE, memToRegM, memWriteM, regWriteW, memToRegW;
   logic [2:0] aluControlE;

   /* データ・パス出力 */
   logic       equalD;
   logic [4:0] rsD, rtD, rsE, rtE, writeRegE, writeRegM, writeRegW;

   /* ハザード出力 */
   logic       stallF, stallD, flushE;
   logic       forwardAD, forwardBD;
   logic [1:0] forwardAE, forwardBE;
   
   Controller c(clk, reset, instr[31:26], instr[5:0], equalD, branchD, pcSrcD, 
		flushE, regDstE, aluSrcE, memToRegE, regWriteE, aluControlE,
		memToRegM, memWrite, regWriteM, regWriteW, memToRegW);

   Datapath dp(clk, reset, stallF, pc, instr,
	       stallD, pcSrcD, forwardAD, forwardBD, equalD, rsD, rtD, 
	       flushE, regDstE, aluSrcE, aluControlE, forwardAE, forwardBE, writeRegE, rsE, rtE, 
	       dataAddr, writeData, readData, writeRegM,
	       regWriteW, memToRegW, writeRegW);

   Hazard hz(stallF, branchD, rsD, rtD, stallD, forwardAD, forwardBD, 
	     memToRegE, regWriteE, rsE, rtE, writeRegE, flushE,forwardAE, forwardBE,
	     memToRegM, regWriteM, writeRegM, regWriteW, writeRegW);
   
endmodule // Mips
