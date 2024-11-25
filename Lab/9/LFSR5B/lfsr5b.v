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

// Periodicitate de 3000 ns

module lfsr5b_testbench;

reg clk, rst_b;
wire [4:0] q;

lfsr5b cut(.clk(clk), .rst_b(rst_b), .q(q));

localparam CLK_PERIOD = 100, RST_PULSE = 25, CLK_CYCLES = 35;

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
    $display("Time q[4] q[3] q[2] q[1] q[0]");
    $monitor("%d %b %b %b %b %b", $time, q[4], q[3], q[2], q[1], q[0]);
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