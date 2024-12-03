module ex3 #(
    parameter WIDTH = 8
)(
    input clk, rst_b, shift, load,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg b_out
);

always @(posedge clk, negedge rst_b) begin

    if(~rst_b) begin
        data_out <= {WIDTH{1'b0}};
        b_out <= 1'bz;
    end else begin
        if(shift) begin
            b_out <= data_out[0];
            data_out <= {1'b0, data_out[WIDTH-1:1]};
        end else if(load) begin
            data_out <= data_in;
            b_out <= 1'bz;
        end
    end

end

endmodule