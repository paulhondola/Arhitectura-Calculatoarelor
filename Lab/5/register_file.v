module register #(
  parameter width = 8
)(
  input wire clk,
  input wire reset_b,
  input wire load,
  input wire clear,
  input wire [width-1:0] data_in,
  output reg [width-1:0] data_out
);

always @ (posedge clk, negedge reset_b) begin
  if (!reset_b)
    data_out <= 0;
  else if (clear)
    data_out <= 0;
  else if (load)
    data_out <= data_in;
end

endmodule

module register_file(
    input wire clk,
    input wire reset_b,

    input wire[7:0] write_data,
    input wire[1:0] write_address,
    input wire write_enable,

    output wire[7:0] read_data,
    input wire[1:0] read_address
);

wire [3:0][7:0] data;
wire [3:0] clear = 4'b0000;
wire [3:0] load;

decoder_2_4_enable dec(.enable(write_enable), .sel(write_address), .out(load));

register #(
    .width(8)
) reg0(
    .clk(clk),
    .reset_b(reset_b),
    .load(load[0]),
    .clear(clear[0]),
    .data_in(write_data),
    .data_out(data[0])
);

register #(
    .width(8)
) reg1(
    .clk(clk),
    .reset_b(reset_b),
    .load(load[1]),
    .clear(clear[1]),
    .data_in(write_data),
    .data_out(data[1])
);

register #(
    .width(8)
) reg2(
    .clk(clk),
    .reset_b(reset_b),
    .load(load[2]),
    .clear(clear[2]),
    .data_in(write_data),
    .data_out(data[2])
);

register #(
    .width(8)
) reg3(
    .clk(clk),
    .reset_b(reset_b),
    .load(load[3]),
    .clear(clear[3]),
    .data_in(write_data),
    .data_out(data[3])
);

mux_4_1 #(
) mux(
    .sel(read_address),
    .data(data),
    .out(read_data)
);


endmodule

module decoder_2_4_enable(
  input wire enable,
  input wire [1:0] sel,
  output reg [3:0] out
);

always @(*)
  if (enable)
    case (sel)
      2'b00: out = 4'b0001;
      2'b01: out = 4'b0010;
      2'b10: out = 4'b0100;
      2'b11: out = 4'b1000;
    endcase
  else
    out = 4'b0000;

endmodule

module mux_4_1 (
    input wire [1:0] sel,
    input wire [3:0][7:0] data,
    output wire [7:0] out
);

assign out = data[sel];

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