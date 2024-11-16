module dec #(parameter w=2)(
	input [w-1:0] s,
	input e,
	output reg [2**w-1:0] o
);
	always @ (*) begin
		o = 0;
		if (e)
  		  o[s] = 1;
	end
endmodule

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

module regfl(
	input clk,
	input rst_b,
	input we,
	input [2:0] s,
	input [63:0] d,
	output [511:0] q
);

wire [7:0] o;
wire [63:0] data [7:0];

dec #(
	.w(3)
) dec0 (
	.s(s),
	.e(we),
	.o(o)
);

generate
genvar i;

for (i = 0; i < 8; i = i + 1) begin: reg_inst
	rgst #(.w(64)) reg_inst(
		.clk(clk),
		.clr(1'b0),
		.rst_b(rst_b),
		.ld(o[3'd7 - i]),
		.d(d),
		.q(data[i])
	);
end

endgenerate

assign q = {data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]};

endmodule

module regfl_tb;

// Variables
reg clk, rst_b, write_enable;
reg [2:0] index;
reg [63:0] data_in;
wire [511:0] blk_out;

// regfl instance
regfl regfl_tb(
    .clk(clk),
    .rst_b(rst_b),
    .write_enable(write_enable),
    .index(index),
    .data_in(data_in),
    .blk_out(blk_out)
);

// Testbench parameters
localparam CLK_PERIOD = 100;
localparam RST_PULSE = 25;
localparam RUNNING_CYCLES = 13;

// Clock generation block
initial begin
    clk = 0;
    repeat (RUNNING_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
end

// Reset generation block
initial begin
    rst_b = 0;
    #RST_PULSE rst_b = 1;
end

// Random number generation block
initial begin
    repeat (RUNNING_CYCLES) begin
        index = $urandom;
        data_in[63:32] = $urandom;
        data_in[31:0] = $urandom;
        #CLK_PERIOD;
    end
end

// Testbench block
initial begin
    $display("wr_en | index | data | blk");
    $monitor(" %b  |  %x  | %x  |  %x ", write_enable, index, data_in, blk_out);

    write_enable = 1;

    #(CLK_PERIOD * 6) write_enable = 0;
    #CLK_PERIOD write_enable = 1;

    #1

    $finish;

end

endmodule