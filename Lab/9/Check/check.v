module check(
    input [4:0] i,
    output o
);

// o == 1 <--> i = 4*k-3 (1, 5, 9, 13, 17, 21, 25, 29)
// 5 bit -> 31 max val
// 00001 00101 01001 01101 10001 10101 11001 11101

assign o = i[1] == 0 && i[0] == 1;

endmodule