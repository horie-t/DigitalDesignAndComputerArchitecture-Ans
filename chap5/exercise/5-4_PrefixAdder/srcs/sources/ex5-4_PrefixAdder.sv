`timescale 1ns / 1ps

/**
 * 16ビット・プリフィックス加算器
 */
module PrefixAdder16(input logic [15:0] a, b,
		     output logic [15:0] s);

   logic [14:0] p_prepro;
   logic [14:0] g_prepro;

   genvar i;
   
   generate
      for (i = 0; i <= 14; i = i + 1) begin: loop_prepro
	 AdderPrepro prepro(a[i], b[i], p_prepro[i], g_prepro[i]);
      end
   endgenerate

   logic [15:0] p_l4;
   logic [15:0] g_l4;
   AdderPrefixL4 prefix({p_prepro, 1'b0}, {g_prepro, 1'b0}, p_l4, g_l4);

   generate
      for (i = 0; i <= 15; i = i + 1) begin: loop_sum1
	 AdderSum1 sum1(a[i], b[i], g_l4[i], s[i]);
      end
   endgenerate
   
endmodule // PrefixAdder16
   
/**
 * プリフィックス演算4段目
 */
module AdderPrefixL4(input logic [15:0] p_in, g_in,
		    output logic [15:0] p_out, g_out);

   // 3段目の結果
   logic [15:0] p_l3;
   logic [15:0] g_l3;
   
   AdderPrefixL3 prefixL3_0(p_in[7:0], g_in[7:0], p_l3[7:0], g_l3[7:0]);
   AdderPrefixL3 prefixL3_1(p_in[15:8], g_in[15:8], p_l3[15:8], g_l3[15:8]);
   assign p_out[7:0] = p_l3[7:0];
   assign g_out[7:0] = g_l3[7:0];
   
   AdderPrefix prefix8({p_l3[8], p_l3[7]}, {g_l3[8], g_l3[7]}, p_out[8], g_out[8]);
   AdderPrefix prefix9({p_l3[9], p_l3[7]}, {g_l3[9], g_l3[7]}, p_out[9], g_out[9]);
   AdderPrefix prefix10({p_l3[10], p_l3[7]}, {g_l3[10], g_l3[7]}, p_out[10], g_out[10]);
   AdderPrefix prefix11({p_l3[11], p_l3[7]}, {g_l3[11], g_l3[7]}, p_out[11], g_out[11]);
   AdderPrefix prefix12({p_l3[12], p_l3[7]}, {g_l3[12], g_l3[7]}, p_out[12], g_out[12]);
   AdderPrefix prefix13({p_l3[13], p_l3[7]}, {g_l3[13], g_l3[7]}, p_out[13], g_out[13]);
   AdderPrefix prefix14({p_l3[14], p_l3[7]}, {g_l3[14], g_l3[7]}, p_out[14], g_out[14]);
   AdderPrefix prefix15({p_l3[15], p_l3[7]}, {g_l3[15], g_l3[7]}, p_out[15], g_out[15]);
   
endmodule // AdderPrefixL3
   
/**
 * プリフィックス演算3段目
 */
module AdderPrefixL3(input logic [7:0] p_in, g_in,
		    output logic [7:0] p_out, g_out);

   // 2段目の結果
   logic [7:0] p_l2;
   logic [7:0] g_l2;
   
   AdderPrefixL2 prefixL2_0(p_in[3:0], g_in[3:0], p_l2[3:0], g_l2[3:0]);
   AdderPrefixL2 prefixL2_1(p_in[7:4], g_in[7:4], p_l2[7:4], g_l2[7:4]);
   assign p_out[3:0] = p_l2[3:0];
   assign g_out[3:0] = g_l2[3:0];
   
   AdderPrefix prefix4({p_l2[4], p_l2[3]}, {g_l2[4], g_l2[3]}, p_out[4], g_out[4]);
   AdderPrefix prefix5({p_l2[5], p_l2[3]}, {g_l2[5], g_l2[3]}, p_out[5], g_out[5]);
   AdderPrefix prefix6({p_l2[6], p_l2[3]}, {g_l2[6], g_l2[3]}, p_out[6], g_out[6]);
   AdderPrefix prefix7({p_l2[7], p_l2[3]}, {g_l2[7], g_l2[3]}, p_out[7], g_out[7]);
   
endmodule // AdderPrefixL3

/**
 * プリフィックス演算2段目
 */
module AdderPrefixL2(input logic [3:0] p_in, g_in,
		    output logic [3:0] p_out, g_out);

   // 1段目の結果
   logic [3:0] p_l1;
   logic [3:0] g_l1;
   
   AdderPrefixL1 prefixL1_0(p_in[1:0], g_in[1:0], p_l1[1:0], g_l1[1:0]);
   AdderPrefixL1 prefixL1_1(p_in[3:2], g_in[3:2], p_l1[3:2], g_l1[3:2]);
   assign p_out[1:0] = p_l1[1:0];
   assign g_out[1:0] = g_l1[1:0];

   AdderPrefix prefix2({p_l1[2], p_l1[1]}, {g_l1[2], g_l1[1]}, p_out[2], g_out[2]);
   AdderPrefix prefix3({p_l1[3], p_l1[1]}, {g_l1[3], g_l1[1]}, p_out[3], g_out[3]);
   
endmodule // AdderPrefixL2
   
/**
 * プリフィックス演算1段目
 */
module AdderPrefixL1(input logic [1:0] p_in, g_in,
		    output logic [1:0] p_out, g_out);

   assign p_out[0] = p_in[0];
   assign g_out[0] = g_in[0];
      
   AdderPrefix prefix(p_in[1:0], g_in[1:0], p_out[1], g_out[1]);
   
endmodule // AdderPrefixL1

/**
 * 合計の計算1ビット
 */
module AdderSum1(input logic a, b, g,
		output logic s);

   assign s = a ^ b ^ g;

endmodule // AdderSum
   
/**
 * プリフィックス演算器
 */
module AdderPrefix(input logic [1:0] p_in, g_in,
		   output logic p_out, g_out);

   assign p_out = p_in[1] & p_in[0];
   assign g_out = p_in[1] & g_in[0] | g_in[1];

endmodule // AdderPrefix


/**
 * 前処理部分(Pi, Giを生成)
 */
module AdderPrepro(input logic a, b,
		   output logic p, g);

   assign p = a | b;
   assign g = a & b;

endmodule // AdderPrepro
