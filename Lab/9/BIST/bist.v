module bist(
    input clk, rst_b,
    output [3:0] sig
);

wire [4:0] q;
wire o;

lfsr5b lfsr5b_inst(.clk(clk), .rst_b(rst_b), .q(q));
check check_inst(.i(q), .o(o));
sisr4b sisr4b_inst(.clk(clk), .rst_b(rst_b), .i(o), .q(sig));

endmodule


module bist_testbench;

localparam CLK_PERIOD = 100, RST_PULSE = 25, CLK_CYCLES = 31;

reg clk, rst_b;
wire [3:0] sig;

bist bist_inst(.clk(clk), .rst_b(rst_b), .sig(sig));

// Clock generator
initial begin
    clk = 0;
    repeat (CLK_CYCLES * 2) #(CLK_PERIOD/2) clk = ~clk;
end

// Reset generator
initial begin
    rst_b = 0;
    #RST_PULSE rst_b = 1;
end

// Monitor
initial begin
    $display("Time sig[3] sig[2] sig[1] sig[0]");
    $monitor("%d %b %b %b %b", $time, sig[3], sig[2], sig[1], sig[0]);
end

endmodule



module d_ff(
    input clk, rst_b, set_b, d,
    output reg q
);

always @(posedge clk, negedge rst_b, negedge set_b) begin
    if (~rst_b)
        q <= 1'b0;
    else if (~set_b)
        q <= 1'b1;
    else
        q <= d;

end
endmodule


module lfsr5b(
    input clk, rst_b,
    output [4:0] q
);

// 5 bit LFSR -> 5 D flip flops

d_ff d0(.clk(clk), .rst_b(1'b1), .set_b(rst_b), .d(q[4]), .q(q[0]));
d_ff d1(.clk(clk), .rst_b(1'b1), .set_b(rst_b), .d(q[0]), .q(q[1]));
d_ff d2(.clk(clk), .rst_b(1'b1), .set_b(rst_b), .d(q[1] ^ q[4]), .q(q[2]));
d_ff d3(.clk(clk), .rst_b(1'b1), .set_b(rst_b), .d(q[2]), .q(q[3]));
d_ff d4(.clk(clk), .rst_b(1'b1), .set_b(rst_b), .d(q[3]), .q(q[4]));

endmodule


module check(
    input [4:0] i,
    output o
);

// o == 1 <--> i = 4*k-3 (1, 5, 9, 13, 17, 21, 25, 29)
// 5 bit -> 31 max val
// 00001 00101 01001 01101 10001 10101 11001 11101

assign o = i[1] == 0 && i[0] == 1;

endmodule


module sisr4b(
    input clk, rst_b, i,
    output wire [3:0] q
);

d_ff d0(.clk(clk), .rst_b(rst_b), .set_b(1'b1), .d(i ^ q[3]), .q(q[0]));
d_ff d1(.clk(clk), .rst_b(rst_b), .set_b(1'b1), .d(q[0] ^ q[3]), .q(q[1]));
d_ff d2(.clk(clk), .rst_b(rst_b), .set_b(1'b1), .d(q[1]), .q(q[2]));
d_ff d3(.clk(clk), .rst_b(rst_b), .set_b(1'b1), .d(q[2]), .q(q[3]));

endmodule