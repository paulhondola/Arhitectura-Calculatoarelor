module ex3 #(
    parameter WIDTH = 8
)(
    input clk, rst_b, shift, load,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg b_out
);

always @(posedge clk, negedge rst_b) begin

    if(~rst_b) begin
        data_out <= {WIDTH{1'b0}};
        b_out <= 1'bz;
    end else begin
        if(shift) begin
            b_out <= data_out[0];
            data_out <= {1'b0, data_out[WIDTH-1:1]};
        end else if(load) begin
            data_out <= data_in;
            b_out <= 1'bz;
        end
    end

end

endmodule


module ex3_tb;

localparam CLK_PERIOD = 10, CLK_CYCLES = 30, RESET_PULSE = 5;

reg clk, rst_b, shift, load;
reg [7:0] data_in;
wire [7:0] data_out;
wire b_out;

ex3 #(
    .WIDTH(8)
) uut (
    .clk(clk),
    .rst_b(rst_b),
    .shift(shift),
    .load(load),
    .data_in(data_in),
    .data_out(data_out),
    .b_out(b_out)
);

// CLK GENERATION
initial begin
    clk = 1'b0;
    repeat (CLK_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
end

// RESET GENERATION
initial begin
    rst_b = 1'b0;
    #(RESET_PULSE) rst_b = 1'b1;
end

// DATA GENERATION
initial begin
    repeat (CLK_CYCLES) #(CLK_PERIOD) data_in = $urandom;
end

initial begin
    $display("data_in  | shift | load | data_out | b_out");
    $monitor("%b |   %b   |   %b  | %b |   %b", data_in, shift, load, data_out, b_out);

    shift = 1'b0;
    load = 1'b0;
    #CLK_PERIOD;

    shift = 1'b1;
    load = 1'b0;

    #CLK_PERIOD;

    shift = 1'b0;
    load = 1'b1;

    #CLK_PERIOD;
    shift = 1'b1;
    load = 1'b0;

    #CLK_PERIOD;
    shift = 1'b0;
    load = 1'b1;

    #CLK_PERIOD;
    shift = 1'b1;
    load = 1'b0;

    #CLK_PERIOD;
    shift = 1'b0;
    load = 1'b0;

    #CLK_PERIOD;
    shift = 1'b1;
    load = 1'b1;
    end

endmodule