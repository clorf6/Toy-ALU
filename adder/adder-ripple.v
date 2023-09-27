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

module adder(
	input         [31:0]      a,
    input         [31:0]      b,
    output reg    [31:0]      sum,
	output reg 				  carry
);

	integer i;
	always @(*) begin 
		carry = 0;
		for (i = 0; i < 32; i = i + 1) begin
            sum[i] = a[i] ^ b[i] ^ carry;
            carry = (a[i] & b[i]) | (a[i] & carry) | (b[i] & carry);
        end
	end

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
