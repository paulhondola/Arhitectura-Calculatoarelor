module seq3b (
    input [3:0] i,
    output reg o
);
    //write Verilog code here
    always @ (*) begin
        o = 0;
        casez (i)
            4'b000? : o = 1;
            4'b111? : o = 1;
            4'b?000 : o = 1;
            4'b?111 : o = 1;
        endcase
	end
endmodule

module seq3b_tb;
    reg [3:0] i;
    wire o;

    seq3b seq3b_i (.i(i), .o(o));

    integer k;
    initial begin
        $display("Time\ti\t\to");
        $monitor("%0t\t%b(%2d)\t%b", $time, i, i, o);
        i = 0;
        for (k = 1; k < 16; k = k + 1)
        #10 i = k;
    end
endmodule