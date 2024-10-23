module register_file(
    input wire clk,
    input wire reset_b,

    input wire[7:0] write_data,
    input wire[1:0] write_address,
    input wire write_enable,

    output wire[7:0] read_data,
    input wire[1:0] read_address
);

reg [3:0][7:0] data;
wire [3:0] load;

decoder_2_4 dec(.sel(write_address), .out(load));
mux_4_1 mux(.sel(read_address), .data(data), .out(read_data));

always @(posedge clk, posedge reset_b) begin

    if(!reset_b) begin
        data[0] = 8'h0;
        data[1] = 8'h0;
        data[2] = 8'h0;
        data[3] = 8'h0;
    end

    if(write_enable)
        data[load] <= write_data;
end

endmodule

module mux_4_1 (
    input wire [1:0] sel,
    input wire [3:0][7:0] data,
    output wire [7:0] out
);

assign out = data[sel];

endmodule

module decoder_2_4 (
    input wire[1:0] sel,
    output wire[3:0] out
);

assign out = 4'd1 << sel;

endmodule

module tb_register_file;

  // Testbench signals
  reg clk;
  reg reset_b;
  reg [7:0] write_data;
  reg [1:0] write_address;
  reg write_enable;
  reg [1:0] read_address;
  wire [7:0] read_data;

  // Instantiate the register file
  register_file cut (
    .clk(clk),
    .reset_b(reset_b),
    .write_data(write_data),
    .write_address(write_address),
    .write_enable(write_enable),
    .read_data(read_data),
    .read_address(read_address)
  );

  // Clock generation
  always #5 clk = ~clk; // 100 MHz clock period (10 ns)

  // Test sequence
  initial begin
    // Initialize signals
    $display("w data | w addr | w en | r data | r addr");
    $monitor("   %h  |    %h   |   %b  |   %h   |  %h", write_data, write_address, write_enable, read_data, read_address);

    clk = 0;
    reset_b = 0; // Start with reset asserted
    write_enable = 1;
    write_data = 8'hff;
    write_address = 2'b00;
    read_address = 2'b00;

    // Release reset
    #10 reset_b = 1;

    #10 read_address = 2'b00;

    #10 write_address = 2'b01;

    #10 write_data = 8'haa;

    #10 write_address = 2'b10;

    #10 read_address = 2'b01;

    #10 read_address = 2'b10;

    // Finish simulation
    $finish;
  end

endmodule