module ex2 #(
    parameter DIGITS = 4,
    parameter WIDTH  = 4 * DIGITS
) (
    input [WIDTH-1:0] x,
    y,
    output wire [WIDTH-1:0] z,
    output wire carry
);

    wire [DIGITS-1:0] carry_out;

    // Init the first block (no carry in)
    sum_1digit_BCD sum_1digit_BCD_0 (
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
            sum_1digit_BCD sum_1digit_BCD_i (
                .x(x[4*i+3-:4]),
                .y(y[4*i+3-:4]),
                .carry_in(carry_out[i-1]),
                .z(z[4*i+3-:4]),
                .carry_out(carry_out[i])
            );
        end
    endgenerate

    // Assign carry_out final la ieșirea `carry`
    assign carry = carry_out[DIGITS-1];

endmodule


module sum_1digit_BCD (
    input [3:0] x,
    y,
    input carry_in,
    output [3:0] z,
    output carry_out
);

    wire [4:0] sum;  // 5 biți pentru sumă
    wire [4:0] aux_x, aux_y;

    assign aux_x = {1'b0, x};
    assign aux_y = {1'b0, y};
    assign sum = aux_x + aux_y + carry_in;
    
    // Verificăm dacă suma este mai mare decât 9
    assign z = sum[4:0] % 10;
    assign carry_out = sum[4] | sum[3:0] > 9;

endmodule


module testbench;

    localparam DIGITS = 4;

    reg [4*DIGITS-1:0] x;
    reg [4*DIGITS-1:0] y;
    wire [4*DIGITS-1:0] z;
    wire carry;

    ex2 #(
        .DIGITS(DIGITS)
    ) ex2_0 (
        .x(x),
        .y(y),
        .z(z),
        .carry(carry)
    );

    // generate values
    initial begin
        repeat (10) begin
            x[3:0] = $urandom % 10;
            x[7:4] = $urandom % 10;
            x[11:8] = $urandom % 10;
            x[15:12] = $urandom % 10;

            y[3:0] = $urandom % 10;
            y[7:4] = $urandom % 10;
            y[11:8] = $urandom % 10;
            y[15:12] = $urandom % 10;
            #10;
        end
    end

    initial begin

        $display("X         Y         Z      Carry");
        $display("--------------------------------");
        $monitor("%h %h %h %h | %h %h %h %h | %h %h %h %h | %b", x[15:12], x[11:8], x[7:4], x[3:0], y[15:12], y[11:8], y[7:4], y[3:0], z[15:12], z[11:8], z[7:4], z[3:0], carry);
    end

endmodule
