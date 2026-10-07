module fingerprint_hash (
    input clk,
    input [31:0] data_in,   // مقدار ورودی
    input [15:0] Fixed_Coefficient,
    output reg [15:0] fingerprint // مقدار خروجی 16 بیتی
);

    // مقدار ثابت برای Seed و ضریب ضرب
    parameter [15:0] SEED = 16'hBEEF; // عدد ثابت برای هش
    // parameter [15:0] C1   = 16'h27D4; // عدد ثابت برای افزایش توزیع یکنواخت

    wire [63:0] mult_out;

    mult_hash_6cycle_32bit mult_unit (
        .CLK(clk),
        .A({16'd0, data_in[15:0] ^ SEED}),
        .B({16'd0, Fixed_Coefficient}),
        .P(mult_out)
    );

    reg [15:0] temp; // رجیستر کمکی

    always @(*) begin
        temp = (mult_out) ^ (data_in >> 16);    // اول هش 16 بیتی رو حساب کن
        fingerprint = {1'b1, temp[14:0]}; // بیت با اندیس ۱۵ یا همون 16ام همیشه ۱
                                          // به این معنی که اون مقدار قرار گرفته در حافظه 
                                          // معتبر و تعلق به یک اثرانگشت است(نه اسلات خالی)
    end


endmodule
