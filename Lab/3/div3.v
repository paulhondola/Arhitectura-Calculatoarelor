module div3 (
  input reg [3:0] i,
  output reg [2:0] o
);
  //write Verilog code here
  always @ (*)
    casez ({i})
        4'd0 : o = 0;
        4'd1 : o = 0;
        4'd2 : o = 0;
        4'd3 : o = 1;
        4'd4 : o = 1;
        4'd5 : o = 1;
        4'd6 : o = 2;
        4'd7 : o = 2;
        4'd8 : o = 2;
        4'd9 : o = 3;
        4'd10 : o = 3;
        4'd11 : o = 3;
        4'd12 : o = 4;
        4'd13 : o = 4;
        4'd14 : o = 4;
        4'd15 : o = 5;
    endcase
endmodule

module div3_tb;
  reg [3:0] i;
  wire [2:0] o;

  div3 div3_i (.i(i), .o(o));

  integer k;
  initial begin
    $display("Time\ti\t\to");
    $monitor("%0t\t%b(%2d)\t%b(%0d)", $time, i, i, o, o);
    i = 0;
    for (k = 1; k < 16; k = k + 1)
      #10 i = k;
  end
endmodule