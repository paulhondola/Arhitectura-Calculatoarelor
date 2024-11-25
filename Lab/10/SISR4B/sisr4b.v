module sisr4b(
    input clk, rst_b, i,
    output wire [3:0] q
);

d_ff d0(.clk(clk), .rst_b(rst_b), .set_b(1'b1), .d(i ^ q[3]), .q(q[0]));
d_ff d1(.clk(clk), .rst_b(rst_b), .set_b(1'b1), .d(q[0] ^ q[3]), .q(q[1]));
d_ff d2(.clk(clk), .rst_b(rst_b), .set_b(1'b1), .d(q[1]), .q(q[2]));
d_ff d3(.clk(clk), .rst_b(rst_b), .set_b(1'b1), .d(q[2]), .q(q[3]));

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