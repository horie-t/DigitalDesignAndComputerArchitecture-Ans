module testbench
  ();

   logic clk;
   logic reset;

   logic [31:0] writedata, dataadr;
   logic        memwrite;

   // テストするデバイスをインスタンス化
   MipsMCTop dut(clk, reset, writedata, dataadr, memwrite);

   // テストの初期化
   initial
     begin
        reset <= 1; #22; reset <= 0;
     end

   // テストを進めるクロックを生成
   always
     begin
        clk <= 1; #5; clk <= 0; #5;
     end

   // 結果を検査
   always @(negedge clk)
     begin
        if (memwrite) 
          begin
             if (dataadr === 84 & writedata === 7) 
               begin
                  $display("Simulation succeeded");
                  $stop;
               end
             else if (dataadr !== 80) 
               begin
                  $display("Simulation failed");
                  $stop;
               end
          end // if (memwrite)
     end // always @ (negedge clk)

endmodule // testbench
