module ex2 (
    input  [3:0] a,
    b,
    output [3:0] cif_z,
    cif_u
);
    wire [4:0] aux_a, aux_b, sum;
    assign aux_a = {1'b0, a};
    assign aux_b = {1'b0, b};
    assign sum   = aux_a + aux_b;
    assign cif_u = (sum[4] == 1'b0) ? sum[3:0] : sum[3:0] - 4'b1010;
    assign cif_z = {3'b0, sum[4]};

endmodule


module ex2_tb;

    reg [3:0] a, b;
    wire [3:0] cif_z, cif_u;

    ex2 uut (
        .a(a),
        .b(b),
        .cif_z(cif_z),
        .cif_u(cif_u)
    );

    initial begin
        for (integer i = 0; i < 16; i = i + 1) begin
            a = $urandom % 10;
            b = $urandom % 10;
            #10;
            $display("a = %d | b = %d | cif_z = %d | cif_u = %d", a, b, cif_z, cif_u);
        end
    end

endmodule
