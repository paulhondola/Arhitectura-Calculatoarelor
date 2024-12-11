module bcm(
    input i2, i1, i0,
    output wire o1, o0
);

assign o0 = (~i1 & ~i2) | (i0 & ~i1) | (~i0 & ~i2);
assign o1 = ~i1 | (~i0 & ~i2);

endmodule

module bcm_tb;

reg a, b, c;
wire x, y;

bcm uut(
    .i0(a),
    .i1(b),
    .i2(c),
    .o0(x),
    .o1(y)
);

initial begin
    $display("a b c | x y");
    $monitor("%b %b %b | %b %b", a, b, c, x, y);
    for(integer i = 0; i < 8; i = i + 1) begin
        {a, b, c} = i;
        #1;
    end
end
endmodule