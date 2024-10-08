module main (
	input [2:0] i,
	output o
);
	//write Verilog code here

	assign o = (i == 3 | i == 7);

endmodule

module main_tb;
	reg [2:0] i;
	wire o;

	main main_i (.i(i), .o(o));

	integer k;
	initial begin
		$display("Time\ti\to");
		$monitor("%0t\t%b\t%b", $time, i, o);
		i = 0;
		for (k = 1; k < 8; k = k + 1)
			#10 i = k;
	end
endmodule