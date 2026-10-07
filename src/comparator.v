module comparator #(parameter WIDTH = 8) (
    input [WIDTH-1:0] num1,     // First input number
    input [WIDTH-1:0] num2,     // Second input number
    output wire equal           // Output signal (1 if equal, 0 otherwise)
);

    // Check if num1 and num2 are equal
    assign equal = (num1 == num2) ? 1'b1 : 1'b0;

endmodule