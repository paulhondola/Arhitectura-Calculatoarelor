module ex3 #(
    parameter WIDTH = 4, RST_VAL = 0
)(
    input [WIDTH-1:0] data_in,
    input clk, rst_b, shift, load, shift_type,
    output reg [WIDTH-1:0] data_out
);

always @(posedge clk or negedge rst_b) begin
    if (~rst_b)
        data_out <= RST_VAL; // Reset asincron
    else if (load)
        data_out <= data_in; // Încărcare sincronă
    else if (shift) begin
        if (shift_type) // Shiftare aritmetică
            data_out <= {data_out[WIDTH-1], data_out[WIDTH-1:1]}; // MSB păstrat
        else // Shiftare logică
            data_out <= {1'b0, data_out[WIDTH-1:1]}; // MSB devine 0
    end
end

endmodule


module ex3_tb;

localparam WIDTH = 4, RST_VAL = 0;
localparam CLK_PERIOD = 10, RST_PULSE = 5, CLK_CYCLES = 20;

reg [WIDTH-1:0] data_in;
reg clk, rst_b, shift, load, shift_type;
wire [WIDTH-1:0] data_out;

ex3 #(
    .WIDTH(WIDTH),
    .RST_VAL(RST_VAL)
) uut (
    .data_in(data_in),
    .clk(clk),
    .rst_b(rst_b),
    .shift(shift),
    .load(load),
    .shift_type(shift_type),
    .data_out(data_out)
);

// CLK GENERATION
initial begin
    clk = 1'b0;
    repeat (CLK_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
end

// RESET GENERATION
initial begin
    rst_b = 1'b0;
    #(RST_PULSE) rst_b = 1'b1;
end

initial begin

    $display("data_in | shift | load | shift_type | data_out");
    $monitor("%b\t%b\t| %b\t| %b\t| %b", data_in, shift, load, shift_type, data_out);
    // Test 1
    data_in = 4'b1010;
    load = 1'b1;
    shift = 1'b0;
    shift_type = 1'b0;
    #CLK_PERIOD;

    // Test 2 -> Shiftare logică la dreapta
    data_in = 4'b1010;
    load = 1'b0;
    shift = 1'b1;
    shift_type = 1'b0;
    #CLK_PERIOD;

    // Test 3 -> Shiftare aritmetică la dreapta
    data_in = 4'b1010;
    load = 1'b1;
    shift = 1'b1;
    shift_type = 1'b1;
    #CLK_PERIOD;

    data_in = 4'b1010;
    load = 1'b0;
    shift = 1'b1;
    shift_type = 1'b1;
    #CLK_PERIOD;

end

endmodule