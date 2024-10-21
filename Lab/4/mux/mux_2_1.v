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

    $display("a | b | sel | out");
    $monitor("%b | %b | %b | %b", a, b, sel, out);

    {a, b, sel} = 0;
    #10;
    for(i = 0; i < 8; i = i + 1) begin
        #10 {a, b, sel} = i;
    end
end

endmodule