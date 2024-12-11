module ex4(
    input clk, rst_b,
    output [4:0] q
);

d_ff d_ff_0(
    .clk(clk),
    .rst_b(1'b1),
    .set_b(rst_b),
    .d(q[4]),
    .q(q[0])
);

d_ff d_ff_1(
    .clk(clk),
    .rst_b(1'b1),
    .set_b(rst_b),
    .d(q[0]),
    .q(q[1])
);

d_ff d_ff_2(
    .clk(clk),
    .rst_b(1'b1),
    .set_b(rst_b),
    .d(q[1]),
    .q(q[2])
);

d_ff d_ff_3(
    .clk(clk),
    .rst_b(1'b1),
    .set_b(rst_b),
    .d(q[2] | q[4]),
    .q(q[3])
);

d_ff d_ff_4(
    .clk(clk),
    .rst_b(1'b1),
    .set_b(rst_b),
    .d(q[3] ^ q[4]),
    .q(q[4])
);

endmodule


module d_ff(
    input clk, rst_b, set_b, d,
    output reg q
);

always @(posedge clk, negedge rst_b, negedge set_b)
    if(~rst_b)
        q <= 1'b0;
    else if(~set_b)
        q <= 1'b1;
    else
        q <= d;

endmodule


module ex4_tb;

reg clk, rst_b;
wire [4:0] q;

ex4 uut(
    .clk(clk),
    .rst_b(rst_b),
    .q(q)
);

localparam CLK_PERIOD = 100, CLK_CYCLES = 20, RST_PULSE = 10;

// clock init
initial begin
    clk = 0;
    repeat (2 * CLK_CYCLES) #(CLK_PERIOD / 2) clk = ~clk;
end

// reset init
initial begin
    rst_b = 0;
    #RST_PULSE rst_b = 1;
end

initial begin
    $display(q);
    $monitor("%b", q);
end

endmodule