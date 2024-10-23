// decoder + tristate driver implementation
module mux_4_1 #(
    parameter width = 8 // default width
)(
    input wire [1:0] sel,               // Selector signal
    input wire [3:0][width-1:0] data,   // Data inputs
    output wire [width-1:0] out         // Output
);

    wire [3:0] enable;
    
    // Decoder to enable one driver based on 'sel'
    decoder_2_4 dec(
        .sel(sel), 
        .out(enable)
    );

    // Tri-state drivers: only one data line drives the output at a time
    assign out = enable[0] ? data[0] : 
                 enable[1] ? data[1] : 
                 enable[2] ? data[2] : 
                 enable[3] ? data[3] : 
                 {width{1'bz}};  // High-impedance if no valid selection

endmodule

module tb_mux_4_1;

    // Parameters for data width
    parameter width = 8;

    // Testbench signals
    reg [1:0] sel;                      // Selector signal
    reg [3:0][width-1:0] data;           // Data inputs
    wire [width-1:0] out;                // Mux output

    // Instantiate the mux_4_1 module
    mux_4_1 #(width) uut (
        .sel(sel),
        .data(data),
        .out(out)
    );

    // Testbench logic
    initial begin
        // Monitor output to see the changes
        $monitor("Time = %0t | sel = %b | data[0] = %h | data[1] = %h | data[2] = %h | data[3] = %h | out = %h",
                 $time, sel, data[0], data[1], data[2], data[3], out);

        // Initialize inputs
        sel = 2'b00;
        data[0] = 8'hAA; // Data input 0 = 0xAA
        data[1] = 8'hBB; // Data input 1 = 0xBB
        data[2] = 8'hCC; // Data input 2 = 0xCC
        data[3] = 8'hDD; // Data input 3 = 0xDD

        // Apply test cases
        #10 sel = 2'b00; // Expect data[0] = 0xAA
        #10 sel = 2'b01; // Expect data[1] = 0xBB
        #10 sel = 2'b10; // Expect data[2] = 0xCC
        #10 sel = 2'b11; // Expect data[3] = 0xDD

        // Change data values
        #10 data[0] = 8'h11;
        #10 sel = 2'b00; // Expect data[0] = 0x11

        #10 data[3] = 8'h44;
        #10 sel = 2'b11; // Expect data[3] = 0x44

        // Finish simulation
        #10 $finish;
    end
endmodule

module decoder_2_4 (
    input wire[1:0] sel,
    output reg[3:0] out
);

always @(*) begin
    case (sel)
        2'd0: out = 4'd1;
        2'd1: out = 4'd2;
        2'd2: out = 4'd4;
        2'd3: out = 4'd8;
        default: out = 4'd0;
    endcase
end

endmodule