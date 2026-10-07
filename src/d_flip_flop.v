module d_flip_flop (
    input clk,      // کلاک
    input reset,    // ریست سنکرون
    input load,     // لود سیگنال
    input d,        // ورودی D
    output reg q    // خروجی Q
);

    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;       // ریست: خروجی صفر میشه
        else if (load)
            q <= d;          // اگر load فعال باشه، d ثبت میشه
        else
            q <= q;          // در غیر اینصورت مقدار قبلی حفظ میشه (میتونی حتی این خط رو ننویسی چون implicit هست)
    end

endmodule
