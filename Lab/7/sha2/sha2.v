module top_module (
    input wire clk, st_pkt, clr,
    input wire [63:0] pkt,
    input wire pad_pkt, zero_pkt, mgln_pkt,
    input wire [63:0] msg_len,
    output wire [511:0] blk,
    output wire [2:0] idx
);

    // Intermediate signals
    wire [63:0] pkt_mux_out;
    wire [63:0] reg_out;
    wire [7:0] load;

    // Instantiate the pktmux module
    pktmux #(
        .w(64)
    ) pktmux_inst (
        .pkt(pkt),
        .msg_len(msg_len),
        .pad_pkt(pad_pkt),
        .zero_pkt(zero_pkt),
        .mgln_pkt(mgln_pkt),
        .o(pkt_mux_out)  // Output goes to reg_in and regfl
    );

    // Instantiate the rgst (register) module to hold pktmux output

    wire rgst_load;
    assign rgst_load = ~(pad_pkt | zero_pkt | mgln_pkt) & st_pkt;
    rgst #(
        .w(64)
    ) rgst_inst (
        .clk(clk),
        .rst_b(~clr),      // Active-low reset from clr
        .ld(rgst_load),       // Load when st_pkt is active
        .clr(clr),         // Clear signal
        .d(pkt_mux_out),   // Data input from pktmux output
        .q(reg_out)        // Output goes to regfl input and feedback to pktmux
    );

    // Instantiate the cntr (counter) module to manage idx
    cntr #(
        .w(3)
    ) cntr_inst (
        .clk(clk),
        .rst_b(~clr),      // Active-low reset from clr
        .c_up(st_pkt),       // Increment when st_pkt is active
        .clr(clr),         // Clear signal
        .q(idx)            // 3-bit output idx
    );

    // Instantiate the regfl (register file) module
    regfl #(
        .w(64),
        .s_w(3)
    ) regfl_inst (
        .clk(clk),
        .ld(st_pkt),
        .we(st_pkt),         // Write enable connected to st_pkt
        .s(idx),             // Selection index from cntr
        .d(pkt_mux_out),         // Data input from reg_out
        .q(blk)              // 512-bit output
    );

endmodule

module regfl #(
    parameter w = 64,
    parameter s_w = 3
)(
    input wire clk, ld, we,
    input wire [s_w-1:0] s,
    input wire [w-1:0] d,
    output reg [8*w-1:0] q
);

wire [2**s_w-1:0] load;             // Change to wire
wire [w-1:0] q_mem [2**s_w-1:0];    // Change to wire

// Instantiate the decoder
dec #(
    .w(s_w)
) dec0 (
    .s(s),
    .e(we),
    .o(load)
);

generate 
    genvar i;
    for (i = 0; i < 2**s_w; i = i + 1) begin : rgst_loop
        rgst #(
            .w(w)
        ) rgst_inst (
            .clk(clk),
            .rst_b(1'b1),
            .ld(load[i]),
            .clr(1'b0),
            .d(d),
            .q(q_mem[i])  // Connect q_mem[i] directly as wire
        );
    end
endgenerate

// Concatenate q_mem into q
always @(*) begin
    q = {q_mem[7], q_mem[6], q_mem[5], q_mem[4], q_mem[3], q_mem[2], q_mem[1], q_mem[0]};
end

endmodule

module dec #(parameter w=3)(
    input [w-1:0] s,
    input e,
    output reg [2**w-1:0] o
);
    always @ (*) begin
        o = 0;
        if (e)
            o[s] = 1;
    end
endmodule

module rgst #(
    parameter w=64
)(
    input clk, rst_b, ld, clr,
    input [w-1:0] d,
    output reg [w-1:0] q
);
    always @ (posedge clk or negedge rst_b)
        if (!rst_b)     q <= 0;
        else if (clr)   q <= 0;
        else if (ld)    q <= d;
endmodule

module cntr #(parameter w=3)(
    input clk, rst_b, c_up, clr,
    output reg [w-1:0] q
);
    always @ (posedge clk or negedge rst_b)
        if (!rst_b)         q <= 0;
        else if (clr)       q <= 0;
        else if (c_up)      q <= q + 1;
endmodule

module pktmux #(
    parameter w=64
)(
    input wire [w-1:0] pkt, msg_len,
    input wire pad_pkt, zero_pkt, mgln_pkt,
    output reg [w-1:0] o
);

reg [w-1:0] zero = 0;
reg [w-1:0] pad = ~0 << (w-1);

always @(*) begin
    if (pad_pkt) o = pad;
    else if (zero_pkt) o = zero;
    else if (mgln_pkt) o = msg_len;
    else o = pkt;
end

endmodule
