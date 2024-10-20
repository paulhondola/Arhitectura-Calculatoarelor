module mux_4_1(
    input wire [3:0] data, 
    input wire [1:0] sel,
    output wire out
);

wire out1, out2;

mux_2_1 i1(.a(data[0]), .b(data[1]), .sel(sel[0]), .out(out1));
mux_2_1 i2(.a(data[2]), .b(data[3]), .sel(sel[0]), .out(out2));
mux_2_1 i3(.a(out1), .b(out2), .sel(sel[1]), .out(out));

endmodule

module mux_4_1_tb();

reg [3:0] data;
reg [1:0] sel;
wire out;

mux_4_1 mux_tb(
    .data(data),
    .sel(sel),
    .out(out)
);

initial begin
    {data, sel} = 0;
    for(integer i = 0; i < 4; i = i + 1) begin
        #10 data = i;
        for(i = 0; i < 2; i = i + 1) begin
            #10 sel = i;
            $display("data = %b, sel = %b, out = %b", data, sel, out);
        end
    end
end

endmodule