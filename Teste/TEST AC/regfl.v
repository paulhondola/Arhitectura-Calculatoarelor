module regfl #(
    parameter address_width = 3,
    parameter register_count = 2**address_width,
    parameter data_width = 64
)(
    input [address_width-1:0] address,
    input [data_width-1:0] d,
    input clk, rst_b, enable,
    output [register_count*data_width-1:0] q
);

wire [register_count-1:0] load_enable;

decoder #(.code_width(address_width), 
    .output_width(register_count)) 
dec(
    .enable(enable),
    .code(address),
    .out(load_enable)
);

generate

for(genvar i = 0; i < register_count; i = i + 1) begin: rgst_block
    rgst #(
        .width(data_width)
    ) rgst_inst(
        .clk(clk),
        .rst_b(rst_b),
        .clear(1'b0),
        .load(load_enable[i]),
        .d(d),
        .q(q[i*data_width +: data_width]) 
        // i * data_width to i * data_width + data_width - 1
    );
end

endgenerate

endmodule


module rgst #(
    parameter width = 64
)(
    input clk, rst_b, clear, load,
    input [width-1:0] d,
    output reg [width-1:0] q
);

always @(posedge clk, negedge rst_b) begin
    if(clear | ~rst_b)
        q <= {width{1'b0}};
    else if(load)
        q <= d;
end
endmodule


module decoder #(
    parameter code_width = 3,
    parameter output_width = 2**code_width
)(
    input enable,
    input [code_width-1:0] code,
    output reg [output_width-1:0] out
);

always @(*) begin
    out = {output_width{1'b0}};
    if(enable)
        out[code] = 1'b1;
end
endmodule


module decoder_tb;

reg enable;
reg [2:0] code;
wire [7:0] out;

decoder dec(
    .enable(enable),
    .code(code),
    .out(out)
);

initial begin
    $display("enable code | out");
    $monitor("%b %b | %b", enable, code, out);
    for(integer i = 0; i < 8; i = i + 1) begin
        code = i;
        enable = 1'b1;
        #1;
    end
end
endmodule
