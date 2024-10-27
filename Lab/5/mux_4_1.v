// decoder + tristate driver implementation
module mux_4_1 #(
    parameter width = 8 // default width
)(
    input wire [1:0] sel,               // Selector signal
    input wire [width-1:0] d0, d1, d2, d3,   // Data inputs
    output wire [width-1:0] out         // Output
);

    wire [3:0] enable;
    
    // Decoder to enable one driver based on 'sel'
    decoder_2_4 dec(
        .sel(sel), 
        .out(enable)
    );

    // Tri-state drivers: only one data line drives the output at a time
    assign out = enable[0] ? d0 : 
                 enable[1] ? d1 : 
                 enable[2] ? d2 : 
                 enable[3] ? d3 : 
                 {width{1'bz}};  // High-impedance if no valid selection

endmodule

module mux_4_1_tb;
	reg [1:0] s;
	reg [3:0] d0, d1, d2, d3;
	wire [3:0] o;

	mux_4_1 #(
	) cut(
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

module decoder_2_4 (
    input wire[1:0] sel,
    output reg[3:0] out
);

always @(*) begin
    case (sel)
        2'd0: out = 4'd1;
        2'd1: out = 4'd2;
        2'd2: out = 4'd4;
        2'd3: out = 4'd8;
        default: out = 4'd0;
    endcase
end

endmodule