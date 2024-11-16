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

integer a,b,c,d;

initial begin
  
  $display("bcd e3");
  $monitor("%b\t%b", bcd, e3);

    // 0 -> 9 / 0000 -> 1001
    bcd = 16'd0;
    
    for(a = 0; a < 10; a=a+1)
    for(b = 0; b < 10; b=b+1)
    for(c = 0; c < 10; c=c+1)
    for(d = 0; d < 10; d=d+1)
    begin
        bcd[15:12] = a;
        bcd[11:8] = b;
        bcd[7:4] = c;
        bcd[3:0] = d;
        #10;
    end

end

endmodule