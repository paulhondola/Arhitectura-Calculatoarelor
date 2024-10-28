module counter #(
    parameter width = 8,
    parameter init_value = 8'hff
)(
    input wire clk,
    input wire rst_b,
    input wire c_up,
    input wire clear,
    output reg[width-1:0] q
);

always @(posedge clk, negedge rst_b) begin
    if(!rst_b)
        q <= init_value;
    else if (clear)
        q <= init_value;
    else if (c_up)
        q <= q + 1;
end

endmodule

module tb_counter;

  // Parameters
  parameter width = 8;
  parameter init_value = 8'hff;

  // Testbench signals
  reg clk;
  reg rst_b;
  reg c_up;
  reg clear;
  wire [width-1:0] q;

  // Instantiate the counter
  counter #(
    .width(width),
    .init_value(init_value)
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
    $display("clk rst c_up clr");
    $monitor("%b   %b    %b    %b | %h", clk, rst_b, c_up, clear, q);
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
    #10 clear = 1; 
    #10 clear = 0;

    // Finish simulation
    #10 $finish;
  end

endmodule