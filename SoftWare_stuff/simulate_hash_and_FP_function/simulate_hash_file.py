def fingerprint_hash(data_in):
    SEED = 0xBEEF
    C1 = 0x27D4
    fingerprint = ((data_in & 0xFFFF) ^ SEED) * C1
    fingerprint ^= (data_in >> 16)
    fingerprint &= 0x7FFF  # Keep only the lower 15 bits
    fingerprint |= 0x8000  # Set the MSB to 1 (valid fingerprint)
    return fingerprint

def hash_index1(data_in):
    SEED1 = 0xDEADBEEF
    MASK = 0xFFFF
    prime_num = 0x9E3779B1
    hash_value = ((data_in ^ SEED1) * prime_num) >> 16
    return hash_value & MASK

def hash_index2(index1, fingerprint):
    SEED2 = 0xA5A5A5A5
    prime_num = 0x9E3779B1
    hash_value = ((fingerprint ^ SEED2) * prime_num) >> 16
    return index1 ^ (hash_value & 0xFFFF)

def simulate(data_in):
    fp = fingerprint_hash(data_in)
    idx1 = hash_index1(data_in)
    idx2 = hash_index2(idx1, fp)
    return fp, idx1, idx2

def main():
    input_file = "C:/Users/Azadi/Desktop/C_Project/data_in_100.mem"
    output_file = "C:/Users/Azadi/Desktop/SoftWare_Evaluation/simulate_hash_and_FP_function/output.txt"
    
    results = []

    with open(input_file, "r") as f:
        lines = f.readlines()
        for line_num, line in enumerate(lines):
            line = line.strip()
            if not line:
                continue
            try:
                # Supports hexadecimal with or without 0x
                data = int(line, 16)
            except ValueError:
                print(f"Line {line_num+1} is not a valid hexadecimal: {line}")
                continue
            
            fp, idx1, idx2 = simulate(data)
            results.append(
                f"Input = 0x{data:08X}, Fingerprint = 0x{fp:04X}, Index1 = {idx1}, Index2 = {idx2}"
            )
    
    with open(output_file, "w") as f:
        f.write("### Computed fingerprints and indices for input values:\n\n")
        for r in results:
            f.write(r + "\n")
    
    print(f"Done! {len(results)} inputs processed. Results saved to '{output_file}'.")

if __name__ == "__main__":
    main()
