`timescale 1ns/1ps

module System_tb;
    reg Clock;
    reg Reset;
    reg [31:0] Data_in;
    reg Lookup_En;
    reg Insert_En;
    reg Delete_En;
    reg [15:0] FP_Fixed_Coefficient_Reg_input_16bit;
    reg [31:0] Hash_Index1_Fixed_Coefficient_Reg_input_32bit;
    reg [31:0] Hash_Index2_Fixed_Coefficient_Reg_input_32bit;

    reg load_FP_Fixed_Coefficient_Reg;
    reg load_Hash_Index1_Fixed_Coefficient_Reg;
    reg load_Hash_Index2_Fixed_Coefficient_Reg;

    wire Lookup_Result;
    wire Insert_Done;
    wire Delete_Done;
    wire Processing;
    wire Filter_is_Full;

    integer i;
    reg [63:0] data [0:999]; // حافظه داده
    integer mem_index;

    // تولید کلاک 1.8 ns
    always #0.9 Clock = ~Clock;

    // نمونه‌سازی ماژول اصلی
    System system (
        .Clock(Clock),
        .Reset(Reset),
        .Data_in(Data_in),
        .Lookup_En(Lookup_En),
        .Insert_En(Insert_En),
        .Delete_En(Delete_En),

        .FP_Fixed_Coefficient_Reg_input_16bit(FP_Fixed_Coefficient_Reg_input_16bit),
        .Hash_Index1_Fixed_Coefficient_Reg_input_32bit(Hash_Index1_Fixed_Coefficient_Reg_input_32bit),
        .Hash_Index2_Fixed_Coefficient_Reg_input_32bit(Hash_Index2_Fixed_Coefficient_Reg_input_32bit),

        .load_FP_Fixed_Coefficient_Reg(load_FP_Fixed_Coefficient_Reg),
        .load_Hash_Index1_Fixed_Coefficient_Reg(load_Hash_Index1_Fixed_Coefficient_Reg),
        .load_Hash_Index2_Fixed_Coefficient_Reg(load_Hash_Index2_Fixed_Coefficient_Reg),

        .Lookup_Result(Lookup_Result),
        .Insert_Done(Insert_Done),
        .Delete_Done(Delete_Done),
        .Processing(Processing),
        .Filter_is_Full(Filter_is_Full)
    );



    initial begin
        // مقداردهی اولیه
        Clock = 1;
        Reset = 1;
        Data_in = 0;
        Insert_En = 0;
        Lookup_En = 0;
        Delete_En = 0;
        mem_index = 0;

        load_FP_Fixed_Coefficient_Reg = 0;
        load_Hash_Index1_Fixed_Coefficient_Reg = 0;
        load_Hash_Index2_Fixed_Coefficient_Reg = 0;


        //******************************************** insert *************************************************///
        // بارگذاری داده‌ها از فایل
        $readmemh("C:/Users/Azadi/Desktop/C_Project/data_in_1000.mem", data);   // when the amount of data changes, the for-loop and also reg data changes too.

        #(5*1.8);
        load_FP_Fixed_Coefficient_Reg = 1;
        load_Hash_Index1_Fixed_Coefficient_Reg = 1;
        load_Hash_Index2_Fixed_Coefficient_Reg = 1;

        FP_Fixed_Coefficient_Reg_input_16bit = 16'h27D4;
        Hash_Index1_Fixed_Coefficient_Reg_input_32bit = 32'h9E3779B1;
        Hash_Index2_Fixed_Coefficient_Reg_input_32bit = 32'h9E3779B1;

        #(1.8);
        load_FP_Fixed_Coefficient_Reg = 0;
        load_Hash_Index1_Fixed_Coefficient_Reg = 0;
        load_Hash_Index2_Fixed_Coefficient_Reg = 0;

        // فعال‌سازی ریست برای 5 سیکل
        #(5*1.8);
        Reset = 0;
        #(1.8);

        // ارسال 100 داده به مدار برای درج
        // Insertion:
        for (i = 0; i < 1000; i = i + 1) begin
            // صبر تا مدار آماده باشد
            wait (Processing == 0);

            // مقداردهی داده و فعال‌سازی Insert
            Data_in = data[mem_index][31:0];
            Insert_En = 1;

            // صبر تا شروع پردازش
            wait (Processing == 1);

            // صبر تا پایان پردازش
            wait (Processing == 0);

            // غیرفعال‌سازی Insert بعد از اتمام پردازش
            Insert_En = 0;

            mem_index = mem_index + 1;
        end

        // صبر 5 پالس کلاک بعد از عدد آخر
        #(5 * 1.8);


        //******************************************** lookup *************************************************///
        
        Data_in = 0;
        mem_index = 0;
        
        // ارسال 100 داده به مدار برای حدف
        // Lookup:
        for (i = 0; i < 1000; i = i + 1) begin
            // صبر تا مدار آماده باشد
            wait (Processing == 0);

            // مقداردهی داده و فعال‌سازی Lookup
            Data_in = data[mem_index][31:0];
            Lookup_En = 1;

            // صبر تا شروع پردازش
            wait (Processing == 1);

            // صبر تا پایان پردازش
            wait (Processing == 0);

            // غیرفعال‌سازی Lookup بعد از اتمام پردازش
            Lookup_En = 0;

            mem_index = mem_index + 1;
        end

        // صبر 5 پالس کلاک بعد از عدد آخر
        #(5 * 1.8);
        

        //******************************************** delete *************************************************//

        Data_in = 0;
        mem_index = 0;

        // ارسال داده به مدار برای حذف
        // Delete:
        for (i = 0; i < 1000; i = i + 1) begin
            // صبر تا مدار آماده باشد
            wait (Processing == 0);

            // مقداردهی داده و فعال‌سازی Insert
            Data_in = data[mem_index][31:0];
            Delete_En = 1;

            // صبر تا شروع پردازش
            wait (Processing == 1);

            // صبر تا پایان پردازش
            wait (Processing == 0);

            // غیرفعال‌سازی Insert بعد از اتمام پردازش
            Delete_En = 0;

            mem_index = mem_index + 1;
        end

        // صبر 5 پالس کلاک بعد از عدد آخر
        #(5 * 1.8);
        

        $stop;
    end






    
    // ************************ Behavioural Cuckoo Filter ****************************
    // Regs
    /*
    reg [31:0] SW_Data_in;    // it's 32bit 

    // Wires
    wire [15:0] SW_fingerprint_out;
    wire [15:0] SW_hash_1_out;
    wire [15:0] SW_hash_2_out;
    wire [15:0] SW_hash_3_out;

    // variables
    integer SW_i;
    integer SW_j;
    integer SW_mem_index = 0;
    reg [15:0] SW_Finger_Print;
    reg [15:0] SW_Evicted_FingerPrint = 16'b0;
    reg [15:0] current_evicted_address;
    reg [1:0] SW_Chosen_Hash_to_Evict;
    reg [1:0] SW_Chosen_slot_to_Evict;


    // input data to filter:
    reg [63:0] SW_data [0:249999]; // حافظه داده


    // Memory Buckets
    reg [63:0] SW_memory [0:65535];
    initial begin
        for (i = 0; i < 65536; i = i + 1) begin
            SW_memory[i] = 64'b0;
        end
    end

    // FingerPrint module to calculate fingerprint
    fingerprint_hash SW_FingerPrint(
        .clk(Clock),
        .data_in(SW_Data_in),
        .fingerprint(SW_fingerprint_out)
    );

    // Hash Index 1 Module to calculate address of bucket
    hash_index1 SW_hash_1(
        .clk(Clock),
        .data_in(SW_Data_in),
        .index1(SW_hash_1_out)
    );

    // Hash Index 2 Module to calculate address of bucket
    hash_index2 SW_hash_2(
        .clk(Clock),
        .index1(SW_hash_1_out),
        .fingerprint(SW_fingerprint_out),
        .index2(SW_hash_2_out)
    );

    // Hash Index 3 Module to calculate address of bucket
    // To find second possible address for evicted FP:
    hash_index2 SW_hash_3(
        .clk(Clock),
        .index1(current_evicted_address),              // زمانی که آدرس رو دوباره از خودش میگیره ممکنه مشکل ایجاد کنه پس از رجیستر به جای وایر استفاده کن
        .fingerprint(SW_Evicted_FingerPrint),
        .index2(SW_hash_3_out)
    );



    /////////////// Operations ///////////////    
    initial begin

        /////////////////////////////////////// 
        // insert:
        /*
        // بارگذاری داده‌ها از فایل
        $readmemh("C:/Users/Azadi/Desktop/C_Project/data_in_250000.mem", SW_data);   // when the amount of data changes, the for-loop and also reg data changes too.

        for (SW_i = 0; SW_i < 250000; SW_i = SW_i + 1) begin
            SW_Data_in = SW_data[SW_mem_index][31:0];
            #10;
            SW_Finger_Print = SW_fingerprint_out;
            #10;

            $display("Insert %d ===> Data_in = %h, FP = %h, H1 = %h, H2 = %h", SW_i, SW_Data_in, SW_Finger_Print, SW_hash_1_out, SW_hash_2_out);  

        
            // is it exist in first place(determined by SW_hash_1)?
            if ((SW_memory[SW_hash_1_out][15:0] == SW_Finger_Print) || (SW_memory[SW_hash_1_out][31:16] == SW_Finger_Print) || (SW_memory[SW_hash_1_out][47:32] == SW_Finger_Print) || (SW_memory[SW_hash_1_out][63:48] == SW_Finger_Print)) begin
                // nothing
            end
            // is it exist in second place(determined by SW_hash_2)?
            else if ((SW_memory[SW_hash_2_out][15:0] == SW_Finger_Print) || (SW_memory[SW_hash_2_out][31:16] == SW_Finger_Print) || (SW_memory[SW_hash_2_out][47:32] == SW_Finger_Print) || (SW_memory[SW_hash_2_out][63:48] == SW_Finger_Print)) begin
                // nothing
            end

            // it doesn't exist; so we can insert it.
            // insert in first place(determined by SW_hash_1) if it has empty slot:
            else if (SW_memory[SW_hash_1_out][15] == 1'b0) begin
                SW_memory[SW_hash_1_out][15:0] = SW_Finger_Print;
            end
            else if (SW_memory[SW_hash_1_out][31] == 1'b0) begin
                SW_memory[SW_hash_1_out][31:16] = SW_Finger_Print;
            end
            else if (SW_memory[SW_hash_1_out][47] == 1'b0) begin
                SW_memory[SW_hash_1_out][47:32] = SW_Finger_Print;
            end
            else if (SW_memory[SW_hash_1_out][63] == 1'b0) begin
                SW_memory[SW_hash_1_out][63:48] = SW_Finger_Print;
            end
            // insert in first place(determined by SW_hash_2) if it has empty slot:
            else if (SW_memory[SW_hash_2_out][15] == 1'b0) begin
                SW_memory[SW_hash_2_out][15:0] = SW_Finger_Print;
            end
            else if (SW_memory[SW_hash_2_out][31] == 1'b0) begin
                SW_memory[SW_hash_2_out][31:16] = SW_Finger_Print;
            end
            else if (SW_memory[SW_hash_2_out][47] == 1'b0) begin
                SW_memory[SW_hash_2_out][47:32] = SW_Finger_Print;
            end
            else if (SW_memory[SW_hash_2_out][63] == 1'b0) begin
                SW_memory[SW_hash_2_out][63:48] = SW_Finger_Print;
            end

            // there is no empty slot; so we need eviction operation.
            else begin
                if (SW_Data_in == 32'hFF4F6A54) begin
                  $display("here: we go to insert target FP and evict a FP");
                end


                // choose Hash func and slot Randomly to evict:
                SW_Chosen_Hash_to_Evict[0] = SW_Finger_Print[14];    // SW_Finger_Print[15] is Empty-valid-bit and it is always 1; so we use SW_Finger_Print[14] as MSB.
                SW_Chosen_Hash_to_Evict[1] = 1'b0;                   // for the first time it is always 0; to choose between h1 and h2;
                SW_Chosen_slot_to_Evict[1:0] = SW_Finger_Print[1:0];        // chosen slot

                // Chosen hash function to Eviction is h1?:
                if (SW_Chosen_Hash_to_Evict[1:0] == 2'b00) begin
                    // Chosen slot to Eviction is 0?:
                    if (SW_Chosen_slot_to_Evict[1:0] == 2'b00) begin
                        // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                        SW_Evicted_FingerPrint = SW_memory[SW_hash_1_out][15:0];
                        // we need second address of SW_Evicted_FingerPrint:
                        // to second address here, and is SW_hash_3_out(in HW):
                        current_evicted_address = SW_hash_1_out;
                        #10;                      // enough time to hash operate and find second possible palce
                        
                        // insert target FP in conquered slot:
                        SW_memory[SW_hash_1_out][15:0] = SW_Finger_Print;
                    end
                    // Chosen slot to Eviction is 1?:
                    else if (SW_Chosen_slot_to_Evict[1:0] == 2'b01) begin
                        // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                        SW_Evicted_FingerPrint = SW_memory[SW_hash_1_out][31:16];
                        // we need second address of SW_Evicted_FingerPrint:
                        // to second address here, and is SW_hash_3_out(in HW):
                        current_evicted_address = SW_hash_1_out;
                        #10;                      // enough time to hash operate and find second possible palce

                        // insert target FP in conquered slot:
                        SW_memory[SW_hash_1_out][31:16] = SW_Finger_Print;
                    end
                    // Chosen slot to Eviction is 2?:
                    else if (SW_Chosen_slot_to_Evict[1:0] == 2'b10) begin
                        // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                        SW_Evicted_FingerPrint = SW_memory[SW_hash_1_out][47:32];
                        // we need second address of SW_Evicted_FingerPrint:
                        // to second address here, and is SW_hash_3_out(in HW):
                        current_evicted_address = SW_hash_1_out;
                        #10;                      // enough time to hash operate and find second possible palce
                        
                        // insert target FP in conquered slot:
                        SW_memory[SW_hash_1_out][47:32] = SW_Finger_Print;
                    end
                    // Chosen slot to Eviction is 3?:
                    else if (SW_Chosen_slot_to_Evict[1:0] == 2'b11) begin
                        // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                        SW_Evicted_FingerPrint = SW_memory[SW_hash_1_out][63:48];
                        // we need second address of SW_Evicted_FingerPrint:
                        // to second address here, and is SW_hash_3_out(in HW):
                        current_evicted_address = SW_hash_1_out;
                        #10;                      // enough time to hash operate and find second possible palce

                        // insert target FP in conquered slot:
                        SW_memory[SW_hash_1_out][63:48] = SW_Finger_Print;
                    end
                end
                // Chosen hash function to Eviction is h2?:
                else if (SW_Chosen_Hash_to_Evict[1:0] == 2'b01) begin
                    // Chosen slot to Eviction is 0?:
                    if (SW_Chosen_slot_to_Evict[1:0] == 2'b00) begin
                        // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                        SW_Evicted_FingerPrint = SW_memory[SW_hash_2_out][15:0];
                        // we need second address of SW_Evicted_FingerPrint:
                        // to second address here, and is SW_hash_3_out(in HW):
                        current_evicted_address = SW_hash_2_out;
                        #10;                      // enough time to hash operate and find second possible palce

                        // insert target FP in conquered slot:
                        SW_memory[SW_hash_2_out][15:0] = SW_Finger_Print;
                    end
                    // Chosen slot to Eviction is 1?:
                    else if (SW_Chosen_slot_to_Evict[1:0] == 2'b01) begin
                        // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                        SW_Evicted_FingerPrint = SW_memory[SW_hash_2_out][31:16];
                        // we need second address of SW_Evicted_FingerPrint:
                        // to second address here, and is SW_hash_3_out(in HW):
                        current_evicted_address = SW_hash_2_out;
                        #10;                      // enough time to hash operate and find second possible palce

                        // insert target FP in conquered slot:
                        SW_memory[SW_hash_2_out][31:16] = SW_Finger_Print;
                    end
                    // Chosen slot to Eviction is 2?:
                    else if (SW_Chosen_slot_to_Evict[1:0] == 2'b10) begin
                        // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                        SW_Evicted_FingerPrint = SW_memory[SW_hash_2_out][47:32];
                        // we need second address of SW_Evicted_FingerPrint:
                        // to second address here, and is SW_hash_3_out(in HW):
                        current_evicted_address = SW_hash_2_out;
                        #10;                      // enough time to hash operate and find second possible palce

                        // insert target FP in conquered slot:
                        SW_memory[SW_hash_2_out][47:32] = SW_Finger_Print;
                    end
                    // Chosen slot to Eviction is 3?:
                    else if (SW_Chosen_slot_to_Evict[1:0] == 2'b11) begin
                        // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                        SW_Evicted_FingerPrint = SW_memory[SW_hash_2_out][63:48];
                        // we need second address of SW_Evicted_FingerPrint:
                        // to second address here, and is SW_hash_3_out(in HW):
                        current_evicted_address = SW_hash_2_out;
                        #10;                      // enough time to hash operate and find second possible palce

                        // insert target FP in conquered slot:
                        SW_memory[SW_hash_2_out][63:48] = SW_Finger_Print;
                    end
                end

                // now we have to insert SW_Evicted_FingerPrint as a Fingerprint:
                SW_Finger_Print = SW_Evicted_FingerPrint;
                #10;
                // and go to insert it:

                // Eviction Operation:
                for (SW_j = 1; SW_j <= 500; SW_j = SW_j + 1) begin

                    if (SW_Data_in == 32'hFF4F6A54) begin
                        $display("here: we go to insert evicted FP(if there is empty slot in second place)");
                        $display("loop %d,   Data_in = %h, FP = %h, vctd_FP = %h, H1 = %d, H2 = %d, H3 = %d, crnt_vctd_adrs = %d", SW_i, SW_Data_in, SW_Finger_Print, SW_Evicted_FingerPrint, SW_hash_1_out, SW_hash_2_out, SW_hash_3_out, current_evicted_address);
                    end

                    // is it exist in second possible address(determined by SW_hash_3)?
                    if ((SW_memory[SW_hash_3_out][15:0] == SW_Finger_Print) || (SW_memory[SW_hash_3_out][31:16] == SW_Finger_Print) || (SW_memory[SW_hash_3_out][47:32] == SW_Finger_Print) || (SW_memory[SW_hash_3_out][63:48] == SW_Finger_Print)) begin
                        // nothing
                        SW_j = 501;   // break
                        $display("here: there is FP already in memory! so we don't insert it");
                        $display("loop %d,   Data_in = %h, FP = %h, vctd_FP = %h, H1 = %d, H2 = %d, H3 = %d, crnt_vctd_adrs = %d", SW_i, SW_Data_in, SW_Finger_Print, SW_Evicted_FingerPrint, SW_hash_1_out, SW_hash_2_out, SW_hash_3_out, current_evicted_address);
                    end
                    // it doesn't exist; so we can insert it(Directly or by Eviction).
                    // insert in second possible address(determined by SW_hash_3) if it has empty slot:
                    else if (SW_memory[SW_hash_3_out][15] == 1'b0) begin
                        SW_memory[SW_hash_3_out][15:0] = SW_Finger_Print;
                        SW_j = 501;   // break
                    end
                    else if (SW_memory[SW_hash_3_out][31] == 1'b0) begin
                        $display("aaaahhhhha; i got you!!!");
                        $display("loop %d,   Data_in = %h, FP = %h, vctd_FP = %h, H1 = %d, H2 = %d, H3 = %d, crnt_vctd_adrs = %d", SW_i, SW_Data_in, SW_Finger_Print, SW_Evicted_FingerPrint, SW_hash_1_out, SW_hash_2_out, SW_hash_3_out, current_evicted_address);
                        SW_memory[SW_hash_3_out][31:16] = SW_Finger_Print;
                        SW_j = 501;   // break
                    end
                    else if (SW_memory[SW_hash_3_out][47] == 1'b0) begin
                        SW_memory[SW_hash_3_out][47:32] = SW_Finger_Print;
                        SW_j = 501;   // break
                    end
                    else if (SW_memory[SW_hash_3_out][63] == 1'b0) begin
                        SW_memory[SW_hash_3_out][63:48] = SW_Finger_Print;
                        SW_j = 501;   // break
                    end

                    else begin        // There is no empty slot for evicted FP; so we insert current evicted FP and make another one evicted.
                        
                        if (SW_Data_in == 32'hFF4F6A54) begin
                            $display("here: there wasn't empty place; so we go to insert evicted FP and make another one evict FP");
                            $display("loop %d,   Data_in = %h, FP = %h, vctd_FP = %h, H1 = %d, H2 = %d, H3 = %d, crnt_vctd_adrs = %d", SW_i, SW_Data_in, SW_Finger_Print, SW_Evicted_FingerPrint, SW_hash_1_out, SW_hash_2_out, SW_hash_3_out, current_evicted_address);
                        end

                        // Choose the slot that must be evicted:
                        SW_Chosen_Hash_to_Evict[1:0] = 2'b10;                     // it's not random; it must be h3.
                        SW_Chosen_slot_to_Evict[1:0] = SW_Finger_Print[1:0];      // Randomly chosen slot
                        $display("SW_Chosen_Hash_to_Evict = %b, SW_Chosen_slot_to_Evict = %b", SW_Chosen_Hash_to_Evict, SW_Chosen_slot_to_Evict);

                        // we know that the chosen hash function to Eviction is h3; so:

                            // Chosen slot to Eviction is 0?:
                            if (SW_Chosen_slot_to_Evict[1:0] == 2'b00) begin
                                // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                                SW_Evicted_FingerPrint = SW_memory[SW_hash_3_out][15:0];
                                // we need second address of the new SW_Evicted_FingerPrint:
                                // to second address here, and it is SW_hash_3_out(in HW):
                                current_evicted_address = SW_hash_3_out;
                                #10;                      // enough time to hash operate and find second possible palce
                                
                                // insert target FP in conquered slot:
                                SW_memory[SW_hash_3_out][15:0] = SW_Finger_Print;
                            end
                            // Chosen slot to Eviction is 1?:
                            else if (SW_Chosen_slot_to_Evict[1:0] == 2'b01) begin
                                // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                                SW_Evicted_FingerPrint = SW_memory[SW_hash_3_out][31:16];
                                // we need second address of the new SW_Evicted_FingerPrint:
                                // to second address here, and is SW_hash_3_out(in HW):
                                current_evicted_address = SW_hash_3_out;
                                #10;                      // enough time to hash operate and find second possible palce

                                // insert target FP in conquered slot:
                                SW_memory[SW_hash_3_out][31:16] = SW_Finger_Print;
                            end
                            // Chosen slot to Eviction is 2?:
                            else if (SW_Chosen_slot_to_Evict[1:0] == 2'b10) begin
                                // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                                SW_Evicted_FingerPrint = SW_memory[SW_hash_3_out][47:32];
                                // we need second address of the new SW_Evicted_FingerPrint:
                                // to second address here, and is SW_hash_3_out(in HW):
                                current_evicted_address = SW_hash_3_out;
                                #10;                      // enough time to hash operate and find second possible palce
                                
                                // insert target FP in conquered slot:
                                SW_memory[SW_hash_3_out][47:32] = SW_Finger_Print;
                            end
                            // Chosen slot to Eviction is 3?:
                            else if (SW_Chosen_slot_to_Evict[1:0] == 2'b11) begin
                                // we have to updata SW_Evicted_FingerPrint and get current evicted FP:
                                SW_Evicted_FingerPrint = SW_memory[SW_hash_3_out][63:48];
                                // we need second address of the new SW_Evicted_FingerPrint:
                                // to second address here, and is SW_hash_3_out(in HW):
                                current_evicted_address = SW_hash_3_out;
                                #10;                      // enough time to hash operate and find second possible palce

                                // insert target FP in conquered slot:
                                SW_memory[SW_hash_3_out][63:48] = SW_Finger_Print;
                            end

                        // Now we have inserted the current evicted FP and make another evicted FP; So
                        // we repeat the operation to find empty slot for next evicted FP

                        // before we go...
                        // now we have to insert SW_Evicted_FingerPrint as a Fingerprint:
                        SW_Finger_Print = SW_Evicted_FingerPrint;
                        #10;
                        // and go to insert it by repeat the for loop:
                        if (SW_Data_in == 32'hFF4F6A54) begin
                          $display("here: we go to loop agian to find place for next evicted FP");
                          $display("loop %d,   Data_in = %h, FP = %h, vctd_FP = %h, H1 = %d, H2 = %d, H3 = %d, crnt_vctd_adrs = %d", SW_i, SW_Data_in, SW_Finger_Print, SW_Evicted_FingerPrint, SW_hash_1_out, SW_hash_2_out, SW_hash_3_out, current_evicted_address);
                        end

                    end

                    
                end


            end
            
            

            SW_mem_index = SW_mem_index + 1;
        end

        */
        

        ///////////////////////////////////////
        // Delete:
        /*
        SW_mem_index = 0;

        for (SW_i = 0; SW_i < 100; SW_i = SW_i + 2) begin
            SW_Data_in = SW_data[SW_mem_index][31:0];
            #10;

            $display("Delete ===> Data_in = %h, FP = %h, H1 = %h, H2 = %h", SW_Data_in, SW_fingerprint_out, SW_hash_1_out, SW_hash_2_out);  

            // is it exist in first place(determined by SW_hash_1)?
            if ((SW_memory[SW_hash_1_out][15:0] == SW_fingerprint_out) || (SW_memory[SW_hash_1_out][31:16] == SW_fingerprint_out) || (SW_memory[SW_hash_1_out][47:32] == SW_fingerprint_out) || (SW_memory[SW_hash_1_out][63:48] == SW_fingerprint_out)) begin
                // in wich slot it is exist; remove it:
                if(SW_memory[SW_hash_1_out][15:0] == SW_fingerprint_out)begin
                    SW_memory[SW_hash_1_out][15:0] = 16'b0;
                end
                else if(SW_memory[SW_hash_1_out][31:16] == SW_fingerprint_out)begin
                    SW_memory[SW_hash_1_out][31:16] = 16'b0;
                end
                else if(SW_memory[SW_hash_1_out][47:32] == SW_fingerprint_out)begin
                    SW_memory[SW_hash_1_out][47:32] = 16'b0;
                end
                else if(SW_memory[SW_hash_1_out][63:48] == SW_fingerprint_out)begin
                    SW_memory[SW_hash_1_out][63:48] = 16'b0;
                end
            end

            // is it exist in second place(determined by SW_hash_2)?
            else if ((SW_memory[SW_hash_2_out][15:0] == SW_fingerprint_out) || (SW_memory[SW_hash_2_out][31:16] == SW_fingerprint_out) || (SW_memory[SW_hash_2_out][47:32] == SW_fingerprint_out) || (SW_memory[SW_hash_2_out][63:48] == SW_fingerprint_out)) begin
                // in wich slot it is exist; remove it:
                if(SW_memory[SW_hash_2_out][15:0] == SW_fingerprint_out)begin
                    SW_memory[SW_hash_2_out][15:0] = 16'b0;
                end
                else if(SW_memory[SW_hash_2_out][31:16] == SW_fingerprint_out)begin
                    SW_memory[SW_hash_2_out][31:16] = 16'b0;
                end
                else if(SW_memory[SW_hash_2_out][47:32] == SW_fingerprint_out)begin
                    SW_memory[SW_hash_2_out][47:32] = 16'b0;
                end
                else if(SW_memory[SW_hash_2_out][63:48] == SW_fingerprint_out)begin
                    SW_memory[SW_hash_2_out][63:48] = 16'b0;
                end
            end

            SW_mem_index = SW_mem_index + 2;
        end
        */

        /*
        /////////////////////////////////////// 
        // lookup:


    

    end
    


    /*
    
    always @(posedge Clock) begin
        if (sh_system.Sh_memory.clk !== system.MEMORY.clka) begin
            $display("Mismatch in clk ===> time = %d, Sh_memory = %d, MEMORY = %d", $time, sh_system.Sh_memory.clk, system.MEMORY.clka);
        end
        if (sh_system.Sh_memory.rst !== system.MEMORY.rsta) begin
            $display("Mismatch in rst ===> time = %d, Sh_memory = %d, MEMORY = %d", $time, sh_system.Sh_memory.rst, system.MEMORY.rsta);
        end
        if (sh_system.Sh_memory.enable !== system.MEMORY.ena) begin
            $display("Mismatch in enable ===> time = %d, Sh_memory = %d, MEMORY = %d", $time, sh_system.Sh_memory.enable, system.MEMORY.ena);
        end
        if (sh_system.Sh_memory.write_enable !== system.MEMORY.wea) begin
            $display("Mismatch in write_En ===> time = %d, Sh_memory = %d, MEMORY = %d", $time, sh_system.Sh_memory.write_enable, system.MEMORY.wea);
        end
        if (sh_system.Sh_memory.address !== system.MEMORY.addra) begin
            $display("Mismatch in address ===> time = %d, Sh_memory = %d, MEMORY = %d", $time, sh_system.Sh_memory.address, system.MEMORY.addra);
        end
        if (sh_system.Sh_memory.write_data !== system.MEMORY.dina) begin
            $display("Mismatch in write_data ===> time = %d, Sh_memory = %d, MEMORY = %d", $time, sh_system.Sh_memory.write_data, system.MEMORY.dina);
        end
        if (sh_system.Sh_memory.read_data !== system.MEMORY.douta) begin
            $display("Mismatch in read_data ===> time = %d, Sh_memory = %d, MEMORY = %d", $time, sh_system.Sh_memory.read_data, system.MEMORY.douta);
        end
    end
    
    reg sh_Clock;
    reg sh_Reset;
    reg [31:0] sh_Data_in;
    reg sh_Lookup_En;
    reg sh_Insert_En;
    reg sh_Delete_En;

    wire sh_Lookup_Result;
    wire sh_Insert_Done;
    wire sh_Delete_Done;
    wire sh_Processing;


    reg [63:0] sh_data [0:199999]; // حافظه داده    
    integer sh_i;
    integer sh_mem_index;

    // تولید کلاک 10ns
    always #5 sh_Clock = ~sh_Clock;

    // نمونه‌سازی ماژول سایه
    Sh_System sh_system (
        .Clock(sh_Clock),
        .Reset(sh_Reset),
        .Data_in(sh_Data_in),
        .Lookup_En(sh_Lookup_En),
        .Insert_En(sh_Insert_En),
        .Delete_En(sh_Delete_En),
        .Lookup_Result(sh_Lookup_Result),
        .Insert_Done(sh_Insert_Done),
        .Delete_Done(sh_Delete_Done),
        .Processing(sh_Processing)
    );
    
    initial begin
        // مقداردهی اولیه
        sh_Clock = 1;
        sh_Reset = 1;
        sh_Data_in = 0;
        sh_Insert_En = 0;
        sh_Lookup_En = 0;
        sh_Delete_En = 0;
        sh_mem_index = 0;


        //******************************************** insert *************************************************///
        // بارگذاری داده‌ها از فایل
        /*
        $readmemh("C:/Users/Azadi/Desktop/C_Project/data_in_200000.mem", sh_data);   // when the amount of data changes, the for-loop and also reg data changes too.

        // فعال‌سازی ریست برای 5 سیکل
        #50;
        sh_Reset = 0;
        #10;
        
        // Shadow system
        // ارسال 100 داده به مدار برای درج
        // Insertion:
        for (sh_i = 0; sh_i < 200000; sh_i = sh_i + 1) begin
            // صبر تا مدار آماده باشد
            wait (sh_Processing == 0);

            // مقداردهی داده و فعال‌سازی Insert
            sh_Data_in = sh_data[sh_mem_index][31:0];
            sh_Insert_En = 1;

            // صبر تا شروع پردازش
            wait (sh_Processing == 1);

            // صبر تا پایان پردازش
            wait (sh_Processing == 0);

            // غیرفعال‌سازی Insert بعد از اتمام پردازش
            sh_Insert_En = 0;

            sh_mem_index = sh_mem_index + 1;
        end

        // صبر 5 پالس کلاک بعد از عدد آخر
        #(5 * 10);


        $stop;

    end

    */





endmodule
