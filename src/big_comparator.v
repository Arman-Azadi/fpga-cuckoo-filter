module big_comparator (
    input [15:0] num1,            // 16-bit input (num1)
    input [63:0] num2,            // 64-bit input (num2)
    output wire [3:0] equal_bits  // 4-bit output (each bit is the result of a comparator)
);

    // Instantiate four 16-bit comparators
    comparator #(16) comp0 (
        .num1(num1),
        .num2(num2[15:0]),   // First 16-bit chunk of num2
        .equal(equal_bits[0])
    );

    comparator #(16) comp1 (
        .num1(num1),
        .num2(num2[31:16]),  // Second 16-bit chunk of num2
        .equal(equal_bits[1])
    );

    comparator #(16) comp2 (
        .num1(num1),
        .num2(num2[47:32]),  // Third 16-bit chunk of num2
        .equal(equal_bits[2])
    );

    comparator #(16) comp3 (
        .num1(num1),
        .num2(num2[63:48]),  // Fourth 16-bit chunk of num2
        .equal(equal_bits[3])
    );

endmodule