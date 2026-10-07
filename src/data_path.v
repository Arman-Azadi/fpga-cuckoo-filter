module data_path (
    input clk,                           // Clock pulse
    input reset,                         // A General reset for all Registers from Controller
    input [31:0] data_in,                // x(input)
    input insert_en,                     // Enable signal to command mask generator what to do
    input delete_en,                     // Enable signal to command mask generator what to do
    input [15:0] FP_Fixed_Coefficient_Reg_input_16bit,
    input [31:0] Hash_Index1_Fixed_Coefficient_Reg_input_32bit,
    input [31:0] Hash_Index2_Fixed_Coefficient_Reg_input_32bit,
    input [63:0] mem_read_data,          // Read Data from Memory
    input [1:0] attach_location,         // Input from Controller (Row_Position_Reg[4:3]); It will be used by mask generator

    input load_FP_Fixed_Coefficient_Reg,
    input load_Hash_Index1_Fixed_Coefficient_Reg,
    input load_Hash_Index2_Fixed_Coefficient_Reg,

    input load_Data_Store_Reg,
    input load_Reg_H1,
    input load_Reg_FP,
    input load_mem_Address_Reg,
    input load_temp_mem_value_Reg,
    input load_h1_memory_value_holder_Reg,   
    input load_Comp_FP_mem_Reg,
    input load_empty_slot_check_result_Reg,  
    input load_Lookup_result_DFF,            
    input load_Insert_Done_DFF,              
    input load_Delete_Done_DFF,              
    input load_Proseccing_DFF,
    input load_MUXs_Select_Manager_Reg,       
    input load_mask_gen_Reg,
    input load_Reg_homeless_evicted,
    input load_Add_homeless,
    

    input Lookup_result_DFF_input,    // input from Controller 
    input Insert_Done_DFF_input,      // input from Controller 
    input Delete_Done_DFF_input,      // input from Controller 
    input Proseccing_DFF_input,       // input from Controller 

    input [3:0] MUXs_Select_Manager_Reg_input,       // input from Controller comes to control MUXs select

    output [63:0] mem_write_data,                    // Write Data to Memory
    output [15:0] mem_address,                       // Address to Memory
    output [3:0]  Comp_FP_mem_Reg_out,               // Output of Information and Control Reg to Controller
    output [3:0]  Empty_Slot_Check_Result_Reg_out,   // Output of Information and Control Reg to Controller
    output [15:0] FingerPrint_Reg_value_out,         // to determine random values

    output Lookup_result_DFF_output,     // output to Cuckoo-Filter module
    output Insert_Done_DFF_output,       // output to Cuckoo-Filter module
    output Delete_Done_DFF_output,       // output to Cuckoo-Filter module
    output Proseccing_DFF_output,        // output to Controller and output to Cuckoo-Filter module
    
    output [3:0] MUXs_Select_Manager_Reg_output_2ctlr  // output to Controller (and to data-path MUXs by a wire)
);

    // wire
    wire [31:0] Data_Store_Reg_out;
    wire [15:0] Reg_H1_out;
    wire [15:0] Reg_FP_out;
    wire [15:0] mem_Address_Reg_out;
    wire [63:0] temp_mem_value_Reg_out;
    wire [63:0] h1_memory_value_holder_Reg_out;    // ****
    wire [63:0] mask_gen_Reg_out;
    wire [15:0] Reg_homeless_evicted_out;
    wire [15:0] Add_homeless_Reg_out;
    wire [15:0] FP_mux_2to1_out;
    wire [15:0] Add_mux_4to1_out;
    wire [63:0] Mask_mux_2to1_out;                 // ****
    wire [15:0] fingerprint_hash_out;
    wire [15:0] hash_index1_out;
    wire [15:0] hash_index2_out;
    wire [3:0]  compare_FP_mem_out;
    wire [3:0]  Empty_Slot_Check_Module_out;
    wire [63:0] mask_out;
    wire [15:0] mask_evicted_out;
    wire [15:0] hash_index3_out;
    wire [3:0]  MUXs_Select_Manager_Reg_out;
    wire [15:0] FP_Fixed_Coefficient_Reg_out;
    wire [31:0] Hash_Index1_Fixed_Coefficient_Reg_out;
    wire [31:0] Hash_Index2_Fixed_Coefficient_Reg_out;
    

    // $
    // Data Store Reg
    register #(.WIDTH(32)) Data_Store_Reg (
        .clk(clk), .reset(1'b0), .en(1'b1), .load(load_Data_Store_Reg),
        .data_in(data_in), .data_out(Data_Store_Reg_out)
    );

    // $
    // Reg H1(x)
    register #(.WIDTH(16)) Reg_H1 (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_Reg_H1),
        .data_in(hash_index1_out), .data_out(Reg_H1_out)
    );

    // $
    // Reg FP(x)
    register #(.WIDTH(16)) Reg_FP (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_Reg_FP),
        .data_in(FP_mux_2to1_out), .data_out(Reg_FP_out)
    );
    assign FingerPrint_Reg_value_out = Reg_FP_out;

    // $
    // Mem Add Reg 
    register #(.WIDTH(16)) mem_Address_Reg (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_mem_Address_Reg),
        .data_in(Add_mux_4to1_out), .data_out(mem_Address_Reg_out)
    );
    assign mem_address = mem_Address_Reg_out;

    // $
    // temp mem value Reg
    register #(.WIDTH(64)) temp_mem_value_Reg (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_temp_mem_value_Reg),
        .data_in(mem_read_data), .data_out(temp_mem_value_Reg_out)
    );

    // $
    // h1 memory value holder Reg
    register #(.WIDTH(64)) h1_memory_value_holder_Reg (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_h1_memory_value_holder_Reg),
        .data_in(mem_read_data), .data_out(h1_memory_value_holder_Reg_out)
    );

    // $
    // Comp FP-mem Reg
    register #(.WIDTH(4)) Comp_FP_mem_Reg (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_Comp_FP_mem_Reg),
        .data_in(compare_FP_mem_out), .data_out(Comp_FP_mem_Reg_out)
    );

    // $
    // empty slot check result Reg
    register #(.WIDTH(4)) empty_slot_check_result_Reg (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_empty_slot_check_result_Reg),
        .data_in(Empty_Slot_Check_Module_out), .data_out(Empty_Slot_Check_Result_Reg_out)
    );

    // $
    // Lookup Result D_Flip_Flop
    d_flip_flop Lookup_result_DFF(
        .clk(clk),
        .reset(reset),
        .load(load_Lookup_result_DFF),
        .d(Lookup_result_DFF_input),
        .q(Lookup_result_DFF_output)
    );

    // $
    // Insert Done D_Flip_Flop
    d_flip_flop Insert_Done_DFF(
        .clk(clk),
        .reset(reset),
        .load(load_Insert_Done_DFF),
        .d(Insert_Done_DFF_input),
        .q(Insert_Done_DFF_output)
    );

    // $
    // Delete Done D_Flip_Flop
    d_flip_flop Delete_Done_DFF(
        .clk(clk),
        .reset(reset),
        .load(load_Delete_Done_DFF),
        .d(Delete_Done_DFF_input),
        .q(Delete_Done_DFF_output)
    );

    // $
    // Processing D_Flip_Flop
    d_flip_flop Proseccing_DFF(
        .clk(clk),
        .reset(reset),
        .load(load_Proseccing_DFF),
        .d(Proseccing_DFF_input),
        .q(Proseccing_DFF_output)
    );

    // $
    // MUXs Select Manager Reg
    register #(.WIDTH(4)) MUXs_Select_Manager_Reg (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_MUXs_Select_Manager_Reg),
        .data_in(MUXs_Select_Manager_Reg_input), .data_out(MUXs_Select_Manager_Reg_out)
    );
    assign MUXs_Select_Manager_Reg_output_2ctlr = MUXs_Select_Manager_Reg_out;

    // $
    // mask_gen_Reg
    register #(.WIDTH(64)) mask_gen_Reg (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_mask_gen_Reg),
        .data_in(mask_out), .data_out(mask_gen_Reg_out)
    );
    assign mem_write_data = mask_gen_Reg_out;

    // $
    // Reg_homeless(evicted)
    register #(.WIDTH(16)) Reg_homeless_evicted (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_Reg_homeless_evicted),
        .data_in(mask_evicted_out), .data_out(Reg_homeless_evicted_out)
    );

    // $
    // Add_homeless_Reg (Hash)
    register #(.WIDTH(16)) Add_homeless_Reg (
        .clk(clk), .reset(reset), .en(1'b1), .load(load_Add_homeless),
        .data_in(mem_Address_Reg_out), .data_out(Add_homeless_Reg_out)
    );

    // FP_Fixed_Coefficient Register 16bit
    register #(.WIDTH(16)) FP_Fixed_Coefficient_Reg(
        .clk(clk), .reset(1'b0), .en(1'b1), .load(load_FP_Fixed_Coefficient_Reg),
        .data_in(FP_Fixed_Coefficient_Reg_input_16bit), .data_out(FP_Fixed_Coefficient_Reg_out)
    );

    // Hash_Index1_Fixed_Coefficient Register 32bit
    register #(.WIDTH(32)) Hash_Index1_Fixed_Coefficient_Reg(
        .clk(clk), .reset(1'b0), .en(1'b1), .load(load_Hash_Index1_Fixed_Coefficient_Reg),
        .data_in(Hash_Index1_Fixed_Coefficient_Reg_input_32bit), .data_out(Hash_Index1_Fixed_Coefficient_Reg_out)
    );

    // Hash_Index2_Fixed_Coefficient Register 32bit
    register #(.WIDTH(32)) Hash_Index2_Fixed_Coefficient_Reg(
        .clk(clk), .reset(1'b0), .en(1'b1), .load(load_Hash_Index2_Fixed_Coefficient_Reg),
        .data_in(Hash_Index2_Fixed_Coefficient_Reg_input_32bit), .data_out(Hash_Index2_Fixed_Coefficient_Reg_out)
    );

    // $
    // FP Mux (FingerPrint Multiplexer)
    mux_2to1 #(.N(16)) FP_mux_2to1_inst (
        .in0(fingerprint_hash_out),
        .in1(Reg_homeless_evicted_out), 
        .sel(MUXs_Select_Manager_Reg_out[2]),
        .out(FP_mux_2to1_out)
    );

    // $
    // Add Mux (Address Multiplexer)
    mux_4to1 #(.N(16)) mux_4to1_inst (
        .in0(hash_index1_out),
        .in1(hash_index2_out),
        .in2(hash_index3_out),
        .in3(16'b0000_0000_0000_0000),     
        .sel(MUXs_Select_Manager_Reg_out[1:0]),
        .out(Add_mux_4to1_out)
    );

    // $
    // Mask Mux (Mask generator(background input) Multiplexer)
    mux_2to1 #(.N(64)) Mask_mux_2to1_inst (
        .in0(h1_memory_value_holder_Reg_out),
        .in1(temp_mem_value_Reg_out), 
        .sel(MUXs_Select_Manager_Reg_out[3]),
        .out(Mask_mux_2to1_out)
    );

    // $
    // fingerprint_hash
    fingerprint_hash fingerprint_inst (
        .clk(clk),
        .data_in(Data_Store_Reg_out),
        .Fixed_Coefficient(FP_Fixed_Coefficient_Reg_out),
        .fingerprint(fingerprint_hash_out)
    );

    // $
    // hash_index1
    hash_index1 hash_index1_inst (
        .clk(clk),
        .data_in(Data_Store_Reg_out),
        .Fixed_Coefficient(Hash_Index1_Fixed_Coefficient_Reg_out),
        .index1(hash_index1_out)
    );

    // $
    // hash_index2
    hash_index2 hash_index2_inst (
        .clk(clk),
        .index1(Reg_H1_out),
        .fingerprint(Reg_FP_out),
        .Fixed_Coefficient(Hash_Index2_Fixed_Coefficient_Reg_out),
        .index2(hash_index2_out)
    );

    // $
    // compare_FP_mem
    big_comparator compare_FP_mem (
        .num1(Reg_FP_out),
        .num2(temp_mem_value_Reg_out),
        .equal_bits(compare_FP_mem_out)
    );

    // $
    // Empty Slot Check Module
    empty_slot_check Empty_Slot_Check(
        .data_in(temp_mem_value_Reg_out),
        .slot_status(Empty_Slot_Check_Module_out)
    );

    // $
    // mask_generator
    mask_generator mask_generator_inst (
        .stencil(Reg_FP_out),
        .background(Mask_mux_2to1_out),
        .insert_en(insert_en),
        .delete_en(delete_en),
        .attach_location(attach_location),
        .mask_out(mask_out),
        .evicted(mask_evicted_out)
    );

    // $
    // hash_index3_inst
    hash_index2 hash_index3_inst (
        .clk(clk),
        .index1(Add_homeless_Reg_out),      
        .fingerprint(Reg_homeless_evicted_out), 
        .Fixed_Coefficient(Hash_Index2_Fixed_Coefficient_Reg_out),
        .index2(hash_index3_out)               
    );

endmodule



