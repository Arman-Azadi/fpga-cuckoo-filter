module mux_2to1 #(parameter N = 8) (
    input wire [N-1:0] in0,  // First input (N-bit)
    input wire [N-1:0] in1,  // Second input (N-bit)
    input wire sel,          // Select signal (1-bit)
    output wire [N-1:0] out  // Output (N-bit)
);

    // Multiplexer logic
    assign out = (sel) ? in1 : in0;

endmodule