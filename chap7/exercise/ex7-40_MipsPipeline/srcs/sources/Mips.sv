/**
 * MIPS CPUモジュール
 */
module Mips
  (input logic clk, reset,
   output logic [31:0] pc,
   input logic [31:0] instr,
   output logic memWrite,
   output logic dataAddr, writeData, readData);

   logic branchD, pcSrcD, regDstE, aluSrcE, memWriteM, regWriteW, memToRegW;
   logic [2:0] aluControlE;
      
   Controller c(clk, reset, equalD, branchD, pcSrcD, regDstE, aluSrcE, aluControlE, memWrite, regWriteW, memToRegW);
   
   logic       equalD;
   logic [4:0] rsD, rtD, rsE, rtE, writeRegE, writeRegM, writeRegW;
   Datapath dp(clk, reset, stallF, pc, instr,
	       stallD, pcSrcD, forwardAD, forwardBD, equalD, rsD, rtD, 
	       flushE, regDstE, aluSrcE, aluControlE, forwardAE, forwardBE, writeRegE, rsE, rtE, 
	       dataAddr, writeData, readData, writeRegM,
	       regWriteW, memToRegW, writeRegW);

   logic       stallF, stallD, flushE;
   logic [1:0] forwardAD, forwardBD, forwardAE, forwardBE;
   Hazard hz(stallF, branchD, rsD, rtD, stallD, forwardAD, forwardBD, 
	     memToRegE, regWriteE, rsE, rtE, writeRegE, flushE,forwardAE, forwardBE,
	     memToRegM, regWriteM, writeRegM, regWriteW, writeRegW);
   
endmodule // Mips
