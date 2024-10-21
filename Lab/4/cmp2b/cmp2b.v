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


module cmp2b_tb;

reg [1:0] a, b;
wire equal, greater, less;

cmp2b cmp2b_inst(
    .a(a),
    .b(b),
    .equal(equal),
    .greater(greater),
    .less(less)
);

integer i, j;

initial begin
    
    $display("a  b   eq gr ls");
    $monitor("%b %b | %b  %b  %b", a, b, equal, greater, less);

    for (i = 0; i < 4; i = i + 1) begin
        a = i;
        for (j = 0; j < 4; j = j + 1) begin
            b = j;
            #10;
        end 
    end

    $finish;
end
endmodule
