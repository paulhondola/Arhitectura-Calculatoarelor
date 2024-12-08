module ex4(
    input clk, bit, flush,
    output reg [7:0] byte
);

reg [7:0] rgst;
reg [3:0] counter;
initial begin
    rgst = 8'b0;
    counter = 4'b0;
    byte = 8'b0;
end

always @(posedge clk) begin
    if (flush) begin
        // Resetăm bufferul și contorul
        rgst <= 0;
        counter <= 0;
    end else begin
        // Adăugăm bitul nou în buffer
        rgst <= {rgst[6:0], bit};
        counter <= counter + 1;

        // Dacă s-au citit 8 biți, actualizăm byte
        if (counter == 8) begin
            byte <= rgst;
            counter <= 0;
        end
    end
end

endmodule


module ex4_tb;

reg clk;
reg flush;
reg bit;
wire [7:0] byte;

// Instanțierea modulului ex4
ex4 uut (
    .clk(clk),
    .flush(flush),
    .bit(bit),
    .byte(byte)
);

// Generarea semnalului de ceas
localparam CLK_PERIOD = 10;
localparam CLK_CYCLES = 30;
initial begin
    clk = 0;
    repeat (2 * CLK_CYCLES) # (CLK_PERIOD / 2) clk = ~clk;
end

initial begin
    bit = 0;
    #(CLK_PERIOD) bit = 1;
    #(CLK_PERIOD) bit = 0;
    #(2 * CLK_PERIOD) bit = 1;
    #(CLK_PERIOD) bit = 0;
    #(CLK_PERIOD) bit = 1;
    #(CLK_PERIOD) bit = 0;
    #(CLK_PERIOD) bit = 1;
    #(CLK_PERIOD) bit = 0;  
    #(CLK_PERIOD) bit = 1;
    #(CLK_PERIOD) bit = 0;
    #(2 * CLK_PERIOD) bit = 1;
    #(CLK_PERIOD) bit = 0;
    #(CLK_PERIOD) bit = 1;
    #(CLK_PERIOD) bit = 0;
    #(CLK_PERIOD) bit = 1;
    #(CLK_PERIOD) bit = 0;
    #(2 * CLK_PERIOD) bit = 1;
    #(CLK_PERIOD) bit = 0;
    #(2 * CLK_PERIOD) bit = 1;
    #(CLK_PERIOD) bit = 0;
    #(CLK_PERIOD) bit = 1;
    #(2 * CLK_PERIOD) bit = 0;
    #(2 * CLK_PERIOD) bit = 1;
end

initial begin
    flush = 0;
    #(13 * CLK_PERIOD) flush = 1;
    #(8 * CLK_PERIOD) flush = 0;
end

initial begin
    $display("Time| flush | bit_in | byte");
    $display("------------------------------------------------");
    $monitor("%3d | %b | %b | %b", $time, flush, bit, byte);
end



endmodule