module counter #(
    parameter width = 4,
    parameter init_value = 4'hF,
    parameter count_max = 4'hA
)(
    input wire clk,
    input wire rst_b,
    input wire c_up,
    input wire clear,
    output reg[width-1:0] q
);

always @(posedge clk, negedge rst_b) begin
    if(~rst_b || clear)
        q <= init_value;
    else if (c_up)
        if(q == count_max - 1)
            q <= 0;
        else
            q <= q + 1;
end

endmodule

module tb_counter;

  // Parameters
  parameter width = 4;
  parameter init_value = 8'h0;
  parameter count_max = 4'h5;

  // Testbench signals
  reg clk;
  reg rst_b;
  reg c_up;
  reg clear;
  wire [width-1:0] q;

  // Instantiate the counter
  counter #(
    .width(width),
    .init_value(init_value),
    .count_max(count_max)
  ) cut (
    .clk(clk),
    .rst_b(rst_b),
    .c_up(c_up),
    .clear(clear),
    .q(q)
  );

  // Clock generation
  always #5 clk = ~clk; // 100 MHz clock period (10 ns)

  // Test sequence
  initial begin
    $display("c_up clr | q");
    $monitor("%b    %b | %h", c_up, clear, q);
    // Initialize signals
    clk = 0;
    rst_b = 1;
    c_up = 0;
    clear = 0;

    // Apply reset
    #10 rst_b = 0;
    #10 rst_b = 1;

    // Start counting
    #10 c_up = 1;
    #50 c_up = 0; // Stop counting

    // Apply clear signal
    #100 clear = 1; 
    #10 clear = 0;

    #10 c_up = 1;

    #1000 clear = 1;

    // Finish simulation
    #10 $finish;
  end

endmodule