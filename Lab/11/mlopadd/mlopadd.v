module mlopadd #(
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 2 * IN_WIDTH
)(
    input clk, rst_b,
    input [IN_WIDTH-1:0] in,
    output wire [OUT_WIDTH-1:0] out
);

// Semnale interne
wire [IN_WIDTH-1:0] upper_rgst_out;
wire [OUT_WIDTH-1:0] lower_rgst_out;
wire [OUT_WIDTH-1:0] adder_out;

// Registrul superior
rgst #(
    .WIDTH(IN_WIDTH)
) rgst_upper (
    .clk(clk),
    .rst_b(rst_b),
    .in(in),
    .out(upper_rgst_out)
);

// Adder-ul
adder #(
    .WIDTH(OUT_WIDTH)
) adder_upper (
    .a({{(OUT_WIDTH-IN_WIDTH){1'b0}}, upper_rgst_out}), // Extensie pe biți
    .b(lower_rgst_out), // Conectare la registrul acumulat
    .out(adder_out)
);

// Registrul inferior
rgst #(
    .WIDTH(OUT_WIDTH)
) rgst_lower (
    .clk(clk),
    .rst_b(rst_b),
    .in(adder_out),
    .out(lower_rgst_out)
);

// Ieșirea este conectată la registrul acumulat
assign out = lower_rgst_out;

endmodule

module rgst #(
    parameter WIDTH = 8
)(
    input clk, rst_b,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);

always @(posedge clk or negedge rst_b) begin
    if(~rst_b) begin
        out <= 0;
    end else begin
        out <= in;
    end
end

endmodule

module adder #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] a, b,
    output wire [WIDTH-1:0] out
);

assign out = a + b;

endmodule


module tb_mlopadd;

reg clk, rst_b;
reg [7:0] in;
wire [15:0] out;

mlopadd #(
    .IN_WIDTH(8),
    .OUT_WIDTH(16)
) uut (
    .clk(clk),
    .rst_b(rst_b),
    .in(in),
    .out(out)
);

localparam CLK_PERIOD = 10, CLK_CYCLES = 100;

// Clock generation
initial begin
    clk = 0;
    repeat (CLK_CYCLES*2) #(CLK_PERIOD/2) clk = ~clk;
end

// Reset generation
initial begin
    rst_b = 0;
    #50 rst_b = 1;
end

// Testbench
initial begin

    $display("IN | OUT");
    $display("----------");
    $monitor("%b | %b", in, out);

    for (integer i = 0; i <= 99; i = i + 1) begin
        #20 in = i; // Termenul curent
    end


end

endmodule