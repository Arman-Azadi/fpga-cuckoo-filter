module hash_index2 (
    input clk,
    input  [15:0] index1,       // ورودی: مقدار index1
    input  [15:0] fingerprint, // ورودی: مقدار اثر انگشت 16 بیتی
    input [31:0] Fixed_Coefficient,
    output reg [15:0] index2    // خروجی: دومین ایندکس (mod 65536)
);

    // ثابت برای Seed دوم
    parameter [31:0] SEED2 = 32'hA5A5A5A5;

    reg [31:0] hash_value;

    // reg [31:0] prime_num = 32'h9E3779B1;

    wire [63:0] mult_out;

    mult_hash_6cycle_32bit mult_unit (
        .CLK(clk),
        .A((fingerprint ^ SEED2)),
        .B(Fixed_Coefficient),
        .P(mult_out)
    );

    always @(*) begin
        // محاسبه‌ی هش دوم با XOR و ضرب عدد ثابت
        hash_value = (mult_out) >> 16;
        index2 = index1 ^ hash_value[15:0]; // تولید مکان دوم با XOR
    end

endmodule