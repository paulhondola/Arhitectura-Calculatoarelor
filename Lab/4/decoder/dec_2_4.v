module dec_2_4(
    input wire enable, 
    input wire [1:0] sel,
    output reg [3:0] data
);
    always @(*) begin
        if (enable) 
            data = 4'b1111; 
        else begin       // Active low enable
            case (sel)
                2'b00: data = 4'b1110;  // Active-low, only one output goes to 0
                2'b01: data = 4'b1101;
                2'b10: data = 4'b1011;
                2'b11: data = 4'b0111;
                default: data = 4'b1111;  // Default all high (inactive)
            endcase
        end
    end
endmodule

module dec_2_4_tb;

reg enable;
reg [1:0] sel;
wire [3:0] data;

dec_2_4 dec_tb(
    .enable(enable),
    .sel(sel),
    .data(data)
);

integer i;

initial begin
    $display("en sel | data");
    $monitor("%b  %b  | %b  ", enable, sel, data);
    {enable, sel} = 0;
    for(i = 0; i < 4; i = i + 1)
        #20 sel = i;
end

endmodule