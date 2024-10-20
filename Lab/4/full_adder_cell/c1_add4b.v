module c1_add4b(
	input [3:0] a, b,
	input carry_in,
	output [3:0] sum
);

wire carry, eac;
wire [3:0] tmp_sum;

add2b inst0(
	.a(a[1:0]),
	.b(b[1:0]),
	.carry_in(carry_in),
	.sum(tmp_sum[1:0]),
	.carry_out(carry)
);

add2b inst1(
	.a(a[3:2]),
	.b(b[3:2]),
	.carry_in(carry),
	.sum(tmp_sum[3:2]),
	.carry_out(eac)
);

assign sum = tmp_sum + eac;

endmodule

module c1add4b_tb;

reg [3:0] a, b;
reg ci;
wire [3:0] sum;

c1_add4b cut(
	.a(a),
	.b(b),
	.carry_in(ci),
	.sum(sum)
);

integer k;
initial begin
	$display("x \t\t y \t\t ci \t\t z");
	$monitor("%b \t %b \t %b \t %b", a, b, ci, sum);
	{a, b, ci} = 0;
	for (k = 1; k < 512; k = k + 1)
		#10 {a, b, ci} = k;
end

endmodule

module fac(
    input wire a, b, carry_in,
    output wire sum, carry_out
);

    assign sum = a ^ b ^ carry_in;
    assign carry_out = (a & b) | (a & carry_in) | (b & carry_in);

endmodule

module add2b(
    input wire [1:0] a,
    input wire [1:0] b,
    input wire carry_in,
    output wire [1:0] sum,
    output wire carry_out
);

wire carry;

fac f1(.a(a[0]), .b(b[0]), .carry_in(carry_in), .sum(sum[0]), .carry_out(carry));
fac f2(.a(a[1]), .b(b[1]), .carry_in(carry), .sum(sum[1]), .carry_out(carry_out));

endmodule