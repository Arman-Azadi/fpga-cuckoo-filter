import time

def fingerprint_hash(data_in):
    SEED = 0xBEEF
    C1 = 0x27D4
    fingerprint = ((data_in & 0xFFFF) ^ SEED) * C1
    fingerprint ^= (data_in >> 16)
    fingerprint &= 0x7FFF  # فقط 15 بیت پایین
    fingerprint |= 0x8000  # بیت MSB = 1 (بیت 15)
    return fingerprint & 0xFFFF

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

class CuckooFilter:
    def __init__(self, num_buckets=2**16, slots_per_bucket=4, max_kicks=500):
        self.num_buckets = num_buckets
        self.slots_per_bucket = slots_per_bucket
        self.max_kicks = max_kicks
        self.buckets = [[None for _ in range(slots_per_bucket)] for _ in range(num_buckets)]

    def lookup(self, item: int) -> bool:
        fp = fingerprint_hash(item)
        i1 = hash_index1(item)
        i2 = hash_index2(i1, fp)
        return fp in self.buckets[i1] or fp in self.buckets[i2]

    def insert(self, item: int) -> bool:
        fp = fingerprint_hash(item)
        i1 = hash_index1(item)
        i2 = hash_index2(i1, fp)

        if self.lookup(item) is True:
            return False
        
        if self._insert_into_bucket(fp, i1):
            return True
        
        if self._insert_into_bucket(fp, i2):
            return True

        # Eviction بدون استفاده از random
        i = self._select_initial_index(fp, i1, i2)
        for _ in range(self.max_kicks):
            slot = self._select_slot(fp)
            fp, self.buckets[i][slot] = self.buckets[i][slot], fp
            i = hash_index2(i, fp)
            if self._insert_into_bucket(fp, i):
                return True
        return False  # اگر موفق نشد پس فیلتر پر است

    def _insert_into_bucket(self, fp: int, index: int) -> bool:
        # بررسی اینکه آیا اثر انگشت قبلاً در باکت موجود است یا نه
        for i in range(self.slots_per_bucket):
            if self.buckets[index][i] == fp:
                return False  # اگر اثر انگشت قبلاً در باکت موجود است، بازگشت False
        for i in range(self.slots_per_bucket):
            if self.buckets[index][i] is None:
                self.buckets[index][i] = fp
                return True
        return False

    def _select_initial_index(self, fp: int, i1: int, i2: int) -> int:
        bit_14 = (fp >> 14) & 1  # بیت شماره 14 (یعنی بیت پانزدهم اثر انگشت)
        return i2 if bit_14 else i1

    def _select_slot(self, fp: int) -> int:
        return fp & 0b11  # بیت 0 و 1 (عدد بین 0 تا 3)

    def delete(self, item: int) -> bool:
        fp = fingerprint_hash(item)
        i1 = hash_index1(item)
        i2 = hash_index2(i1, fp)
        for i in range(self.slots_per_bucket):
            if self.buckets[i1][i] == fp:
                self.buckets[i1][i] = None
                return True
            if self.buckets[i2][i] == fp:
                self.buckets[i2][i] = None
                return True
        return False



############################ Test ###############################

def load_input_mem(filename):
    items = []
    with open(filename, 'r') as f:
        for line in f:
            hex_str = line.strip()
            if hex_str:
                items.append(int(hex_str, 16))
    return items

def save_filter_mem(buckets, filename):
    with open(filename, 'w') as f:
        # نوشتن توضیحات ابتدایی
        f.write("// memory data file (do not edit the following line - required for mem load use)\n")
        f.write("// instance=/System_tb/system/MEMORY/U0/native_mem_module/blk_mem_gen_v8_4_3_inst/memory\n")
        f.write("// format=mti addressradix=d dataradix=h version=1.0 wordsperline=1\n")

        # نوشتن هر سطر حافظه به فرمت مورد نظر
        address = 0
        for bucket in buckets:
            # ترکیب هر اسلات 16 بیتی به یک 64 بیتی
            # اسلات‌ها به ترتیب صحیح از 0 تا 3 (از چپ به راست) ترکیب می‌شوند
            combined = 0
            for i in range(4):  # 4 اسلات
                # اگر اسلات None باشد، مقدار پیش‌فرض 0x0000 در نظر گرفته می‌شود
                value = bucket[i] if bucket[i] is not None else 0x0000
                combined |= (value & 0xFFFF) << (16 * i)  # اسلات‌ها رو با هم ترکیب می‌کنیم

            # تبدیل به هگزادسیمال 64 بیتی و نوشتن به فایل
            f.write(f"    {address}: {combined:016x}\n")  # ترکیب به صورت 64 بیتی در قالب هگزادسیمال
            address += 1


# === اجرای فیلتر ===
if __name__ == "__main__":
    
    # HW time:      1000         10/000           100/000         200/000         250/000
    #----------------------------------------------------------------------------------------
    # insert:       0.1ms        1ms              10.4ms          21.65ms         120ms
    # lookup:
    # delete:
     
    cf = CuckooFilter()

    # 1. بارگذاری داده‌ها از فایل ورودی
    input_data = load_input_mem("C:/Users/Azadi/Desktop/data_in_250000.mem")
    number_of_samples = 250000


    ################################## insert #######################################
    #  شروع زمان
    start = time.perf_counter()
    
    # 2. وارد کردن داده‌ها به فیلتر
    for item in input_data:
        cf.insert(item)
        
    # پایان زمان
    end = time.perf_counter()
    elapsed_ms = (end - start) * 1000
    
    #HW_imp = elapsed_ms / (1)
    
    print(f"Insert ==> Elapsed time: {elapsed_ms:.2f} ms")
    print(f"Insert ==> Average time per insert: {elapsed_ms * 1000 / number_of_samples:.3f} us")
    #print(f"Insert ==> HW speed(times): {HW_imp:.2f}")

    # 3. ذخیره وضعیت حافظه فیلتر به فایل خروجی
    save_filter_mem(cf.buckets, "output.mem")
    
    print("\n\n")
    ################################## lookup #######################################
    #  شروع زمان
    start2 = time.perf_counter()
    
    # 2. وارد کردن داده‌ها به فیلتر
    for item in input_data:
        cf.lookup(item)
        
    # پایان زمان
    end2 = time.perf_counter()
    elapsed_ms = (end2 - start2) * 1000
    
    #HW_imp = elapsed_ms / 
    
    print(f"Lookup ==> Elapsed time: {elapsed_ms:.2f} ms")
    print(f"Lookup ==> Average time per insert: {elapsed_ms * 1000 / number_of_samples:.3f} us")
    #print(f"Lookup ==> HW speed(times): {HW_imp:.2f}")

    
    print("\n\n")
    ################################## Delete #######################################
    #  شروع زمان
    start3 = time.perf_counter()
    
    # 2. وارد کردن داده‌ها به فیلتر
    for item in input_data:
        cf.delete(item)
        
    # پایان زمان
    end3 = time.perf_counter()
    elapsed_ms = (end3 - start3) * 1000
    
    #HW_imp = elapsed_ms / 
    
    print(f"Delete ==> Elapsed time: {elapsed_ms:.2f} ms")
    print(f"Delete ==> Average time per insert: {elapsed_ms * 1000 / number_of_samples:.3f} us")
    #print(f"Delete ==> HW speed(times): {HW_imp:.2f}")


