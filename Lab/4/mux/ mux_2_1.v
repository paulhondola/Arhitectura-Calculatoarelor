module mux_2_1(
    input wire a, b, sel,
    output wire out
);
    assign out = (a & (~sel)) | (b & sel);
endmodule



module mux_tb();

reg a, b, sel;
wire out;

mux_2_1 mux_cut(
    .a(a),
    .b(b),
    .sel(sel),
    .out(out)
);

integer i = 0;

initial begin
    {a, b, sel} = 0;
    for(i = 0; i < 8; i = i + 1) begin
        {a, b, sel} = i;
        $display("a = %b, b = %b, sel = %b, out = %b", a, b, sel, out);
    end
end

endmodule