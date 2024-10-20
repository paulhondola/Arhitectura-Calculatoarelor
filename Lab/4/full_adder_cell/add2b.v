module add2b(
    input wire [1:0] a,
    input wire [1:0] b,
    input wire carry_in,
    output wire [1:0] sum,
    output wire carry_out
);

wire carry;

fac f1(.a(a[0]), .b(b[0]), .carry_in(carry_in), .sum(sum[0]), .carry_out(carry));
fac f2(.a(a[1]), .b(b[1]), .carry_in(carry), .sum(sum[1]), .carry_out(carry_out));

endmodule

module fac_tb;

reg [1:0] a, b;
reg carry_in;

wire [1:0] sum;
wire carry_out;

add2b add2b_cut(
    .a(a),
    .b(b),
    .carry_in(carry_in),
    .sum(sum),
    .carry_out(carry_out)
);

integer i = 0;

initial begin

    // Print header for better output readability
    $display("a, b Cin | Sum Cout");
    $monitor("%b%b  %b%b  %b |  %b%b   %b", a[1], a[0], b[1], b[0], carry_in, sum[1], sum[0], carry_out);
    
    // Start simulation
    // 2^5 = 32

    for (i = 0; i < 32; i = i + 1) begin
        {a, b, carry_in} = i;
        #10;
    end

    // Finish simulation
    $finish;

end

endmodule