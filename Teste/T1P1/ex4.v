module ex4(
    input clk, bit, flush,
    output reg [7:0] byte
);

reg [7:0] rgst = 0;
reg [3:0] counter = 0;

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

    // Declarații semnale
    reg clk, bit, flush;
    wire [7:0] byte;

    // Instanțierea modulului
    ex4 uut (
        .clk(clk),
        .bit(bit),
        .flush(flush),
        .byte(byte)
    );

integer i = 0;

    // Clock generator
    initial begin
        clk = 0;
        repeat(100) begin 
        #5 clk = ~clk; // Perioadă 10ns
        end
    end

    initial begin
        i = 0;
        repeat(50) #10 i = i + 1;
    end

    // Test sequence
    initial begin
        // Inițializări
        flush = 0;
        bit = 0;

        $display("\tcounter\t| byte | bit | flush");
        $monitor("%d %b %b %b", i, byte, bit, flush);

        // Test resetare prin flush
        #10 flush = 1; // Activăm flush
        #10 flush = 0; // Dezactivăm flush

        // Test citire normală de biți
        #10 bit = 1; // Primul bit
        #10 bit = 0;
        #10 bit = 1;
        #10 bit = 0;
        #10 bit = 1;
        #10 bit = 0;
        #10 bit = 1;
        #10 bit = 0; // Al 8-lea bit

    end

endmodule