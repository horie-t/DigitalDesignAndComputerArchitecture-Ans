/**
 * ハザード・ユニット
 */
module Hazard
  (output logic       stallF,
   input logic 	      branchD, 
   input logic [4:0]  rsD, rtD,
   output logic       stallD,
   output logic       forwardAD, forwardBD, 
   input logic 	      memToRegE, regWriteE, 
   input logic [4:0]  rsE, rtE, writeRegE, 
   output logic       flushE,
   output logic [1:0] forwardAE, forwardBE,
   input logic 	      memToRegM, regWriteM, 
   input logic [4:0]  writeRegM,
   input logic 	      regWriteW,
   input logic [4:0]  writeRegW);
   
   logic 	      lwStall;
   logic 	      branchStall;
   logic 	      stall;
   
   always_comb
     begin
	/*
	 * データハザード対策(フォワーディング)
	 */
	// rsレジスタ
	if ((rsE != 0) & (rsE == writeRegM) & regWriteM)
	  forwardAE = 2'b10;
	else if ((rsE != 0) & (rsE == writeRegW) & regWriteW)
	  forwardAE = 2'b01;
	else
	  forwardAE = 2'b00;

	// rtレジスタ
	if ((rtE != 0) & (rtE == writeRegM) & regWriteM)
	  forwardBE = 2'b10;
	else if ((rtE != 0) & (rtE == writeRegW) & regWriteW)
	  forwardBE = 2'b01;
	else
	  forwardBE = 2'b00;

	/*
	 * データハザード対策(ストール)
	 */
	lwStall = ((rsD == rsE) | (rtD == rtE)) & memToRegE;

	/*
	 * 制御ハザード対策(フォワーディング)
	 */
	forwardAD = ((rsD != 0) | (rsD == writeRegM)) & regWriteM;
	forwardBD = ((rtD != 0) | (rtD == writeRegM)) & regWriteM;

	/*
	 * 制御ハザード対策(ストール)
	 */
	branchStall = branchD & regWriteE & (writeRegE == rsD | writeRegE == rtD)
	  | branchD & memToRegM & (writeRegM == rsD | writeRegM == rtD);
	
	/*
	 * ハザード・ユニット全体としてのストール
	 */
	stall = lwStall | branchStall;
	stallF = stall;
	stallD = stall;
	flushE = stall;
     end // always_comb
   
endmodule // Hazard
