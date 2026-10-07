def compare_mem_files(file1_path, file2_path):
    with open(file1_path, 'r') as f1, open(file2_path, 'r') as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()

    max_lines = max(len(lines1), len(lines2))
    differences = []

    for i in range(max_lines):
        line1 = lines1[i].strip() if i < len(lines1) else "<empty line>"
        line2 = lines2[i].strip() if i < len(lines2) else "<empty line>"

        if line1 != line2:
            differences.append((i + 1, line1, line2))

    if differences:
        print("Differences found at the following lines:")
        for line_no, val1, val2 in differences:
            print(f"Line {line_no}:\n  File1: {val1}\n  File2: {val2}")
    else:
        print("The files are identical(same files).")

# Sample usage
compare_mem_files('C:/Users/Azadi/Desktop/C_Project/HW_memory.mem', 'C:/Users/Azadi/Desktop/Python_Cuckoo/output.mem')





