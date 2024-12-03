module ex2(
    input [3:0] a, b,
    output [3:0] cif_z, cif_u
);

assign cif_u = (a + b) % 10;
assign cif_z = (a + b) / 10;

endmodule


module ex2_tb;

reg [3:0] a, b;
wire [3:0] cif_z, cif_u;

ex2 uut(
    .a(a),
    .b(b),
    .cif_z(cif_z),
    .cif_u(cif_u)
);

initial begin
  for(integer i = 0; i < 16; i = i + 1) begin
    a = $urandom % 16;
    b = $urandom % 16;
    #10;
    $display("a = %d | b = %d | cif_z = %d | cif_u = %d", a, b, cif_z, cif_u);
  end
end

endmodule