module mux_4to1 #(parameter N = 8) (
    input wire [N-1:0] in0,  // First input (N-bit)
    input wire [N-1:0] in1,  // Second input (N-bit)
    input wire [N-1:0] in2,  // Third input (N-bit)
    input wire [N-1:0] in3,  // Fourth input (N-bit)
    input wire [1:0] sel,    // Select signal (2-bit)
    output wire [N-1:0] out  // Output (N-bit)
);

    // Multiplexer logic
    assign out = (sel == 2'b00) ? in0 :
                 (sel == 2'b01) ? in1 :
                 (sel == 2'b10) ? in2 :
                 (sel == 2'b11) ? in3 :
                 {N{1'b0}};  // Default case (optional)

endmodule