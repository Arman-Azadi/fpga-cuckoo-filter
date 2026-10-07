def compute_index2(index1, fingerprint):
    # ثابت‌ها
    SEED2 = 0xA5A5A5A5  # Seed دوم
    PRIME_NUM = 0x9E3779B1  # عدد اول برای ضرب

    # مرحله 1: XOR بین fingerprint و SEED2 (تبدیل fingerprint به 32 بیت)
    xor_value = (fingerprint & 0xFFFF) ^ SEED2

    # مرحله 2: ضرب نتیجه در عدد اول
    hash_raw = xor_value * PRIME_NUM

    # مرحله 3: شیفت 16 بیتی به راست
    hash_value = (hash_raw >> 16) & 0xFFFFFFFF

    # مرحله 4: گرفتن 16 بیت پایین و XOR با index1
    hash_low_16 = hash_value & 0xFFFF
    index2 = index1 ^ hash_low_16

    return index2


# مثال تست
fingerprint = 50716
index1 = 18377
index2 = compute_index2(index1, fingerprint)
print(f"output:  index2 for fingerprint={fingerprint} , index1={index1} ====> : {index2}")
