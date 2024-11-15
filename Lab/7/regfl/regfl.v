module regfl(
    input wire clk,
    input wire rst_b,
    input wire write_enable,
    input wire [2:0] index,
    input wire [63:0] data_in,
    output wire [511:0] blk_out
);

wire [63:0] data [0:7];
wire [7:0] load_index;

// Decode the index from the index input
dec3to8 dec_inst(
    .in(index[2:0]),
    .enable(write_enable),
    .out(load_index)
);

// Instantiate the 8 registers
generate
genvar i;

for (i = 0; i < 8; i = i + 1) begin: reg_inst
    rgst reg_inst(
        .clk(clk),
        .clear(~rst_b),
        .load(load_index[i]),
        .data_in(data_in),
        .data_out(data[i])
    );
end

endgenerate


endmodule

module dec3to8(
    input wire [2:0] in,
    input wire enable,
    output reg [7:0] out
);

always @(*) begin
    out = 0;
    if (enable)
        out[in] = 1;
end

endmodule

module rgst(
    input wire clk,
    input wire clear,
    input wire load,
    input wire [63:0] data_in,
    output reg [63:0] data_out
);

always @(posedge clk) begin
    if (clear)
        data_out <= 64'b0;
    else if (load)
        data_out <= data_in;
end
endmodule

module regfl_tb;

// Variables
reg clk, rst_b, write_enable;
reg [2:0] index;
reg [63:0] data_in;
wire [511:0] blk_out;

// regfl instance
regfl regfl_tb(
    .clk(clk),
    .rst_b(rst_b),
    .write_enable(write_enable),
    .index(index),
    .data_in(data_in),
    .blk_out(blk_out)
);

// Testbench parameters
localparam CLK_PERIOD = 100;
localparam RST_PULSE = 25;
localparam RUNNING_CYCLES = 13;

// Clock generation block
initial begin
    clk = 0;
    repeat (RUNNING_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
end

// Reset generation block
initial begin
    rst_b = 0;
    #RST_PULSE rst_b = 1;
end

// Random number generation block
initial begin
    repeat (RUNNING_CYCLES) begin
        index = $urandom;
        data_in[63:32] = $urandom;
        data_in[31:0] = $urandom;
        #CLK_PERIOD;
    end
end

// Testbench block
initial begin
    $display("wr_en | index | data | blk");
    $monitor(" %b  |  %x  | %x  |  %x ", write_enable, index, data_in, blk_out);

    write_enable = 1;

    #(CLK_PERIOD * 6) write_enable = 0;
    #CLK_PERIOD write_enable = 1;

    #1

    $finish;

end

endmodule