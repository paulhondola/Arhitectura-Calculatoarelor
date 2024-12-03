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
    assign out = enable[0] ? d0 : {width{1'bz}};
    assign out = enable[1] ? d1 : {width{1'bz}};
    assign out = enable[2] ? d2 : {width{1'bz}};
    assign out = enable[3] ? d3 : {width{1'bz}};

endmodule

module mux_4_1_tb;
	reg [1:0] s;
	reg [3:0] d0, d1, d2, d3;
	wire [3:0] o;

	mux_4_1 #(.width(4)
    ) dut(
        .sel(s),
		.d0(d0),
		.d1(d1),
		.d2(d2),
		.d3(d3),
		.out(o)
	);
	
	integer k;
	initial begin
		$display("Time d3   d2   d1   d0   s   o");
		$monitor("%0t\t%b %b %b %b %b\t%b", $time, d3, d2, d1, d0, s, o);
		for (k = 0; k < 4; k = k + 1) begin
            s = k;
            {d3, d2, d1, d0} = $urandom;
            #10;
        end
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