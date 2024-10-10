module p4 (
	input [5:0] i,
	output is6
);
	//write Verilog code here
	//assign is6 = i / 10 == 6;
	assign is6 = i[5:2] == 30;
	//assign is6= i[5]&i[4]&i[3]&i[2];
endmodule

module p4_tb;
	reg [5:0] i;
	wire is6;

	p4 p4_i (.i(i), .is6(is6));

	integer k;
	initial begin
		$display("Time\ti\ti_dec\tis6");
		$monitor("%0t\t%b\t%0d\t%b", $time, i, i, is6);
		i = 0;
		for (k = 1; k < 64; k = k + 1)
			#10 i = k;
	end
endmodule
