module ex3(
    input clk, rst_b, A6, X3, I3,
    output reg out
);

localparam S0 = 4'b0001, S1 = 4'b0010, S2 = 4'b0100, S3 = 4'b1000;

reg [3:0] state, next_state;

// Next state logic
always @(*) begin
    case (state)
        S0: if((A6 & X3 & I3) | X3) next_state = S0;
            else if ((I3 & A6) | (I3 & X3)) next_state = S1;
            else if ((I3 & X3) | (A6 & X3 & I3)) next_state = S2;
            else if (X3) next_state = S3;
        S1: if(A6 & I3) next_state = S2;
            else next_state = S0;
        S2: if ((I3 & A6) | X3) next_state = S2;
        S3: if ((X3 & A6) | (A6 & I3)) next_state = S2;
    endcase
end

// Output logic
always @(*) begin
    case (state)
        S0: out = 1'b1;
        S1: out = 1'b0;
        S2: out = 1'b0;
        S3: out = 1'b0;
    endcase
end

// State machine
always @(posedge clk, negedge rst_b) begin
    if (~rst_b)
        state <= S0;
    else
        state <= next_state;
end

endmodule

module ex3_tb;
    reg clk;
    reg rst_b;
    reg A6, X3, I3;
    wire out;

    ex3 uut (
        .clk(clk),
        .rst_b(rst_b),
        .A6(A6),
        .X3(X3),
        .I3(I3),
        .out(out)
    );

    // parameters
    localparam CLK_PERIOD = 100;
    localparam CLK_CYCLES = 10;
    localparam RST_PULSE = 100;

    // clock init
    initial begin
        clk = 0;
        repeat (2 * CLK_CYCLES) # (CLK_PERIOD / 2) clk = ~clk;
    end

    // reset init
    initial begin
        rst_b = 0;
        #RST_PULSE rst_b = 1;
    end

    // A6 init
    initial begin
        A6 = 0;
        #(CLK_PERIOD) A6 = 1;
        #(CLK_PERIOD) A6 = 0;
        #(2 * CLK_PERIOD) A6 = 1;
        #(5 * CLK_PERIOD) A6 = 0;
    end

    // X3 init
    initial begin
        X3 = 1;
        #(CLK_PERIOD) X3 = 0;
        #(CLK_PERIOD + CLK_PERIOD / 2) X3 = 1;
        #(CLK_PERIOD + CLK_PERIOD / 2) X3 = 0;
        #(CLK_PERIOD + CLK_PERIOD / 2) X3 = 1;
        #(CLK_PERIOD) X3 = 0;
        #(CLK_PERIOD) X3 = 1;
        #(2 * CLK_PERIOD) X3 = 0;
        #(CLK_PERIOD / 2) X3 = 1;
    end

    // I3 init
    initial begin
        I3 = 1;
        #(CLK_PERIOD / 2) I3 = 0;
        #(CLK_PERIOD) I3 = 1;
        #(CLK_PERIOD) I3 = 0;
        #(CLK_PERIOD) I3 = 1;
        #(CLK_PERIOD) I3 = 0;
        #(CLK_PERIOD) I3 = 1;
        #(CLK_PERIOD / 2) I3 = 0;
        #(CLK_PERIOD + CLK_PERIOD / 2) I3 = 1;
        #(CLK_PERIOD + CLK_PERIOD / 2) I3 = 0;
        #(CLK_PERIOD / 2) I3 = 1;
        #(CLK_PERIOD / 2) I3 = 0;
    end

    initial begin
        $display("A6 | X3 | I3 | out");
        $monitor("%b  | %b  | %b  | %b", A6, X3, I3, out);
    end
endmodule