module hash_index1 (
    input clk,
    input  [31:0] data_in,  // ورودی: مقدار داده اصلی
    input [31:0] Fixed_Coefficient,
    output reg [15:0] index1     // خروجی: اولین ایندکس (mod 65536)
);

    // ثابت‌ها برای Seed و ضرب (عدد تصادفی برای هش)
    parameter [31:0] SEED1 = 32'hDEADBEEF;  
    parameter [15:0] MASK  = 16'hFFFF; // برای mod 65536

    reg [31:0] hash_value;

    // reg [31:0] prime_num = 32'h9E3779B1;

    wire [63:0] mult_out;

    mult_hash_6cycle_32bit mult_unit (
        .CLK(clk),
        .A(data_in ^ SEED1),
        .B(Fixed_Coefficient),
        .P(mult_out)
    );

    always @(*) begin
        // محاسبه‌ی هش اول با XOR و ضرب عدد ثابت (برای توزیع بهتر مقادیر)
        hash_value = (mult_out) >> 16; 
        // index1 = hash_value & MASK;  // اعمال mod بدون استفاده از تقسیم
        index1 = hash_value[15:0];
    end

endmodule