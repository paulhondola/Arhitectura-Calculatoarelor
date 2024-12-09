/* Proiectati un modul ce citeste bit cu bit pe front-ul crescator al semnalului de clk in maniera FIFO (primul bit primit este cel mai semnificativ bit).
Odata ce a citit 8 biti, modulul ii va inregistra in iesirea byte.
Iesirea byte va ramane pe valoarea precedenta (initial 0) cat modulul citeste biti si se va schimba doar cand modulul a citit alti 8 biti.
Intrarea flush a modulului (activa pe nivel 1) va provoca eliminarea tutoror bitilor cititi pana in momentul respectiv de modul si reluarea citirii a altor 8 biti
(iesirea byte inca isi pastreaza valoarea chiar si in cazul asta). */
module spi_rx (
    input bit, 
    input clk, 
    input flush, 
    output reg [7:0] byte
);

    reg [7:0] byte_reg; // Registru pentru a stoca temporar byte-ul
    reg [2:0] cnt;      // Contor pentru a număra până la 8 biți (3 biți sunt suficienți pentru valori între 0 și 7)

    initial begin
        byte_reg = 8'd0;
        byte = 8'd0;
        cnt = 3'd0;
    end

    always @(posedge clk) begin
        if (flush) begin
            cnt <= 3'd0;       // Resetăm contorul
            byte_reg <= 8'd0;  // Golim registrul temporar
            byte <= byte;      // Ieșirea rămâne neschimbată
        end else begin
            byte_reg <= {byte_reg[6:0], bit}; // Adăugăm bitul la registru (FIFO logic)
            cnt <= cnt + 1;

            if (cnt == 3'd7) begin
                byte <= {byte_reg[6:0], bit}; // Actualizăm ieșirea
                cnt <= 3'd0;                 // Resetăm contorul
            end
        end
    end

endmodule

module spi_rx_tb;

    reg bit, clk, flush;
    wire[7:0] act_byte;
    reg[7:0] exp_byte;
    
    wire verdict;

    spi_rx uut(.bit(bit), .clk(clk), .flush(flush), .byte(act_byte));
    integer tests_total, tests_passed, nota;

    assign verdict = exp_byte === act_byte;

    initial begin
        clk = 0;
        repeat(80) #1 clk = ~clk;
    end
    initial begin
        $display("Time\tclk\tflush\tbit\t\tactual_byte\texpected_byte\tPassed(1)/Failed(0)");
        $monitor("%4t\t%3b\t%5b\t%3b\t\t%11b\t%9b\t%18d", $time, clk, flush, bit, act_byte, exp_byte, verdict);
        tests_total = 0;
        tests_passed = 0;
        exp_byte = 8'd0;
        #1;

        bit = 1;
        flush = 0;
        exp_byte = 8'd0;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'd0;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 0;
        flush = 0;
        exp_byte = 8'd0;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 0;
        flush = 0;
        exp_byte = 8'd0;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'd0;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 0;
        flush = 0;
        exp_byte = 8'd0;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'd0;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 0;
        flush = 0;
        exp_byte = 8'b11001010;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 0;
        flush = 0;
        exp_byte = 8'b11001010;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 0;
        flush = 0;
        exp_byte = 8'b11001010;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'b11001010;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'b11001010;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'b11001010;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'b11001010;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'b11001010;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;
        
        bit = 1;
        flush = 0;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;
        
        bit = 1;
        flush = 0;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        flush = 0;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;
        
        bit = 1;
        flush = 1;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        flush = 0;
        #1;
        bit = 1;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #1;
        tests_passed = tests_passed + verdict;

        bit = 0;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;

        bit = 1;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;
        
        bit = 0;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;
        
        bit = 0;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;
        
        bit = 1;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;
        
        bit = 1;
        exp_byte = 8'b00111111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;
        
        bit = 1;
        exp_byte = 8'b10100111;
        tests_total = tests_total + 1;
        #2;
        tests_passed = tests_passed + verdict;
        
        $display("Passed / Total: %2d / %2d", tests_passed, tests_total);
        nota = tests_passed * 100 / tests_total * 25;
        $display("Nota: %1d.%03d", nota / 1000, nota % 1000);
    end
endmodule
