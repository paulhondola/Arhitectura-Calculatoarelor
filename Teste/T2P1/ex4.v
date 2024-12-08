module ex4(
    input [3:0] X, Y,
    output wire [7:0] P
);

wire [2:0] carry;
wire [3:0] out [0:2];

assign P[0] = Y[0] & X[0];

rca4 first_layer(
    .x({Y[1] & X[3], Y[1] & X[2], Y[1] & X[1], Y[1] & X[0]}),
    .y({1'b0, Y[0] & X[3], Y[0] & X[2], Y[0] & X[1]}),
    .z(out[0]),
    .c(carry[0])
);

assign P[1] = out[0][0];

rca4 second_layer(
    .x({Y[2] & X[3], Y[2] & X[2], Y[2] & X[1], Y[2] & X[0]}),
    .y({carry[0], out[0][3], out[0][2], out[0][1]}),
    .z(out[1]),
    .c(carry[1])
);

assign P[2] = out[1];

rca4 third_layer(
    .x({Y[3] & X[3], Y[3] & X[2], Y[3] & X[1], Y[3] & X[0]}),
    .y({carry[1], out[1][3], out[1][2], out[1][1]}),
    .z(out[2]),
    .c(carry[2])
);

assign P[6:3] = out[2][3:0];
assign P[7] = carry[2];

endmodule


module fac(
    input x, y, carry_in,
    output z, carry_out
);

assign {carry_out, z} = x + y + carry_in;
endmodule

module rca4(
    input [3:0] x, y,
    output wire [3:0] z,
    output wire c
);

wire [3:0] c_aux;

generate

    for(genvar i = 0; i < 4; i = i + 1) begin: gen
        if(i == 0)
            fac inst(
                .x(x[i]),
                .y(y[i]),
                .carry_in(1'b0),
                .z(z[i]),
                .carry_out(c_aux[i])
            );
        else
            fac inst(
                .x(x[i]),
                .y(y[i]),
                .carry_in(c_aux[i-1]),
                .z(z[i]),
                .carry_out(c_aux[i])
            );
    end
endgenerate

assign c = c_aux[3];

endmodule


module testbench;

reg [3:0] X, Y;
wire [7:0] P;

ex4 uut(
    .X(X),
    .Y(Y),
    .P(P)
);

initial begin

    $display("X | Y | P");
    $monitor("%d | %d | %d", X, Y, P);

    repeat(20) begin
        X = $urandom;
        Y = $urandom;
        #10;
    end
end

endmodule