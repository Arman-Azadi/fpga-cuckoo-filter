import random

# تعداد سطرها
num_lines = 2**16

# باز کردن فایل برای نوشتن
with open("C:/Users/Azadi/Desktop/C_Project/src/Memory_Abstraction/memory.mem", "w") as f:
    for _ in range(num_lines):
        slots = []
        for _ in range(4):
            # تولید عدد رندوم 15 بیتی
            slot = random.randint(0, 0x7FFF)
            slots.append(slot)
        
        # کنار هم چیدن چهار عدد 16 بیتی
        full_line = (slots[0] << 48) | (slots[1] << 32) | (slots[2] << 16) | slots[3]
        
        # تبدیل به رشته هگزادسیمال 16 کاراکتری
        hex_string = f"{full_line:016X}"
        
        # نوشتن در فایل
        f.write(hex_string + "\n")
