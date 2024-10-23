module decoder_2_4 (
    input wire[1:0] sel,
    output reg[3:0] out
);

always @(*) begin
    case (sel)
        2'd0: out = 4'd1;
        2'd1: out = 4'd2;
        2'd2: out = 4'd4;
        2'd3: out = 4'd8;
        default: out = 4'd0;
    endcase
end

endmodule

module decoder_2_4_tb;

reg[1:0] sel;
wire[3:0] out;

decoder_2_4 cut(.sel(sel), .out(out));

integer i;

initial begin
    $monitor("%b %b", sel, out);

    for(i = 0; i < 4; i++)
        #10 sel = i;
end

endmodule