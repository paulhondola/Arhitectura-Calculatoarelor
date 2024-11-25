module prod(
    input clk, rst_b,
    output reg [7:0] data,
    output reg val
);

reg [7:0] temp_data;

task generate_rand(output [7:0] x);
    x = $urandom % 6; // Generate an 8-bit random value
endtask

always @(posedge clk, negedge rst_b) begin
    if (~rst_b) begin
        data <= 8'b0;
        val <= 1'b0;
    end else begin
        generate_rand(temp_data); // Generate a random value
        data <= temp_data; // Assign the result to 'data'
        val <= 1'b1;
    end
end

endmodule


module prod_tb;
reg clk, rst_b;
wire [7:0] data;
wire val;

prod uut(
    .clk(clk),
    .rst_b(rst_b),
    .data(data),
    .val(val)
);

// PARAMETERS
localparam CLK_PERIOD = 100, RST_PULSE = 25, CLK_COUNT = 100;
reg [7:0] counter = 0;

// CLOCK GENERATOR
initial begin
    clk = 0;
    repeat(2 * CLK_COUNT) #(CLK_PERIOD/2) clk = ~clk;
end

// RESET GENERATOR
initial begin
    rst_b = 0;
    #(RST_PULSE) rst_b = 1;
end

// COUNTER
always @(posedge clk) begin
    counter <= counter + 1;
end

// SIMULATION
initial begin

$display("COUNTER | DATA | VAL");
$monitor("%d | %h | %b", counter, data, val);

end


endmodule