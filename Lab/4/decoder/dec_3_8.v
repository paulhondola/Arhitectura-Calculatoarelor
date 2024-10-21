module dec_3_8(
    input wire enable, 
    input wire [2:0] sel,
    output reg [7:0] data
);

// First part of the decoder for [7:4] with sel[2] = 0
dec_2_4 dec_1(
    .enable(enable | sel[2]),   // Active when enable = 0 and sel[2] = 0
    .sel(sel[1:0]),
    .data(data[7:4])
);

// Second part of the decoder for [3:0] with sel[2] = 1
dec_2_4 dec_2(
    .enable(enable | ~sel[2]),  // Active when enable = 0 and sel[2] = 1
    .sel(sel[1:0]),
    .data(data[3:0])
);

/*
    always @(*) begin
        if(enable)
            data = 8'b11111111;
        else begin
            case (sel)
                3'b000: data = 8'b11111110;
                3'b001: data = 8'b11111101;
                3'b010: data = 8'b11111011;
                3'b011: data = 8'b11110111;
                3'b100: data = 8'b11101111;
                3'b101: data = 8'b11011111;
                3'b110: data = 8'b10111111;
                3'b111: data = 8'b01111111;
                default: data = 8'b11111111;
            endcase 
        end
    end
*/
endmodule

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


module dec_3_8_tb;

reg enable;
reg [2:0] sel;
wire [7:0] data;

integer i;
initial begin
    $display("en   sel \t data");
    $monitor("%b \t %b \t %b", enable, sel, data);
    
    enable = 0;
    sel = 3'b000;
    #50;
    
    for (i = 0; i < 8; i = i + 1)
        #50 sel = i;

end

endmodule

/*

module dec_3_8_tb;

reg enable;
reg [2:0] sel;
wire [7:0] data;

integer i;
initial begin

    $display("enable   sel \t data");
    $monitor("%b \t %b \t %b", enable, sel, data);
    {enable, sel} = 3'b000;
    for (i = 0; i < 8; i = i + 1)
        #10 sel = i;

end

endmodule

*/