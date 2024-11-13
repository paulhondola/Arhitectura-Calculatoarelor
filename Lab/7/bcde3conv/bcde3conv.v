module bcde3conv #(
    parameter width = 4
)(
    input wire [4*width-1:0] bcd,
    output wire [4*width-1:0] e3
);

add4b #(
    .width(width)
) cnv[width-1:0] (
    .a(bcd),
    .b(4'd3),
    .sum(e3)
);

endmodule

module add4b #(
    parameter width = 4
)(
    input wire [width-1:0] a,
    input wire [width-1:0] b,
    output wire [width-1:0] sum
);

assign sum = a + b;

endmodule

module tb;

reg [15:0] bcd;
wire [15:0] e3;

bcde3conv #(
    .width(4)
) uut (
    .bcd(bcd),
    .e3(e3)
);

initial begin
  
  $display("bcd e3");
  $monitor("%b\t%b", bcd, e3);

    bcd = 16'b0000_0000_0000_0000;
    #10 bcd = 16'b0000_0000_0000_0011;
    #10 bcd = 16'b0000_0000_0011_0011;
    #10 bcd = 16'b0000_0011_0011_0011;
    #10 bcd = 16'b0011_0011_0011_0011;
    #10 bcd = 16'b0011_0011_0011_0000;
end

endmodule