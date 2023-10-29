`include "../adder/adder-carry.v"

module Booth(
    input [16:0]        a,
    input [2:0]         b,
    output reg [16:0]   res
);

always @(*) begin
    case (b)
        3'b000: res <= 0;
        3'b001: res <= a;
        3'b010: res <= a;
        3'b011: res <= a << 1;
        3'b100: res <= -(a << 1);
        3'b101: res <= -a;
        3'b110: res <= -a;
        3'b111: res <= 0;
    endcase
end

endmodule

module CSA(
    input [31:0]        a,
    input [31:0]        b,
    input [31:0]        c,
    output [31:0]       sum,
    output [31:0]       carry
);

assign sum = a ^ b ^ c;
assign carry = ((a & b) ^ (a & c) ^ (b & c)) << 1;

endmodule

module Wallace(
    input  [7:0][31:0]      part,
    output [31:0]           res
);

wire [11:0][31:0] sum;
CSA csa_0(part[0], part[1], part[2], sum[0], sum[1]);
CSA csa_1(part[3], part[4], part[5], sum[2], sum[3]);
CSA csa_2(part[6], part[7], sum[0], sum[4], sum[5]);
CSA csa_3(sum[1], sum[2], sum[3], sum[6], sum[7]);
CSA csa_4(sum[4], sum[5], sum[6], sum[8], sum[9]);
CSA csa_5(sum[7], sum[8], sum[9], sum[10], sum[11]);
Add add(sum[10], sum[11], res);

endmodule

module Multi(
    input [15:0]        a,
    input [15:0]        b,
    output [31:0]       res
);

wire [7:0][16:0] B;
wire [7:0][31:0] part;
Booth booth_0({a[15], a}, {b[1:0], 1'b0}, B[0]);
Booth booth_1({a[15], a}, b[3:1], B[1]);
Booth booth_2({a[15], a}, b[5:3], B[2]);
Booth booth_3({a[15], a}, b[7:5], B[3]);
Booth booth_4({a[15], a}, b[9:7], B[4]);
Booth booth_5({a[15], a}, b[11:9], B[5]);
Booth booth_6({a[15], a}, b[13:11], B[6]);
Booth booth_7({a[15], a}, b[15:13], B[7]);
assign part[0] = {{15{B[0][16]}}, B[0]};
assign part[1] = {{13{B[1][16]}}, B[1], 2'b0};
assign part[2] = {{11{B[2][16]}}, B[2], 4'b0};
assign part[3] = {{9{B[3][16]}}, B[3], 6'b0};
assign part[4] = {{7{B[4][16]}}, B[4], 8'b0};
assign part[5] = {{5{B[5][16]}}, B[5], 10'b0};
assign part[6] = {{3{B[6][16]}}, B[6], 12'b0};
assign part[7] = {B[7][16], B[7], 14'b0};
Wallace wallace(part, res); 

endmodule

module Mul(
	input  [15:0]       a,
    input  [15:0]       b,
    output reg [31:0]   sum
);
	wire [31:0] res;
	Multi multi(a, b, res);
	always @(*) begin 
		sum <= res;
	end		

endmodule
