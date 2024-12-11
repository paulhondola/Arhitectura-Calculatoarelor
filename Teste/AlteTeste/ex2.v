
module ex2(
    input clk, reset,
    input [7:0]write_data,
    input write_enable,
    input [1:0]write_address,
    input [1:0]read_address,
    output [7:0]read_data
);

wire [7:0] mem[3:0];
wire [3:0] load_enable;

decoder dec(
    .enable(write_enable),
    .in(write_address),
    .out(load_enable)
);

generate
    for(genvar i = 0; i < 4; i = i + 1) begin: genblock
        rgst rgst_i(
            .data(write_data),
            .clk(clk),
            .reset(reset),
            .load(load_enable[i]),
            .out(mem[i])
        );
    end
endgenerate

mux read_mux(
    .d0(mem[0]),
    .d1(mem[1]),
    .d2(mem[2]),
    .d3(mem[3]),
    .sel(read_address),
    .out(read_data)
);

endmodule


module rgst(
    input [7:0]data,
    input clk, reset, load,
    output reg [7:0]out
);

always @(posedge clk, negedge reset)
    if(reset)
        out <= 8'b00000000;
    else if(load)
        out <= data;
endmodule


module mux(
    input [7:0] d0, d1, d2, d3,
    input [1:0] sel,
    output reg [7:0] out
);

always @(*)
    case(sel)
        2'b00: out = d0;
        2'b01: out = d1;
        2'b10: out = d2;
        2'b11: out = d3;
    endcase

endmodule


module decoder(
    input enable,
    input [1:0]in,
    output reg [3:0]out
);

always @(*) begin
    out = 4'b0000;
    if(enable == 1'b1)
        out[in] = 1'b1;
end

endmodule