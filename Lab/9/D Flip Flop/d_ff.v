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