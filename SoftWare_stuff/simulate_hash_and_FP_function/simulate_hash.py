def fingerprint_hash(data_in):
    SEED = 0xBEEF
    C1 = 0x27D4
    fingerprint = ((data_in & 0xFFFF) ^ SEED) * C1
    fingerprint ^= (data_in >> 16)
    fingerprint &= 0x7FFF  # اول فقط 15 بیت پایین رو نگه میداریم
    fingerprint |= 0x8000  # حالا بیت 15 رو 1 میکنیم (MSB)
    return fingerprint


def hash_index1(data_in):
    SEED1 = 0xDEADBEEF
    MASK = 0xFFFF
    prime_num = 0x9E3779B1

    hash_value = ((data_in ^ SEED1) * prime_num) >> 16
    index1 = hash_value & MASK
    return index1

def hash_index2(index1, fingerprint):
    SEED2 = 0xA5A5A5A5
    prime_num = 0x9E3779B1

    hash_value = ((fingerprint ^ SEED2) * prime_num) >> 16
    index2 = index1 ^ (hash_value & 0xFFFF)  # محدود کردن به 16 بیت
    return index2

def simulate(data_in):
    fp = fingerprint_hash(data_in)
    idx1 = hash_index1(data_in)
    idx2 = hash_index2(idx1, fp)
    return fp, idx1, idx2

# تست برنامه
data = 3919107324 # مقدار نمونه ورودی
fingerprint, index1, index2 = simulate(data)

print(f"Input: {data}")
print(f"Fingerprint Hash: {fingerprint}")
print(f"Hash Index 1: {index1}")
print(f"Hash Index 2: {index2}")

