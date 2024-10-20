module dec_2_4(
    input wire enable, 
    input wire [1:0] sel,
    output wire [3:0] data
);
   assign data[0] = enable | sel[1] | sel[0];
   assign data[1] = enable | sel[1] | ~sel[0];
   assign data[2] = enable | ~sel[1] | sel[0];
   assign data[3] = enable | ~sel[1] | ~sel[0];

endmodule

module dec_2_4_tb;

reg enable;
reg [1:0] sel;
wire [3:0] data;

dec_2_4 dec_tb(
    .enable(enable),
    .sel(sel),
    .data(data)
);

integer i;

initial begin
    $display("enable sel[1] sel[0] | data[3] data[2] data[1] data[0]");
    $monitor("%b       %b       %b    |    %b     %b     %b      %b", enable, sel[1], sel[0], data[3], data[2], data[1], data[0]);
    {enable, sel} = 0;
    for(i = 0; i < 4; i = i + 1)
        #20 sel = i;
end

endmodule