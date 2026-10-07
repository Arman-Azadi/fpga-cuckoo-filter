def fingerprint_hash(data_in: int) -> int:
    SEED = 0xBEEF
    C1 = 0x27D4

    a = (data_in & 0xFFFF) ^ SEED
    mult_out = a * C1
    high_16 = (data_in >> 16) & 0xFFFF
    temp = (mult_out & 0xFFFF) ^ high_16
    fingerprint = (temp & 0x7FFF) | 0x8000  # Set bit 15 to 1
    return fingerprint


def hash_index1(data_in: int) -> int:
    SEED1 = 0xDEADBEEF
    prime_num = 0x9E3779B1

    a = data_in ^ SEED1
    mult_out = a * prime_num
    hash_value = (mult_out >> 16) & 0xFFFFFFFF  # Simulate 32-bit register
    index1 = hash_value & 0xFFFF
    return index1


def hash_index2(index1: int, fingerprint: int) -> int:
    SEED2 = 0xA5A5A5A5
    prime_num = 0x9E3779B1

    a = fingerprint ^ SEED2
    mult_out = a * prime_num
    hash_value = (mult_out >> 16) & 0xFFFFFFFF
    index2 = index1 ^ (hash_value & 0xFFFF)
    return index2


# ✅ تست با چند مقدار نمونه
data = -32615487

fp = fingerprint_hash(data)
idx1 = hash_index1(data)
idx2 = hash_index2(idx1, fp)

print(f"input: {data}")
print(f"Fingerprint Hash: {fp}")
print(f"Hash Index 1: {idx1}")
print(f"Hash Index 2: {idx2}")
print("-" * 40)
