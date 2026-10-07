import random

# تولید 1000 عدد تصادفی 32 بیتی
numbers = [random.randint(0, 0xFFFFFFFF) for _ in range(250000)]

# ذخیره در فایل `.mem`
with open("C:/Users/Azadi/Desktop/SoftWare_Evaluation/Data_in_Random_values/data_in_250000.mem", "w") as f:
    for num in numbers:
        f.write(f"{num:08X}\n")  # تبدیل به هگزادسیمال و ذخیره

