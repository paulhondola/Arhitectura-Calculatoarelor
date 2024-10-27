module dec_2to4(
	input [1:0] s,
	output reg [3:0] o
);

always @(*) begin
	if (s == 2'b00)
		o = 4'b0001;
	else if (s == 2'b01)
		o = 4'b0010;
	else if (s == 2'b10)
		o = 4'b0100;
	else
		o = 4'b1000;
end

endmodule

module mux_2s #(
	parameter w = 4
)(
	input [w - 1: 0] d0, d1, d2, d3,
	input [1:0] s,
	output [w - 1: 0] o
);

wire [3:0] o_en;

dec_2to4 decoder(
	.s(s),
	.o(o_en)
);

assign o = (o_en[0]) ? d0 : {w{1'bz}};
assign o = (o_en[1]) ? d1 : {w{1'bz}};
assign o = (o_en[2]) ? d2 : {w{1'bz}};
assign o = (o_en[3]) ? d3 : {w{1'bz}};

endmodule

module mux2s_tb;
	reg [1:0] s;
	reg [3:0] d0, d1, d2, d3;
	wire [3:0] o;

	mux_2s #(
	) dut(
		.d0(d0),
		.d1(d1),
		.d2(d2),
		.d3(d3),
		.s(s),
		.o(o)
	);
	
	integer k;
	initial begin
		d0 = 4'b0101;
		d1 = 4'b1111;
		d2 = 4'b0000;
		d3 = 4'b1100;
		
		$display("Time\td0\td1\td2\td3\ts\to");
		$monitor("%0t\t%b\t%b\t%b\t%b\t%b\t%b", $time, d0, d1, d2, d3, s, o);
		s = 2'b00;
		for (k = 1; k < 4; k = k + 1)
			#10 s = k;
	end
endmodule