/* ACM Class System (I) Fall Assignment 1 
 *
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

module pgm(
	input   [3:0] g,
	input   [3:0] p,
	output        gm,
	output        pm
);

assign gm = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
assign pm = &p;

endmodule

module add4(
	input  [3:0] a,
	input  [3:0] b,
	input        c0,
	output [3:0] sum,
	output       gm,
	output       pm
);
wire [3:0] g = a & b;
wire [3:0] p = a ^ b;
wire [3:0] c;
assign c[0] = c0;
assign c[1] = g[0] | (p[0] & c0);
assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);
assign sum = p ^ c;
pgm add4pgm(g, p, gm, pm);

endmodule


module add16(
	input  [15:0] a,
	input  [15:0] b,
	input         c0,
	output [15:0] sum,
	output        carry
);

wire [3:0] g;
wire [3:0] p;
wire [3:0] c;
assign c[0] = c0;
add4 add4_1(a[3:0], b[3:0], c0, sum[3:0], g[0], p[0]);
assign c[1] = g[0] | (p[0] & c0);
add4 add4_2(a[7:4], b[7:4], c[1], sum[7:4], g[1], p[1]);
assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
add4 add4_3(a[11:8], b[11:8], c[2], sum[11:8], g[2], p[2]);
assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);
add4 add4_4(a[15:12], b[15:12], c[3], sum[15:12], g[3], p[3]);
assign carry = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c0);

endmodule

module adder(
    input  [31:0]      a,
    input  [31:0]      b,
    output [31:0]      sum,
	output      	   carry
);
	wire c0;
	add16 add16_1(a[15:0], b[15:0], 1'b0, sum[15:0], c0);
	add16 add16_2(a[31:16], b[31:16], c0, sum[31:16], carry);
	
endmodule


module Add(
	input  [31:0]          a,
    input  [31:0]          b,
    output reg [31:0]      sum
);
	wire [31:0] res;
	wire carry;
	adder calc(a, b, res, carry);
	always @(*) begin 
		sum <= res;
	end		

endmodule