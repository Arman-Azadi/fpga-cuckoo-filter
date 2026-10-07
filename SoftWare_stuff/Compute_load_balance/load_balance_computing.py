def count_valid_slots(mem_file_path):
    total_slots = 0
    valid_slots = 0

    with open(mem_file_path, 'r') as f:
        lines = f.readlines()

    # Skip the first three comment lines
    for line in lines[3:]:
        line = line.strip()
        if not line:
            continue  # Skip empty lines

        # Extract the part after the colon
        if ':' not in line:
            print(f"Invalid line format (no colon): {line}")
            continue

        try:
            hex_part = line.split(':')[1].strip()
            value = int(hex_part, 16)
        except (IndexError, ValueError):
            print(f"Invalid line in file: {line}")
            continue

        # Each 64-bit line consists of 4 x 16-bit slots
        # Check the validity bit of each slot (bit indices: 15, 31, 47, 63)
        for i in range(4):
            bit_index = (i + 1) * 16 - 1
            if (value >> bit_index) & 1:
                valid_slots += 1
            total_slots += 1

    if total_slots == 0:
        print("No slots found for analysis.")
        return 0.0

    percent = (valid_slots / total_slots) * 100
    print(f"Percentage of valid (occupied) slots: {percent:.2f}%")
    return percent


# Call the function with your file name
count_valid_slots("C:/Users/Azadi/Desktop/Python_Cuckoo/output.mem")
