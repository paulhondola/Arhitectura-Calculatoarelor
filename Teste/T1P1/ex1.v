module ex1 (
    input [3:0] in,
    output reg [4:0] out
);

    always @(*)
        case (in)
            4'b0000: out = 5'b11000;
            4'b0001: out = 5'b00011;
            4'b0010: out = 5'b00101;
            4'b0011: out = 5'b00110;
            4'b0100: out = 5'b01001;
            4'b0101: out = 5'b01010;
            4'b0110: out = 5'b01100;
            4'b0111: out = 5'b10001;
            4'b1000: out = 5'b10010;
            4'b1001: out = 5'b10100;
            default: out = 5'b00000;
        endcase

endmodule

module ex1_tb;

    reg  [3:0] in;
    wire [4:0] out;

    ex1 uut (
        .in (in),
        .out(out)
    );

    integer i;
    initial begin
        $display("in out");
        $monitor("%b %b", in, out);
        for (i = 0; i < 10; i = i + 1) begin
            in = i;
            #10;
        end
    end

endmodule
