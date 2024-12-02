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
    parameter w=64
)(
    input clk, rst_b, ld, clr, input [w-1:0] d, output reg [w-1:0] q
);
    always @ (posedge clk, negedge rst_b)
        if (!rst_b)                 q <= 0;
        else if (clr)               q <= 0;
        else if (ld)                q <= d;
endmodule

module regfl#(
	parameter reg_w=64,
	parameter reg_cnt=8,
	parameter dec_w=3
)(
	input clk,
	input rst_b,
	input we,
	input [dec_w-1:0] s,
	input [reg_w-1:0] d,
	output [reg_cnt*reg_w-1:0] q
);

wire [reg_cnt-1:0] o;
wire [reg_w-1:0] data [reg_cnt-1:0];

dec #(
	.w(dec_w)
) dec0 (
	.s(s),
	.e(we),
	.o(o)
);

generate
genvar i;

for (i = 0; i < reg_cnt; i = i + 1) begin: reg_inst
	rgst #(.w(reg_w)) reg_inst(
		.clk(clk),
		.clr(1'b0),
		.rst_b(rst_b),
		.ld(o[i]),
		.d(d),
		.q(data[i])
	);
end

endgenerate

assign q = {data[0] , data[1] , data[2] , data[3] , data[4] , data[5] , data[6] , data[7]};

endmodule

module cntr #(parameter w=8)(
    input clk, rst_b, c_up, clr, output reg [w-1:0] q
);
    always @ (posedge clk, negedge rst_b)
        if (!rst_b)					q <= 0;
				else if (clr)				q <= 0;
        else if (c_up)				q <= q+1;
endmodule

module sumator #(
	parameter w=64
)(
	input [w-1:0] i,
	output [w-1:0] o
);
	assign o = i + 64;

endmodule

module pktmux #(
	parameter w=64
)(
	input [w-1:0] msg_len,
	input [w-1:0] pkt,
	input pad_pkt,
	input zero_pkt,
	input mgln_pkt,
	output reg [w-1:0] o
);

reg [w-1:0] zero = 0;
reg [w-1:0] padding = ~0 << (w-1);

always @(*) begin
	if (pad_pkt)
		o = padding;
	else if (zero_pkt)
		o = zero;
	else if (mgln_pkt)
		o = msg_len;
	else
		o = pkt; 
end

endmodule

module sha2indpath #(
	parameter reg_w=64,
	parameter reg_cnt=8,
	parameter dec_w=3
)(
	input clk,
	input rst_b,
	input [reg_w-1:0] pkt,	
	input st_pkt,
	input clr,
	input pad_pkt,
	input zero_pkt,
	input mgln_pkt,
	output [dec_w-1:0] idx,
	output [reg_cnt*reg_w-1:0] blk
);

wire [reg_w-1:0] msg_len_temp;
wire [reg_w-1:0] o_d;
wire [reg_w-1:0] sumator_aux;

sumator #(
	.w(reg_w)
) sumator0(
	.i(msg_len_temp),
	.o(sumator_aux)
);

rgst #(
	.w(reg_w)
) rgst0 (
	.clk(clk),
	.rst_b(rst_b),
	.clr(clr),
	.ld(st_pkt & ~(pad_pkt | zero_pkt | mgln_pkt)),
	.d(sumator_aux),
	.q(msg_len_temp)
);

pktmux #(
	.w(reg_w)
) pktmux0(
	.msg_len(msg_len_temp),
	.pkt(pkt),
	.pad_pkt(pad_pkt),
	.zero_pkt(zero_pkt),
	.mgln_pkt(mgln_pkt),
	.o(o_d)
);

cntr #(
	.w(dec_w)
) cntr0 (
	.clk(clk),
	.rst_b(rst_b),
	.c_up(st_pkt),
	.clr(clr),
	.q(idx)
);

regfl #(
	.reg_w(reg_w),
	.reg_cnt(reg_cnt),
	.dec_w(dec_w)
)regfl0(
	.clk(clk),
	.rst_b(rst_b),
	.we(st_pkt),
	.s(idx),
	.d(o_d),
	.q(blk)
);

endmodule

module sha2indpath_tb;
	reg [63:0] pkt;
	reg clk, rst_b, st_pkt, clr, pad_pkt, zero_pkt, mgln_pkt;
	wire [2:0] idx;
	wire [511:0] blk;

	sha2indpath #(
		.reg_w(64),
		.reg_cnt(8),
		.dec_w(3)
	)
	dut(
		.clk(clk),
		.rst_b(rst_b),
		.pkt(pkt),
		.st_pkt(st_pkt),
		.clr(clr),
		.pad_pkt(pad_pkt),
		.zero_pkt(zero_pkt),
		.mgln_pkt(mgln_pkt),
		.idx(idx),
		.blk(blk)
	);

	task urand64(output reg [63:0] r);
		begin
			r[63:32] = $urandom;
			r[31:0] = $urandom;
		end
	endtask

	localparam CLK_PERIOD = 100;
	localparam RUNNING_CYCLES = 13;
	initial begin
		repeat (RUNNING_CYCLES) #(CLK_PERIOD) urand64(pkt);
	end

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

		$display("st_pkt | clr | pad_pkt | zero_pkt | mgln_pkt | pkt | idx | blk");
		$display("-----------------------------------------------------------------------------");
		$monitor("%d | %d | %d | %d | %d | %h | %h | %h", st_pkt, clr, pad_pkt, zero_pkt, mgln_pkt, pkt, idx, blk);

		clr = 1'b0;
		st_pkt = 1'b1;
		pad_pkt = 1'b0;
		zero_pkt = 1'b0;
		mgln_pkt = 1'b0;
		urand64(pkt);

		#(2 * CLK_PERIOD)
		clr = 1'b1;

		#(CLK_PERIOD)
		clr = 1'b0;

		#(5 * CLK_PERIOD)
		st_pkt = 1'b0;
		
		#(CLK_PERIOD)
		st_pkt = 1'b1;
		
		#(CLK_PERIOD)
		pad_pkt = 1'b1;

		#(CLK_PERIOD)
		pad_pkt = 1'b0;
		zero_pkt = 1'b1;

		#(CLK_PERIOD)
		zero_pkt = 1'b0;
		mgln_pkt = 1'b1;

		#(CLK_PERIOD)
		mgln_pkt = 1'b0;
	end
endmodule