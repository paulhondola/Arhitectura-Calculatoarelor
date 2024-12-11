module fsmm(
    input a,
    input b,
    input clk,
    input rst_b,
    output reg m,
    output reg n
);

localparam S0_ST  =  5'b00001;
localparam S1_ST  =  5'b00010;
localparam S2_ST  =  5'b00100;
localparam S3_ST  =  5'b01000;
localparam S4_ST  =  5'b10000;

reg [4:0] state, next_state;

always @(*) begin
    {m, n} = 2'b00;
    case(state)
        S0_ST : begin
            if(~a) begin
                next_state = S0_ST;
                {m, n} = 2'b00;
            end else if(a & b) begin
                next_state = S4_ST;
                {m, n} = 2'b10;
            end else if(a & ~b) begin
                next_state = S1_ST;
                {m, n} = 2'b01;
            end
        end
        S1_ST : begin
            next_state = S2_ST;
            {m, n} = 2'b11;
        end
        S2_ST : begin 
            if(~a) begin 
                next_state = S4_ST;
                {m, n} = 2'b01;
            end else begin
                next_state = S3_ST;
                {m, n} = 2'b10;
            end
        end
        S3_ST : begin 
            if(~a & b) begin
                next_state = S3_ST;
                {m, n} = 2'b11;
            end else if(a & ~b) begin
                next_state = S0_ST;
                {m, n} = 2'b11;
            end else if(a & b) begin
                next_state = S4_ST;
                {m, n} = 2'b00;
            end
        end
        S4_ST : begin
            if(~b) begin
                next_state = S4_ST;
                {m, n} = 2'b01;
            end else begin
                next_state = S1_ST;
                {m, n} = 2'b11;
            end
        end
    endcase
end

always @(posedge clk, negedge rst_b) begin
    if(~rst_b)
        state <= S0_ST;
    else
        state <= next_state;
end


endmodule

module fsmm_tb;

reg clk, rst_b, a, b;
wire m, n;

fsmm dut(
    .a(a),
    .b(b),
    .clk(clk),
    .rst_b(rst_b),
    .m(m),
    .n(n)
);

// Clock
localparam CLK_PERIOD = 100; 
localparam CLK_CYCLES = 8;
initial begin
    clk = 0;
    repeat (2*CLK_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
end

// Reset
localparam RST_PULSE = CLK_PERIOD / 2;
initial begin
    rst_b = 0;
    #(RST_PULSE) rst_b = 1;
end

// a
initial begin
    a = 0;
    #(2 * CLK_PERIOD) a = 1;
    #(5 * CLK_PERIOD) a = 0;
end

// b
initial begin
    b = 0;
    #(CLK_PERIOD / 2) b = 1;
    #(CLK_PERIOD + CLK_PERIOD / 2) b = 0;
    #(CLK_PERIOD + CLK_PERIOD / 2) b = 1;
    #(CLK_PERIOD) b = 0;
    #(CLK_PERIOD) b = 1;
    #(2 * CLK_PERIOD) b = 0;
end

initial begin
    $display("a b | m n");
    $monitor("%b %b | %b %b", a, b, m, n);

end

endmodule