module cmp4b(
    input wire [3:0] a,
    input wire [3:0] b,
    output reg equal,
    output reg greater,
    output reg less
);

wire [1:0] eq, gr, ls;

cmp2b cmp2b_front(
    .a(a[3:2]),
    .b(b[3:2]),
    .equal(eq[1]),
    .greater(gr[1]),
    .less(ls[1])
);

cmp2b cmp2b_back(
    .a(a[1:0]),
    .b(b[1:0]),
    .equal(eq[0]),
    .greater(gr[0]),
    .less(ls[0])
);

always @(*) begin
    {equal, greater, less} = {0, 0, 0};
    if(eq[1] == eq[0])
        equal = 1;
    else if(eq[1] > eq[0])
        greater = 1;
    else
        less = 1;
end

endmodule



module cmp4b_tb;

reg [3:0] a, b;
wire equal, greater, less;

cmp4b cmp4b(
    .a(a),
    .b(b),
    .equal(equal),
    .greater(greater),
    .less(less)
);

integer i;

initial begin

    $display("a    b    eq gr ls\n");
    $monitor("%b %b %b %b %b", a, b, equal, greater, less);

    for(i = 0; i < 256; i = i + 1) begin
        a = i;
        b = i;
    end

end

endmodule