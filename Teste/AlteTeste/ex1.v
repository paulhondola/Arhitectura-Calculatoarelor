module ex1(
    input a, b, c,
    output x, y
);

assign x = ~b & c | ~a & c | a & b & ~c;
assign y = ~a & ~b | ~b & ~c | a & b;

endmodule


module ex1_tb;

reg a, b, c;
wire x, y;

ex1 uut(
    .a(a),
    .b(b),
    .c(c),
    .x(x),
    .y(y)
);

initial begin
    $display("a b c | x y");
    $monitor("%b %b %b | %b %b", a, b, c, x, y);

    for(integer i = 0; i < 8; i = i + 1) begin
        {a, b, c} = i;
        #10;
    end
end
endmodule
