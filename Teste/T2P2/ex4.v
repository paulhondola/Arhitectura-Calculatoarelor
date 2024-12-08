module rgst_file (
    input clk,
    rst_b,
    input [7:0] wr_data,
    input [1:0] wr_addr,
    input wr_e,
    input wire [1:0] rd_addr,
    output wire [7:0] rd_data
);

    wire [7:0] mem[3:0];
    wire [3:0] load_enable;

    dec_1_4 decoder (
        .in(wr_addr),
        .enable(wr_e),
        .out(load_enable)
    );

    mux_4_1 mux (
        .in ({mem[3], mem[2], mem[1], mem[0]}),
        .sel(rd_addr),
        .out(rd_data)
    );

    generate

        for (genvar i = 0; i < 4; i = i + 1) begin : inst

            rgst rgst_inst (
                .clk(clk),
                .rst_b(rst_b),
                .load(load_enable[i]),
                .in(wr_data),
                .out(mem[i])
            );

        end

    endgenerate

endmodule


module dec_1_4 (
    input [1:0] in,
    input enable,
    output reg [3:0] out
);

    always @(*) begin
        if (!enable) out = 4'b0000;
        else
            case (in)
                2'b00:   out = 4'b0001;
                2'b01:   out = 4'b0010;
                2'b10:   out = 4'b0100;
                2'b11:   out = 4'b1000;
                default: out = 4'b0000;
            endcase
    end

endmodule


module mux_4_1 (
    input [3:0][7:0] in,
    input [1:0] sel,
    output [7:0] out
);

    assign out = in[sel];

endmodule


module rgst (
    input clk,
    rst_b,
    load,
    input [7:0] in,
    output reg [7:0] out
);

    always @(posedge clk, negedge rst_b) begin
        if (!rst_b) out <= 8'h0;
        else if (load) out <= in;
    end
endmodule
