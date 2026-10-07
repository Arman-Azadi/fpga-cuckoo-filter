module controller(
    input clk,
    input reset_main,          // it comes from CF module
    input lookup_en,
    input insert_en,
    input delete_en,
    input [3:0] Comp_FP_mem_Reg_result,                  // Output of Information and Control Reg from Data Path 
    input [3:0] Empty_Slot_Check_Result_Reg_out_result,  // Output of Information and Control Reg from Data Path 
    input [15:0] FingerPrint_Reg_value,                  // to determine random values

    input Processing_DFF_output,    // it comes from Data Path
    input [3:0] MUXs_Select_Manager_Reg_output_from_DataPath,       // it comes from DP and report about MUXs select 

    output reg mem_enable,          // it goes to memory
    output reg we_write_read_en,         // it goes to memory

    output reg lookup_result,                 // to Lookup_result_DFF_input
    output reg insert_done,                   // to Insert_Done_DFF_input
    output reg delete_done,                   // to Delete_Done_DFF_input
    output reg Processing_DFF_input,          // to Proseccing_DFF_input

    output reg load_Data_Store_Reg,
    output reg load_Reg_H1,
    output reg load_Reg_FP,
    output reg load_mem_Address_Reg,
    output reg load_temp_mem_value_Reg,
    output reg load_h1_memory_value_holder_Reg, 
    output reg load_Comp_FP_mem_Reg,
    output reg load_empty_slot_check_result_Reg, 
    output reg load_Lookup_result_DFF,
    output reg load_Insert_Done_DFF,
    output reg load_Delete_Done_DFF,
    output reg load_Proseccing_DFF,
    output reg load_MUXs_Select_Manager_Reg,
    output reg load_mask_gen_Reg,
    output reg load_Reg_homeless_evicted,
    output reg load_Add_homeless,
    
    output reg [3:0] MUXs_Select_Manager_Reg_input,        // it goes to Data Path and determines MUXs select
    output reg [1:0] attach_location,                      // output to Data Path (Row_Position_Reg[4:3]); It will be used by mask generator
    output reg reset_to_DP,                                 // Data Path reset will be control by Controller; to reset the Data Path after a mission on a target element
    output reg filter_is_full
);

    // defining state parameters 
    localparam [3:0] INIT         = 4'b0000;  // 0
    localparam [3:0] LOOKUP_STEP1 = 4'b0001;  // 1
    localparam [3:0] LOOKUP_STEP2 = 4'b0010;  // 2
    localparam [3:0] LOOKUP_STEP3 = 4'b0011;  // 3
    localparam [3:0] LOOKUP_STEP4 = 4'b0100;  // 4

    localparam [3:0] INSERT_STEP1 = 4'b0101;  // 5
    localparam [3:0] INSERT_STEP2 = 4'b0110;  // 6
    localparam [3:0] INSERT_STEP3 = 4'b0111;  // 7

    localparam [3:0] DELETE_STEP1 = 4'b1000;  // 8

    // defining states variables
    reg [3:0] present_state;
    reg [3:0] next_state;

    // defining registers
    reg [4:0] Row_Position_Reg;
    reg [4:0] r_Row_Position_Reg;
    reg [15:0] limit_loop_Reg = 16'd0;
    reg [15:0] r_limit_loop_Reg = 16'd0;
    reg [7:0] limit_memory_wait_Reg = 8'd0;
    reg [7:0] counter_hash_pipline = 8'b0;


    always @(posedge clk) begin
        r_Row_Position_Reg <= Row_Position_Reg;
    end

    always @(limit_loop_Reg) begin
        r_limit_loop_Reg = limit_loop_Reg;
    end

    

    // state assignments
    // Define sequential block 
    always @(posedge clk or posedge reset_main) begin   
        if (reset_main || (r_limit_loop_Reg == 16'd501))    
            present_state <= INIT;
        else
            present_state <= next_state;
    end

    // state transition
    // Define the next state combinational circuit
    always @(*) begin
        next_state <= INIT;
        
        case (present_state)
            INIT: begin
                if (((lookup_en == 1) || (insert_en == 1) || (delete_en == 1)) && (Processing_DFF_output == 0))
                    next_state <= LOOKUP_STEP1;
                else
                    next_state <= INIT;
            end

            LOOKUP_STEP1: begin
                if ((MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b00) && (counter_hash_pipline == 8'd6))
                    next_state <= LOOKUP_STEP2;
                else if ((MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b01) && (counter_hash_pipline == 8'd1))
                    next_state <= LOOKUP_STEP2;
                else if ((MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b10) && (counter_hash_pipline == 8'd3))
                    next_state <= LOOKUP_STEP2;
                else
                    next_state <= LOOKUP_STEP1;
            end

            LOOKUP_STEP2: begin
                if (limit_memory_wait_Reg == 8'd2)
                    next_state <= LOOKUP_STEP3;
                else 
                    next_state <= LOOKUP_STEP2;
            end

            LOOKUP_STEP3: begin
                next_state <= LOOKUP_STEP4;
            end

            LOOKUP_STEP4: begin
                if (Comp_FP_mem_Reg_result != 4'b0000) begin           // it means FP exist
                    if (lookup_en == 1)
                        next_state <= INIT;
                    else if (insert_en == 1)
                        next_state <= INIT;
                    else if (delete_en == 1)
                        next_state <= DELETE_STEP1;
                    else                                 // it means there is no Enable mission(lookup, insert, delete)
                        next_state <= INIT;
                end
                else begin                               // it means FP doesn't exist
                    // it was h1(x) turn:
                    if (MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b00) begin   // it refers to add_mux_sel
                        next_state <= LOOKUP_STEP1;
                    end
                    // it was h2(x) turn:
                    else if (MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b01) begin   // it refers to add_mux_sel
                        if (lookup_en == 1)
                            next_state <= INIT;
                        else if (insert_en == 1)
                            next_state <= INSERT_STEP1;
                        else if (delete_en == 1)
                            next_state <= INIT;
                    end
                    // it was h3(x) turn:
                    // When lookup is happenning for evicted FP:
                    else if (MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b10) begin   // it refers to add_mux_sel
                        next_state <= INSERT_STEP1;
                    end
                    else      // it means MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b11  // it's unvalid value
                        next_state <= INIT;
                end
            end

            INSERT_STEP1: begin
                // there is empty slot:
                if (r_Row_Position_Reg[2] == 1'b1) begin
                    // which hash function found it:
                    if ((r_Row_Position_Reg[1:0] == 2'b00) || (r_Row_Position_Reg[1:0] == 2'b01) || (r_Row_Position_Reg[1:0] == 2'b10))
                        next_state <= INSERT_STEP2;
                    else                                // when Row_Position_Reg[1:0] == 2'b11  // it's unvalid value.
                        next_state <= INIT;
                end
                // there is no empty slot:
                else if (r_Row_Position_Reg[2] == 1'b0) begin
                    next_state <= INSERT_STEP2;
                end
            end

            INSERT_STEP2: begin
                next_state <= INSERT_STEP3;
            end

            INSERT_STEP3: begin
                if (limit_memory_wait_Reg == 8'd2) begin
                    // there was empty slot and target FP is inserted:
                    if (r_Row_Position_Reg[2] == 1'b1)
                        next_state <= INIT;
                    // there was no empty slot and now there is an evicted FP in Reg_homeless_evicted
                    else if (r_Row_Position_Reg[2] == 1'b0)
                        next_state <= LOOKUP_STEP1;
                end
                else 
                    next_state <= INSERT_STEP3;
            end

            DELETE_STEP1: begin
                if (limit_memory_wait_Reg == 8'd2)
                    next_state <= INIT;
                else
                    next_state <= DELETE_STEP1;
            end

            default: next_state <= INIT;
        endcase
    end

    // Output assignment
    // Define output assignment
    always @(*) begin
        // load
        load_Data_Store_Reg <= 0;
        load_Reg_FP <= 0;
        load_Reg_H1 <= 0;
        load_mem_Address_Reg <= 0; 
        load_temp_mem_value_Reg <= 0;
        load_h1_memory_value_holder_Reg <= 0;
        load_Comp_FP_mem_Reg <= 0;
        load_empty_slot_check_result_Reg <= 0;
        load_Lookup_result_DFF <= 0;
        load_Insert_Done_DFF <= 0;
        load_Delete_Done_DFF <= 0;
        load_Proseccing_DFF <= 1;
        load_MUXs_Select_Manager_Reg <= 0;
        load_mask_gen_Reg <= 0;
        load_Reg_homeless_evicted <= 0;
        load_Add_homeless <= 0;


        lookup_result <= 0;
        insert_done <= 0;
        delete_done <= 0;
        Processing_DFF_input <= 1;

        r_Row_Position_Reg <= r_Row_Position_Reg;

        reset_to_DP <= 0;
        attach_location <= r_Row_Position_Reg[4:3];

        // below code-line is wrong! don't use this command it will loop. because each time that always block will be run
        // MUXs_Select_Manager_Reg_input value will be 4'b1_0_00.
        // MUXs_Select_Manager_Reg_input <= 4'b1_0_00;     // Add_Mux_sel = 00  ==> h1(x)
                                                           // FP_Mux_sel = 0    ==> FP from FP(x) Module
                                                           // Mask_Mux = 1      ==> Get Background from temp_mem_value_Reg 

        mem_enable <= 0;
        we_write_read_en <= 0;

        case (present_state)
            INIT: begin
                if (((lookup_en == 1) || (insert_en == 1) || (delete_en == 1)) && (Processing_DFF_output == 0)) begin
                    load_Proseccing_DFF <= 1;
                    Processing_DFF_input <= 1;          // processing = 1

                    load_Data_Store_Reg <= 1;
                end       
                else begin
                    load_Proseccing_DFF <= 1;
                    Processing_DFF_input <= 0;          // processing = 0

                    reset_to_DP <= 1;
                    load_Data_Store_Reg <= 1;

                    Row_Position_Reg = 5'b0_0000;
                    // MUXs Select Manager Reg get reset by above code line (reset_to_DP <= 1;)
                end
            end

            LOOKUP_STEP1: begin
                load_Proseccing_DFF <= 1;
                Processing_DFF_input <= 1;                    // processing = 1

                // MUXs_Select_Manager_Reg_input[2] <= 1'b0;     // FP_mux_sel_Reg = 0    // get from FP(x) Module
                // MUXs_Select_Manager_Reg_input[1:0] <= 2'b00;  // add_mux_sel_Reg = 0  // get from h1(x) module
                // it doesn't effect because load_MUXs_Select_Manager_Reg is 0
                // in any way MUXs_Select_Manager_Reg_input[3:0] is 4'b0000 because of being reset; So it doen't need this code lines   
                
                load_Data_Store_Reg <= 0;
                load_Reg_FP <= 1;
                load_Reg_H1 <= 1;
                load_mem_Address_Reg <= 1;
            end

            LOOKUP_STEP2: begin
                load_Proseccing_DFF <= 1;
                Processing_DFF_input <= 1;                // processing = 1

                if (limit_memory_wait_Reg == 8'd2) begin
                    load_temp_mem_value_Reg <= 1;
                    if(MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b00) begin      // it refers to Add_Mux_sel = 0  / [it means h1 is working on]
                    load_h1_memory_value_holder_Reg <= 1;               // when target Hash function is h1; the bucket that it is refering, will be
                                                                        // stored in h1_memory_value_holder_Reg
                    end 
                end
                else begin
                    mem_enable <= 1;
                    we_write_read_en <= 0;
                    // load_mem_Address_Reg <= 1;           // this line most go to previouse state(LookUp1, LookUp4, insert1, insert2)

                    load_temp_mem_value_Reg <= 1;
                    if(MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b00) begin      // it refers to Add_Mux_sel = 0  / [it means h1 is working on]
                        load_h1_memory_value_holder_Reg <= 1;               // when target Hash function is h1; the bucket that it is refering, will be
                                                                            // stored in h1_memory_value_holder_Reg
                    end
                end 
            end

            LOOKUP_STEP3: begin
                load_Proseccing_DFF <= 1;
                Processing_DFF_input <= 1;                // processing = 1

                load_temp_mem_value_Reg <= 0;
                load_h1_memory_value_holder_Reg <= 0;  

                load_Comp_FP_mem_Reg <= 1;
                load_empty_slot_check_result_Reg <= 1;
            end

            LOOKUP_STEP4: begin
                load_Proseccing_DFF <= 1;
                Processing_DFF_input <= 1;                // processing = 1

                if (Comp_FP_mem_Reg_result != 4'b0000) begin     //// it means FP exist
                    if (lookup_en == 1) begin
                        load_Lookup_result_DFF <= 1;
                        lookup_result <= 1;
                    end
                    else if (insert_en == 1) begin
                        load_Insert_Done_DFF <= 1;
                        insert_done <= 0;
                    end
                    else if (delete_en == 1) begin
                        // which Hash Function is refering to target FP?
                        if (MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b00) begin   // it refers to add_mux_sel
                                                                                                // Which Hash function found FP (sel = 00 --> H1(x) / sel = 01 --> H2(x))
                            Row_Position_Reg[1:0] = 2'b00;    // it's H1(x)
                        end
                        else if (MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b01) begin  // it refers to add_mux_sel
                            Row_Position_Reg[1:0] = 2'b01;    // it's H2(x)
                        end

                        // which slot is target FP?
                        if (Comp_FP_mem_Reg_result[0] == 1'b1) begin  // Where is found FP (which slot has the FP)
                            Row_Position_Reg[4:3] = 2'b00;       // Slot 0
                        end
                        else if (Comp_FP_mem_Reg_result[1] == 1'b1) begin
                            Row_Position_Reg[4:3] = 2'b01;       // Slot 1
                        end
                        else if (Comp_FP_mem_Reg_result[2] == 1'b1) begin
                            Row_Position_Reg[4:3] = 2'b10;       // Slot 2
                        end
                        else if (Comp_FP_mem_Reg_result[3] == 1'b1) begin
                            Row_Position_Reg[4:3] = 2'b11;       // Slot 3
                        end
                    end
                        
                end

                else begin               // it means FP doesn't exist    // Comp_FP_mem_Reg_result == 4'b0000
                    // it was h1(x) turn:
                    if (MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b00) begin    
                            load_MUXs_Select_Manager_Reg <= 1;    
                            MUXs_Select_Manager_Reg_input[1:0] <= 2'b01;      // h1 didn't find it(FP); so try with h2(x) next time.
                            MUXs_Select_Manager_Reg_input[2] <= 1'b0;         // FP_Mux_sel = 0    ==> FP from FP(x) Module
                                                                              // we gonna go back and lookup for target FP(current on in Reg_FP); so don't ruin Reg_FP value.         
                            MUXs_Select_Manager_Reg_input[3] <= 1'b1;         // Mask_Mux = 1      ==> Get Background from temp_mem_value_Reg

                            load_mem_Address_Reg <= 1;

                            if (insert_en == 1) begin
                                // which Hash Function is refering to Empty slot(if it's exist)?
                                if (Empty_Slot_Check_Result_Reg_out_result != 4'b0000) begin  // Is there any empty slot?
                                    Row_Position_Reg[1:0] = 2'b00;   // H1(x) found empty slot
                                    Row_Position_Reg[2] = 1'b1;      // Empty slot found (it's exist)

                                    // which slot is empty?
                                    if (Empty_Slot_Check_Result_Reg_out_result[0] == 1'b1) begin
                                        Row_Position_Reg[4:3] = 2'b00;  // Slot 0
                                    end
                                    else if (Empty_Slot_Check_Result_Reg_out_result[1] == 1'b1) begin
                                        Row_Position_Reg[4:3] = 2'b01;  // Slot 1
                                    end
                                    else if (Empty_Slot_Check_Result_Reg_out_result[2] == 1'b1) begin
                                        Row_Position_Reg[4:3] = 2'b10;  // Slot 2
                                    end
                                    else if (Empty_Slot_Check_Result_Reg_out_result[3] == 1'b1) begin
                                        Row_Position_Reg[4:3] = 2'b11;  // Slot 3
                                    end
                                end
                                else begin  // No empty slot in row determined by H1(x)
                                    Row_Position_Reg[2] = 1'b0;  // No empty slot with H1(x); go to try with h2(x)
                                end
                            end
                    end

                    // it was h2(x) turn:
                    else if (MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b01) begin      // it refers to add_mux_sel
                        if (lookup_en == 1) begin
                            load_Lookup_result_DFF <= 1;
                            lookup_result <= 0;
                        end
                        else if (insert_en == 1) begin
                            if (r_Row_Position_Reg[2] == 1'b1) begin      // is there empty slot already(found by h1)? if yes; don't modify it.
                                // nothing
                            end
                            else begin  // H1(x) didn't find empty slot, try H2(x)
                                if (Empty_Slot_Check_Result_Reg_out_result != 4'b0000) begin
                                    Row_Position_Reg[1:0] = 2'b01;  // H2(x) found empty slot
                                    Row_Position_Reg[2] = 1'b1;     // Empty slot found

                                    if (Empty_Slot_Check_Result_Reg_out_result[0] == 1'b1) begin
                                        Row_Position_Reg[4:3] = 2'b00;  // Slot 0
                                    end
                                    else if (Empty_Slot_Check_Result_Reg_out_result[1] == 1'b1) begin
                                        Row_Position_Reg[4:3] = 2'b01;  // Slot 1
                                    end
                                    else if (Empty_Slot_Check_Result_Reg_out_result[2] == 1'b1) begin
                                        Row_Position_Reg[4:3] = 2'b10;  // Slot 2
                                    end
                                    else if (Empty_Slot_Check_Result_Reg_out_result[3] == 1'b1) begin
                                        Row_Position_Reg[4:3] = 2'b11;  // Slot 3
                                    end
                                end
                                else begin  // No empty slot with H2(x) or H1(x) ---> random choose to eviction
                                    Row_Position_Reg[0] = FingerPrint_Reg_value[14];   // FingerPrint_Reg_value[15] is Empty-valid-bit and it remain 1; so we use FingerPrint_Reg_value[14] as MSB
                                                                                            // Row_Position_Reg[1:0] equals 2'b01;
                                                                                            // Row_Position_Reg[1:0] must be 2'b00(refer to h1(x)) or 2'b01(refer to h2(x));
                                                                                            // so we just change the LSB; it means Row_Position_Reg[0].
                                                                                            // which Hash function must be chosen to evict? it will be decide randomly by FingerPrint_Reg_value MSB;
                                    Row_Position_Reg[1] = 1'b0;     // it must be 0; becuase we gonna choose between 2'b00(refer to h1(x)) or 2'b01(refer to h2(x)).
                                    Row_Position_Reg[2] = 1'b0;     // Eviction needed (there is no empty slot for target FP).
                                    Row_Position_Reg[4:3] = FingerPrint_Reg_value[1:0];  // the slot to evict will be chosen randomly by FingerPrint_Reg_value[1:0].
                                end
                            end
                        end
                        else if (delete_en == 1) begin
                            load_Delete_Done_DFF <= 1;
                            delete_done <= 0;
                        end

                    end

                    // it was h3(x) turn:
                    // When lookup is happenning for evicted FP:
                    else if (MUXs_Select_Manager_Reg_output_from_DataPath[1:0] == 2'b10) begin         // it refers to add_mux_sel = 2   (h3)
                                                                                                    // it refers lookup for evicted FP
                        if (Empty_Slot_Check_Result_Reg_out_result != 4'b0000) begin           // is there any empty slot for evicted FP
                            Row_Position_Reg[1:0] = 2'b10;      // H3(x) found empty slot for evicted FP(homeless)
                            Row_Position_Reg[2] = 1'b1;         // Empty slot found

                            if (Empty_Slot_Check_Result_Reg_out_result[0] == 1'b1) begin
                                Row_Position_Reg[4:3] = 2'b00;  // Slot 0
                            end
                            else if (Empty_Slot_Check_Result_Reg_out_result[1] == 1'b1) begin
                                Row_Position_Reg[4:3] = 2'b01;  // Slot 1
                            end
                            else if (Empty_Slot_Check_Result_Reg_out_result[2] == 1'b1) begin
                                Row_Position_Reg[4:3] = 2'b10;  // Slot 2
                            end
                            else if (Empty_Slot_Check_Result_Reg_out_result[3] == 1'b1) begin
                                Row_Position_Reg[4:3] = 2'b11;  // Slot 3
                            end
                        end
                        else begin  // No empty slot for evicted FP(homeless) ---> random choose to repeat eviction agian:
                            Row_Position_Reg[1:0] = 2'b10;  // H3(x)   
                            Row_Position_Reg[2] = 1'b0;     // Eviction needed (there is no empty slot for evicted FP).
                            Row_Position_Reg[4:3] = FingerPrint_Reg_value[1:0];  // the next slot to evict will be chosen randomly by FingerPrint_Reg_value[1:0].
                        end
                    end

                end
            end

            INSERT_STEP1: begin
                load_Proseccing_DFF <= 1;
                Processing_DFF_input <= 1;                // processing = 1

                // there is Empty slot:
                if (r_Row_Position_Reg[2] == 1'b1) begin
                    // h1(x) found it:    
                    if (r_Row_Position_Reg[1:0] == 2'b00) begin
                        load_MUXs_Select_Manager_Reg <= 1;
                        MUXs_Select_Manager_Reg_input[3] <= 1'b0;       // refers to Mask_MUX 
                                                                        // the mask generator module get background from h1_memory_value_holder_Reg(64 bit).
                        MUXs_Select_Manager_Reg_input[1:0] <= 2'b00;    // refers to Add_Mux
                                                                        // insert the FP(x) in h1(x) target bucket

                        MUXs_Select_Manager_Reg_input[2] <= 1'b0;       // FP_Mux_sel = 0    ==> FP from FP(x) Module 
                                                                        // it's gonna insert target FP with h1; so we need it FP from FP module
                                                                        // mask_generator module use target FP stencil; so don't ruin Reg_FP value.
                        load_mem_Address_Reg <= 1;
                    end
                    // h2(x) found it:
                    else if (r_Row_Position_Reg[1:0] == 2'b01) begin
                        load_MUXs_Select_Manager_Reg <= 1;
                        MUXs_Select_Manager_Reg_input[3] <= 1'b1;       // refers to Mask_MUX 
                                                                        // the mask generator module get background from temp_mem_value_Reg(64 bit).
                        MUXs_Select_Manager_Reg_input[1:0] <= 2'b01;    // refers to Add_Mux
                                                                        // insert the FP(x) in h2(x) target bucket
                        MUXs_Select_Manager_Reg_input[2] <= 1'b0;       // FP_Mux_sel = 0    ==> FP from FP(x) Module 
                                                                        // it's gonna insert target FP with h2; so we need it FP from FP module
                                                                        // mask_generator module use target FP stencil; so don't ruin Reg_FP value.
                        load_mem_Address_Reg <= 1;
                    end
                    // h3(x) found the empty slot for evicted FP(x):
                    else if (r_Row_Position_Reg[1:0] == 2'b10) begin
                        load_MUXs_Select_Manager_Reg <= 1;
                        MUXs_Select_Manager_Reg_input[3] <= 1'b1;       // refers to Mask_MUX 
                                                                        // the mask generator module get background from temp_mem_value_Reg(64 bit).
                        MUXs_Select_Manager_Reg_input[1:0] <= 2'b10;    // refers to add_mux_sel
                                                                        // insert the evicted FP(x) in h3(x) target bucket
                        MUXs_Select_Manager_Reg_input[2] <= 1'b0;       // FP_Mux_sel = 0    ==> FP from FP(x) Module 
                                                                        // the last time FP_Mux_sel was 1, and Reg_FP got evicted to lookup for and use it as stencil for mask_generator. 
                                                                        // it doesn't matter what is MUXs_Select_Manager_Reg_input[2] value, as long as load_Reg_FP is 0;
                                                                        // so give it 1'b0 or 1'b1; there is no difference. after this insert, MUXs_Select_Manager_Reg will be reset(by reset_to_DP).
                        load_mem_Address_Reg <= 1;
                    end

                    load_mask_gen_Reg <= 1;                             // get value from mask generator module
                end

                // there is no empty slot:
                else if (r_Row_Position_Reg[2] == 1'b0) begin
                    // first time; insert target FP with h1(x):
                    if (r_Row_Position_Reg[1:0] == 2'b00) begin
                        load_MUXs_Select_Manager_Reg <= 1;
                        MUXs_Select_Manager_Reg_input[1:0] <= 2'b00;            // refers to add_mux_sel
                                                                                // this hash function(h1(x)) was chosen randomly to target a bucket to evict
                        MUXs_Select_Manager_Reg_input[3] <= 1'b0;               // refers to Mask_MUX 
                                                                                // the mask generator module get background from h1_memory_value_holder_Reg(64 bit).
                        MUXs_Select_Manager_Reg_input[2] <= 1'b0;               // FP_Mux_sel = 0    ==> FP from FP(x) Module  
                                                                                // it's gonna insert target FP with h1; so we need the FP from FP module.
                                                                                // mask_generator module use target FP stencil.
                                                                                // it doesn't matter what is MUXs_Select_Manager_Reg_input[2] value, as long as load_Reg_FP is 0;
                        load_mem_Address_Reg <= 1;
                    end 
                    // first time; insert target FP with h2(x):
                    else if (r_Row_Position_Reg[1:0] == 2'b01) begin
                        load_MUXs_Select_Manager_Reg <= 1;
                        MUXs_Select_Manager_Reg_input[1:0] <= 2'b01;            // refers to add_mux_sel
                                                                                // this hash function(h2(x)) was chosen randomly to target a bucket to evict
                        MUXs_Select_Manager_Reg_input[3] <= 1'b1;               // refers to Mask_MUX 
                                                                                // the mask generator module get background from temp_mem_value_Reg(64 bit).
                        MUXs_Select_Manager_Reg_input[2] <= 1'b0;               // FP_Mux_sel = 0    ==> FP from FP(x) Module  
                                                                                // it's gonna insert target FP with h2; so we need the FP from FP module.
                                                                                // mask_generator module use target FP stencil.
                                                                                // it doesn't matter what is MUXs_Select_Manager_Reg_input[2] value, as long as load_Reg_FP is 0; 
                        load_mem_Address_Reg <= 1;
                    end
                    // next times; insert evicted FP with h3(x):
                    else if (r_Row_Position_Reg[1:0] == 2'b10) begin
                        load_MUXs_Select_Manager_Reg <= 1;
                        MUXs_Select_Manager_Reg_input[1:0] <= 2'b10;            // refers to add_mux_sel
                                                                                // this hash function(h3(x)) was chosen purposely to target a bucket to evict
                        MUXs_Select_Manager_Reg_input[3] <= 1'b1;               // refers to Mask_MUX 
                                                                                // the mask generator module get background from temp_mem_value_Reg(64 bit).
                                                                                // It will get a new evicted(homeless) from mask generator
                                                                                // The last address is from H3(x) ==> (H3 = H3 XOR FP)
                        MUXs_Select_Manager_Reg_input[2] <= 1'b0;               // FP_Mux_sel = 0    ==> FP from FP(x) Module  
                                                                                // it's gonna insert evicted FP with h3; so we need the FP from Reg_FP.
                                                                                // mask_generator module use evicted FP in Reg_FP as stencil.
                                                                                // it doesn't matter what is MUXs_Select_Manager_Reg_input[2] value, as long as load_Reg_FP is 0;  
                                                                                // and in any way when there is no empty slot and there is another evicted FP, MUXs_Select_Manager_Reg_input[2]...
                                                                                // will be 1'b1 in next state with load_Reg_FP <= 1; so it doesn't matter whet is its value for this state.

                        load_mem_Address_Reg <= 0;                              // there is no empty slot so we have homeless(evicted) again and must store its value and new address
                                                                                // don't load mem_address_reg because its current address is from previous H3(x) and current homeless must be written there
                                                                                // if the mem_address_reg be loaded, it gets new H3(x) that it's for new homeless address
                    end  

                    // load_Reg_homeless_evicted <= 1;     // It will get evicted(homeless) from mask generator
                    load_Add_homeless <= 1;             // Get the current address from Mem_Address_reg 
                                                        // (H2(x) = H1(x) XOR FP  / H3(x) = H2(x) XOR FP)
                    load_mask_gen_Reg <= 1;             // get value from mask generator module

                end
            end

            INSERT_STEP2: begin
                load_Proseccing_DFF <= 1;
                Processing_DFF_input <= 1;                // processing = 1

                load_mask_gen_Reg <= 1;                             // get value from mask generator module

                if ((r_Row_Position_Reg[2] == 0) && (r_Row_Position_Reg[1:0] == 2'b10)) begin
                    load_mem_Address_Reg <= 0;      // there is no empty slot so we have homeless(evicted) again and must store its value and new address
                                                    // don't load mem_address_reg because its current address is from previous H3(x) and current homeless must be written there
                                                    // if the mem_address_reg be loaded, it gets new H3(x) that it's for new homeless address
                end
                else begin
                    load_mem_Address_Reg <= 1;      // When we get this state load_mem_Address_Reg will be 1; And next state(INSERT_STEP3) mem_Address_Reg has the right value;
                                                    // So we can give we_write_en <= 1;
                                                    // in the same time that we_write_en get 1, mem_Address_Reg has the right value;
                end
                
                if (r_Row_Position_Reg[2] == 1'b0) begin
                    load_Reg_homeless_evicted <= 1;     // It will get evicted(homeless) from mask generator
                    load_Add_homeless <= 1;             // Get the current address from Mem_Address_reg 
                                                            // (H2(x) = H1(x) XOR FP  / H3(x) = H2(x) XOR FP)

                    MUXs_Select_Manager_Reg_input[1:0] <= 2'b10;        // it refers to add_mux_sel
                                                            // get address from H3(x) to find second bucket address for evicted FP
                    MUXs_Select_Manager_Reg_input[2] <= 1'b1;           // replace Homeless(evicted) as a new FP in Reg_FP
                    MUXs_Select_Manager_Reg_input[3] <= 1'b1;           // refers to Mask_MUX 
                                                                        // the mask generator module get background from temp_mem_value_Reg(64 bit).

                end
            end

            INSERT_STEP3: begin
                load_Proseccing_DFF <= 1;
                Processing_DFF_input <= 1;                // processing = 1

                if (limit_memory_wait_Reg == 8'd2) begin
                    if (r_Row_Position_Reg[2] == 1'b1) begin
                        load_Insert_Done_DFF <= 1;
                        insert_done <= 1;
                    end
                    else if (r_Row_Position_Reg[2] == 1'b0) begin
                        load_MUXs_Select_Manager_Reg <= 1;
                        MUXs_Select_Manager_Reg_input[1:0] <= 2'b10;    // it refers to add_mux_sel
                                                                        // get address from H3(x) to find second bucket address for evicted FP
                        MUXs_Select_Manager_Reg_input[2] <= 1'b1;       // replace Homeless(evicted) as a new FP in Reg_FP
                        // load_Reg_FP <= 1;                               // get the new FP(the homeless)
                                                                        // next state in FP_Reg we have homeless(as new FP) and in mem_Address_Reg we have homeless new address(the second Address).
                                                                        // as we seein this state load_Reg_FP is 1; so MUXs_Select_Manager_Reg_input[2] value is important; unless it doesn't.
                        MUXs_Select_Manager_Reg_input[3] <= 1'b1;       // refers to Mask_MUX 
                                                                        // the mask generator module get background from temp_mem_value_Reg(64 bit). 
                        // load_mem_Address_Reg <= 1;
                    end  
                end
                else begin
                    mem_enable <= 1;
                    we_write_read_en <= 1'b1;  // write Enable will be 1 to write mask (in any way ---> have empty slot or not)
                    load_Add_homeless <= 1;
                end  
            end

            DELETE_STEP1: begin
                load_Proseccing_DFF <= 1;
                Processing_DFF_input <= 1;                // processing = 1

                MUXs_Select_Manager_Reg_input[3] <= 1'b1;               // refers to Mask_MUX 
                                                                        // the mask generator module get background from temp_mem_value_Reg(64 bit).
                load_mask_gen_Reg <= 1;
                mem_enable <= 1;
                we_write_read_en <= 1;

                if (limit_memory_wait_Reg == 8'd2) begin
                    load_Delete_Done_DFF <= 1;
                    delete_done <= 1;
                end
                else;
                    // nothing
            end

            default: begin
                // load
                load_Data_Store_Reg <= 0;
                load_Reg_FP <= 0;
                load_Reg_H1 <= 0;
                load_mem_Address_Reg <= 0; 
                load_temp_mem_value_Reg <= 0;
                load_h1_memory_value_holder_Reg <= 0;
                load_Comp_FP_mem_Reg <= 0;
                load_empty_slot_check_result_Reg <= 0;
                load_Lookup_result_DFF <= 0;
                load_Insert_Done_DFF <= 0;
                load_Delete_Done_DFF <= 0;
                load_Proseccing_DFF <= 1;
                load_MUXs_Select_Manager_Reg <= 0;
                load_mask_gen_Reg <= 0;
                load_Reg_homeless_evicted <= 0;
                load_Add_homeless <= 0;


                lookup_result <= 0;
                insert_done <= 0;
                delete_done <= 0;
                Processing_DFF_input <= 1;

                r_Row_Position_Reg <= r_Row_Position_Reg;

                reset_to_DP <= 0;
                attach_location <= r_Row_Position_Reg[4:3];

                // below code-line is wrong! don't use this command it will loop. because each time that always block will be run
                // MUXs_Select_Manager_Reg_input value will be 4'b1_0_00.
                // MUXs_Select_Manager_Reg_input <= 4'b1_0_00;     // Add_Mux_sel = 00  ==> h1(x)
                                                                // FP_Mux_sel = 0    ==> FP from FP(x) Module
                                                                // Mask_Mux = 1      ==> Get Background from temp_mem_value_Reg 

                mem_enable <= 0;
                we_write_read_en <= 0;
            end
        endcase

    end


    // each time FP Register get a new value it means an eviction happen
    always @(Processing_DFF_output or  load_Reg_homeless_evicted) begin
        if (Processing_DFF_output == 0) begin
            limit_loop_Reg <= 0;
        end
        if (load_Reg_homeless_evicted == 1) begin
            limit_loop_Reg <= r_limit_loop_Reg  + 1;
        end
    end

    // a limitation for Memory waiting
    always @(posedge clk) begin
        // if Memory waiting is done, reset limit_memory_wait_Reg to be ready for another Memory operation
        if(limit_memory_wait_Reg == 8'd2) begin
            limit_memory_wait_Reg <= 8'b0;
        end
        // if filter is waiting ---> count time of waiting with limit_memory_wait_Reg
        else if (mem_enable == 1'b1) begin
            limit_memory_wait_Reg <= limit_memory_wait_Reg + 1;
        end
        else 
            limit_memory_wait_Reg <= 0;
        
    end

    // a counter to wait for hash multiplier pipline (6 stage)
    always @(posedge clk) begin
        if (counter_hash_pipline == 8'd6)
            counter_hash_pipline = 8'b0;
        else if ((load_Reg_FP == 1) || (load_Reg_H1 == 1))
            counter_hash_pipline = counter_hash_pipline + 1;
        else
            counter_hash_pipline = 8'b0;
    end

    always @(posedge clk) begin
        if (r_limit_loop_Reg == 16'd501) begin
            filter_is_full <= 1;
        end
        else begin
            filter_is_full <= 0;
        end

    end

endmodule




