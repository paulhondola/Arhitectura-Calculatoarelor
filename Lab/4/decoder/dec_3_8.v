module dec_3_8(
    input wire enable, 
    input wire [2:0] sel,
    output wire [7:0] data
);

// the first part of the decoder works for the first 4 bits [7:4] data, using the sel[2] as an auxiliary enable signal, and the sel[1:0] as the selection signal

dec_2_4 dec_1(
    .enable(enable & sel[2]),
    .sel(sel[1:0]),
    .data(data[7:4])
);

// the second part of the decoder works for the last 4 bits [3:0] data, using the negated sel[2] as an auxiliary enable signal, and the sel[1:0] as the selection signal 

dec_2_4 dec_2(
    .enable(enable & ~sel[2]),
    .sel(sel[1:0]),
    .data(data[3:0])
);

endmodule