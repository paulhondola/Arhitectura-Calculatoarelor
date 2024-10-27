module counter #(
	parameter w = 8,
	parameter iv = {w{1'b1}}
)(
	input clk,
	input rst_b, // asynchronous
	input c_up,
	input clr, // higher priority than c_up
	output reg [w - 1 : 0] q
);

always @(posedge clk, negedge rst_b) begin
	if (!rst_b)
		q <= iv;
	else if (clr)
		q <= iv;
	else if (c_up)
		q <= q + 1;
end

endmodule

`timescale 1ns / 1ps;

module counter_tb;
	reg clk, rst_b, c_up, clr;
	wire [7:0] q;
	
	counter #(
		.iv(8'b0)
	) cut (
		.clk(clk),
		.rst_b(rst_b),
		.c_up(c_up),
		.clr(clr),
		.q(q)
	);

	localparam CLK_PERIOD = 100;
	localparam RUNNING_CYCLES = 7;
	initial begin
		clk = 1'b0;
		repeat (2 * RUNNING_CYCLES) #(CLK_PERIOD / 2) clk = ~clk;
	end

	localparam RST_DURATION = 5;
	initial begin
		rst_b = 1'b0;
		#RST_DURATION rst_b = 1'b1;
	end

	initial begin
		$display("Time\tclk\trst_b\tc_up\tclr\tq");
		$monitor("%0t\t%b\t%b\t%b\t%b\t%0d", $time, clk, rst_b, c_up, clr, q);
		clr = 1'b0;
		c_up = 1'b1;
		#200
		clr = 1'b1;
		#100
		clr = 1'b0;
		#100
		c_up = 1'b0;
		#100
		c_up = 1'b1;
	end
endmodule