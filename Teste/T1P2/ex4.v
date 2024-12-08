module ex4(
    input clk,
    input [7:0] val,
    output reg [31:0] out
);

reg [7:0] prev_val = 0;

always @(posedge clk) begin
    if(val == prev_val)
        out <= out + 1;
    else
        out <= 0;

    prev_val <= val;
end

endmodule


module ex4_tb;

localparam CLK_PERIOD = 10, CLK_CYCLES = 100;

reg clk;
reg [7:0] val;
wire [31:0] out;

ex4 uut (
    .clk(clk),
    .val(val),
    .out(out)
);

// CLK GENERATION
initial begin
    clk = 1'b0;
    repeat (CLK_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
end

initial begin
    repeat (CLK_CYCLES) #(CLK_PERIOD / 8) val = $urandom;
end

initial begin
    $display("val | out");
    $monitor("%3d | %2d", val, out);
end

endmodule