/**
 * メモリ・モジュール
 */
module Memory
  (input logic clk, writeEnable, // クロック、メモリ書き込みイネーブル
   input logic [31:0]  address, writeData, // メモリ・アドレス(ワード単位指定)、書き込み値
   output logic [31:0] readData);	  // 読み込み値

   logic [31:0] ram[63:0];	// RAM(64ワード分のみ)

   initial
     begin
	$readmemh("memfile.dat", ram);
     end

   assign readData = ram[address[31:2]]; // ワード・アライメント

   always @(posedge clk)
     if (writeEnable) ram[address[31:2]] <= writeData;

endmodule // Memory
