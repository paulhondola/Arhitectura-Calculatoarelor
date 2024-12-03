module ex2 #(
    parameter DIGITS = 4,
    parameter WIDTH = 4 * DIGITS
)(
    input [WIDTH-1:0] x, y,
    output wire [WIDTH-1:0] z,
    output wire carry
);

wire [DIGITS-1:0] carry_out;

// Init the first block (no carry in)
sum_1digit_BCD sum_1digit_BCD_0(
    .x(x[3:0]),
    .y(y[3:0]),
    .carry_in(1'b0),
    .z(z[3:0]),
    .carry_out(carry_out[0])
);

// Init the rest of the blocks
generate
    genvar i;
    for (i = 1; i < DIGITS; i = i + 1) begin : genblock
        sum_1digit_BCD sum_1digit_BCD_i(
            .x(x[4*i+3 -: 4]),
            .y(y[4*i+3 -: 4]),
            .carry_in(carry_out[i-1]),
            .z(z[4*i+3 -: 4]),
            .carry_out(carry_out[i])
        );
    end
endgenerate

// Assign carry_out final la ieșirea `carry`
assign carry = carry_out[DIGITS-1];

endmodule


module sum_1digit_BCD(
    input [3:0] x, y,
    input carry_in,
    output [3:0] z,
    output carry_out
);

wire [4:0] sum; // 5 biți pentru sumă
assign sum = x + y + carry_in;
assign z = sum[3:0];       // Cele mai puțin semnificative 4 biți (BCD)
assign carry_out = sum[4]; // Carry-ul

endmodule