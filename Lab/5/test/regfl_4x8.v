module rgst #(
  	parameter w=8
)(
    input clk, rst_b, ld, clr, input [w-1:0] d, output reg [w-1:0] q
);
    always @ (posedge clk, negedge rst_b)
        if (!rst_b)                 q <= 0;
        else if (clr)               q <= 0;
        else if (ld)                q <= d;
endmodule

module dec_2to4enable(
	input wr_e,
	input [1:0] s,
	output reg [3:0] o
);

always @(*) begin
	if (wr_e) begin
		if (s == 2'b00)
			o = 4'b0001;
		else if (s == 2'b01)
			o = 4'b0010;
		else if (s == 2'b10)
			o = 4'b0100;
		else
			o = 4'b1000;
	end
	else
			o = 4'b0000;
end

endmodule

module regfl_4x8(
	input clk,
	input rst_b, // asynchronous
	input [7:0] wr_data,
	input [1:0] wr_addr,
	input wr_e,
	output [7:0] rd_data,
	input [1:0] rd_addr
);

wire [3:0] o_ld;
wire [3:0] clr = 4'b0000;
wire [7:0] q_d0, q_d1, q_d2, q_d3;
	
dec_2to4enable decoder(
	.wr_e(wr_e),
	.s(wr_addr),
	.o(o_ld)
);

rgst #(
	) registru0 (
	.clk(clk),
	.rst_b(rst_b),
	.ld(o_ld[0]),
	.clr(clr[0]),
	.d(wr_data),
	.q(q_d0)
);	

rgst #(
	) registru1 (
	.clk(clk),
	.rst_b(rst_b),
	.ld(o_ld[1]),
	.clr(clr[1]),
	.d(wr_data),
	.q(q_d1)
);	

rgst #(
	) registru2 (
	.clk(clk),
	.rst_b(rst_b),
	.ld(o_ld[2]),
	.clr(clr[2]),
	.d(wr_data),
	.q(q_d2)
);	

rgst #(
	) registru3 (
	.clk(clk),
	.rst_b(rst_b),
	.ld(o_ld[3]),
	.clr(clr[3]),
	.d(wr_data),
	.q(q_d3)
);

mux_2s #(
	.w(8)
) mux (
	.d0(q_d0),
	.d1(q_d1),
	.d2(q_d2),
	.d3(q_d3),
	.s(rd_addr),
	.o(rd_data)
);

endmodule

module regfl4x8_tb;
	reg clk, rst_b;
	reg [7:0] wr_data;
	reg [1:0] wr_addr;
	reg wr_e;
	wire [7:0] rd_data;
	reg [1:0] rd_addr;

	regfl_4x8 dut(
		.clk(clk),
		.rst_b(rst_b),
		.wr_data(wr_data),
		.wr_addr(wr_addr),
		.wr_e(wr_e),
		.rd_data(rd_data),
		.rd_addr(rd_addr)
	);

	localparam CLK_PERIOD = 100;
	localparam RUNNING_CYCLES = 9;
	initial begin
		clk = 1'b0;
		repeat (2 * RUNNING_CYCLES) #(CLK_PERIOD / 2) clk = ~clk;
	end

	localparam RST_DURATION = 5;
	initial begin
		rst_b =  1'b0;
		#RST_DURATION rst_b = 1'b1;
	end

	initial begin
		$display("Time\tclk\trst_b\twr_e\twr_addr\t\twr_data\t\trd_addr\t\trd_data");
		$monitor("%0t\t%b\t%b\t%b\t%b\t\t%b\t\t%b\t\t%b", $time, clk, rst_b, wr_e, wr_addr, wr_data, rd_addr, rd_data);
		
		wr_addr = 2'h0;
		wr_data = 8'ha2;
		wr_e = 1'b1;
		rd_addr = 2'h3;
		
		#100

		wr_addr = 2'h2;
		wr_data = 8'h2e;
		rd_addr = 2'h0;

		#100

		wr_addr = 2'h1;
		wr_data = 8'h98;
		wr_e = 1'b0;
		rd_addr = 2'h1;

		#100

		wr_addr = 2'h3;
		wr_data = 8'h55;
		wr_e = 1'b1;
		rd_addr = 2'h2;

		#100

		wr_addr = 2'h0;
		wr_data = 8'h20;
		rd_addr = 2'h0;

		#100
		
		wr_addr = 2'h1;
		wr_data = 8'hff;
		rd_addr = 2'h3;

		#100
		
		wr_addr = 2'h3;
		wr_data = 8'hc7;
		rd_addr = 2'h1;

		#100

		wr_addr = 2'h2;
		wr_data = 8'hb5;
		wr_e = 1'b0;
		rd_addr = 2'h2;

		#100
		
		wr_addr = 2'h3;
		wr_data = 8'h91;
		wr_e = 1'b1;
		rd_addr = 2'h3;

	end
endmodule