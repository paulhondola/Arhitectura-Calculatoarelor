module cmp4b(
    input wire [3:0] a,
    input wire [3:0] b,
    output wire equal,
    output wire greater,
    output wire less
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

assign equal = eq[1] & eq[0];
assign greater = (eq[1] & gr[0]) | (gr[1] & eq[0]) | (gr[1] & ls[0]) | (gr[1] & gr[0]);
assign less = (eq[1] & ls[0]) | (ls[1] & eq[0]) | (ls[1] & gr[0]) | (ls[1] & ls[0]);

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
        {a, b} = i;
        #5;
    end

end

endmodule

module cmp2b(
    input wire [1:0] a,
    input wire [1:0] b,
    output reg equal,
    output reg greater,
    output reg less
);

always @(*) begin
    equal = 0; greater = 0; less = 0;
    if (a == b)
        equal = 1;
    else if (a > b)
        greater = 1;
    else
        less = 1;
end

endmodule