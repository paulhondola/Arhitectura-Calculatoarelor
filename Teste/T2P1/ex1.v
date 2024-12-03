module ex1(
    input clk, a, b, rst_b,
    output m, n
);

reg [2:0] state, next_state;

// Codificarea starilor
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;

// Logica de stare
always @(*) begin
    case (state)
        S0: if(~a) next_state = S0;
        else if(b) next_state = S4;
        else next_state = S1;

        S1: next_state = S2;
        S2: if(a) next_state = S3;
        else next_state = S4;

        S3: if(a ^ b) next_state = S3;
        else if (a) next_state = S4;
        else next_state = S0;

        S4: if(b) next_state = S1;
        else next_state = S4;
    endcase
end

// Logica de iesire
always @(*) begin
    
end

// Automatul
always @(posedge clk) begin
    if(rst_b) state <= S0;
    else state <= next_state;
end

endmodule