`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/27 14:54:32
// Design Name: LED Lighting
// Module Name: LedLighting
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/**
 * @brief LEDを点灯させる。入力はなく、ひたすら点灯するだけ。
 *
 * @param led ledポート
 */
module LedLighting(
    output logic LED
    );
    
    assign LED = 1'b1;
    
endmodule
