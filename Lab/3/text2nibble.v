module text2nibble (
    input [7:0] i,
    output reg [3:0] o
);
    always @ (*) begin
        o = 4'b1111;
        casez (i)
            4'h30 : o = 0;
            4'h31 : o = 1;
            4'h32 : o = 2;
            4'h33 : o = 3;
            4'h34 : o = 4;
            4'h35 : o = 5;
            4'h36 : o = 6;
            4'h37 : o = 7;
            4'h38 : o = 8;
            4'h39 : o = 9;
        endcase
    end
endmodule

module text2nibble_tb;
    reg [7:0] i;
    wire [3:0] o;

    text2nibble text2nibble_i (.i(i), .o(o));

    integer k;
    initial begin
        $display("Time\ti\ti_chr\to");
        $monitor("%0t\t%b\t%c\t%b(%d)", $time, i, i, o, o);
        i = 0;
        for (k = 1; k < 256; k = k + 1)
        #10 i = k;
    end
endmodule