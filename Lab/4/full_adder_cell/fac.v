module fac(
    input wire a, b, carry_in,
    output wire sum, carry_out
);

    assign sum = a ^ b ^ carry_in;
    assign carry_out = (a & b) | (a & carry_in) | (b & carry_in);

endmodule

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

reg a, b, carry_in;
wire sum, carry_out;

fac fac_cut(
    .a(a),
    .b(b),
    .carry_in(carry_in),
    .sum(sum),
    .carry_out(carry_out)
);

integer i = 0;

initial begin
    // Print header for better output readability
        $display("A B Cin | Sum Cout");
        $monitor("%b %b  %b  |  %b   %b", a, b, carry_in, sum, carry_out);
        
        // Start simulation

        for (i = 0; i < 8; i = i + 1) begin
            {a, b, carry_in} = i;
                #10;
        end

        // Finish simulation
        $finish;
end

endmodule
