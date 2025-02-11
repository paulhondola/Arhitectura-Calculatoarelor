module d_ff(
    input clk,
    input set_b,
    input d,
    output reg q
);

always @(posedge clk, negedge set_b) begin
    if(~set_b) begin
        q <= 1'b1;
    end else begin
        q <= d;
    end
end

endmodule

module lss5b(
    input clk,
    input rst_b,
    output [4:0] q
);

d_ff d0(
    .clk(clk),
    .set_b(rst_b),
    .d(q[4]),
    .q(q[0])
);

d_ff d1(
    .clk(clk),
    .set_b(rst_b),
    .d(q[0]),
    .q(q[1])
);

d_ff d2(
    .clk(clk),
    .set_b(rst_b),
    .d(q[1]),
    .q(q[2])
);

d_ff d3(
    .clk(clk),
    .set_b(rst_b),
    .d(q[4] ^ q[2]),
    .q(q[3])
);

d_ff d4(
    .clk(clk),
    .set_b(rst_b),
    .d(q[4] ^ q[3]),
    .q(q[4])
);

endmodule

module lss5b_tb;

reg clk;
reg rst_b;
wire [4:0] q;

lss5b inst(
    .clk(clk),
    .rst_b(rst_b),
    .q(q)
);

localparam CLK_PERIOD = 100;
localparam RUNNING_CYCLES = 10;

initial begin
    clk = 0;
    repeat (2 * RUNNING_CYCLES) #(CLK_PERIOD / 2) clk = ~clk;
end

localparam RST_PULSE = 25;

initial begin
    rst_b = 0;
    #RST_PULSE rst_b = 1;
end

initial begin
    $display("clk | rst_b | q");
    $monitor("%b | %b | %b", clk, rst_b, q);
end

endmodule