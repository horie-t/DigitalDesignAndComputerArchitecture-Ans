`timescale 1ns / 1ps

module testbench1();
   logic a, b, c, y;

   // テストしたいデバイスをインスタンス化
   sillyfunction dut(a, b, c, y);

   // 入力は一度に一つずつ与える
   initial begin
      a = 0; b = 0; c = 0; #10;
      c = 1;               #10;
      b = 1; c = 0;        #10;
      c = 1;               #10;
      a = 1; b = 0; c = 0; #10;
      c = 1;               #10;
      b = 1; c = 0;        #10;
      c = 1;               #10;
   end

endmodule // testbench1

     
      
      
      
      
      
      
      
      
      
      
      
      
      
      
