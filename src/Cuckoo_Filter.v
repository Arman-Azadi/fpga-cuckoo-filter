module Cuckoo_Filter (
    // Inputs
    input clock,                   // Clock signal
    input reset,                   // Reset signal
    input [31:0] Data_in,          // 32-bit input data
    input Lookup_En,               // Lookup enable signal
    input Insert_En,               // Insert enable signal
    input Delete_En,               // Delete enable signal
    input [15:0] FP_Fixed_Coefficient_Reg_input_16bit,
    input [31:0] Hash_Index1_Fixed_Coefficient_Reg_input_32bit,
    input [31:0] Hash_Index2_Fixed_Coefficient_Reg_input_32bit,
    input [63:0] Mem_Read_Data,    // 64-bit memory read data

    input load_FP_Fixed_Coefficient_Reg,
    input load_Hash_Index1_Fixed_Coefficient_Reg,
    input load_Hash_Index2_Fixed_Coefficient_Reg,

    // Outputs
    output Lookup_Result,           // Lookup result signal
    output Insert_Done,             // Insert done signal
    output Delete_Done,             // Delete done signal
    output Processing,              // Processing signal
    output Filter_is_Full,          // when eviction get maximum atempt
    output Mem_Enable,             // Memory read enable signal
    output Mem_Write_Read_En,            // Memory write enable signal
    output [63:0] Mem_Write_Data,   // 64-bit memory write data
    output [15:0] Mem_Address       // 16-bit memory address
);

    // wires ---> between data_path & main module (Cuckoo_Filter)
        // data_path to main module
        wire [63:0] mem_write_data_DP_2_CF;
        wire [15:0] mem_address_DP_2_CF; 

        wire Lookup_result_DFF_output_DP_2_CF;
        wire Insert_Done_DFF_output_DP_2_CF;
        wire Delete_Done_DFF_output_DP_2_CF;
        wire Proseccing_DFF_output_DP_2_CF;

        // main module to data_path
        wire clock_CF_2_DP;
        wire [31:0] data_in_CF_2_DP;
        wire insert_en_CF_2_DP;
        wire delete_en_CF_2_DP;
        wire [15:0] FP_Fixed_Coefficient_Reg_input_16bit_CF_2_DP;
        wire [31:0] Hash_Index1_Fixed_Coefficient_Reg_input_32bit_CF_2_DP;
        wire [31:0] Hash_Index2_Fixed_Coefficient_Reg_input_32bit_CF_2_DP;
        wire load_FP_Fixed_Coefficient_Reg_CF_2_DP;
        wire load_Hash_Index1_Fixed_Coefficient_Reg_CF_2_DP;
        wire load_Hash_Index2_Fixed_Coefficient_Reg_CF_2_DP;
        wire [63:0] mem_read_data_CF_2_DP;

    // wires ---> between controller & main module (Cuckoo_Filter)
        // controller to main module
        wire mem_enable_Ctrl_2_CF;
        wire we_write_read_en_Ctrl_2_CF;
        wire filter_is_full_signal_Ctrl_2_CF;

        // main module to controller
        wire clock_CF_2_Ctrl;
        wire reset_main_CF_2_Ctrl;
        wire lookup_en_CF_2_Ctrl;
        wire insert_en_CF_2_Ctrl;
        wire delete_en_CF_2_Ctrl;


    // wires ---> between controller & data_path
        // data_path to controller
        wire [3:0] Comp_FP_mem_Reg_out_DP_2_Ctrl;
        wire [3:0] Empty_Slot_Check_Result_Reg_out_DP_2_Ctrl;
        wire [15:0] FingerPrint_Reg_value_out_DP_2_Ctrl;
        // Reg_homeless_evicted_value_out_DP_2_Ctrl

        wire Proseccing_DFF_output_DP_2_Ctrl;

        wire [3:0] MUXs_Select_Manager_Reg_output_2ctlr_DP_2_Ctrl;
        
        // controller  to data_path
        wire lookup_result_Ctrl_2_DP;
        wire insert_done_Ctrl_2_DP;
        wire delete_done_Ctrl_2_DP;
        wire Processing_DFF_input_Ctrl_2_DP;

        wire load_Data_Store_Reg_Ctrl_2_DP;
        wire load_Reg_H1_Ctrl_2_DP;
        wire load_Reg_FP_Ctrl_2_DP;
        wire load_mem_Address_Reg_Ctrl_2_DP;
        wire load_temp_mem_value_Reg_Ctrl_2_DP;
        wire load_h1_memory_value_holder_Reg_Ctrl_2_DP;
        wire load_Comp_FP_mem_Reg_Ctrl_2_DP;
        wire load_empty_slot_check_result_Reg_Ctrl_2_DP;
        wire load_Lookup_result_DFF_Ctrl_2_DP;
        wire load_Insert_Done_DFF_Ctrl_2_DP;
        wire load_Delete_Done_DFF_Ctrl_2_DP;
        wire load_Proseccing_DFF_Ctrl_2_DP;
        wire load_MUXs_Select_Manager_Reg_Ctrl_2_DP;
        wire load_mask_gen_Reg_Ctrl_2_DP;
        wire load_Reg_homeless_evicted_Ctrl_2_DP;
        wire load_Add_homeless_Ctrl_2_DP;

        wire [3:0] MUXs_Select_Manager_Reg_input_Ctrl_2_DP;
        wire [1:0] attach_location_Ctrl_2_DP;
        wire reset_to_DP_Ctrl_2_DP;

    
    // assign main module (input/output) signal wires
    assign clock_CF_2_DP = clock;        // clock
    assign clock_CF_2_Ctrl = clock;      // clock
    assign reset_main_CF_2_Ctrl = reset;
    assign data_in_CF_2_DP = Data_in;
    assign lookup_en_CF_2_Ctrl = Lookup_En;
    assign insert_en_CF_2_DP = Insert_En;     // insert_en
    assign insert_en_CF_2_Ctrl = Insert_En;   // insert_en
    assign delete_en_CF_2_DP = Delete_En;       // delete_en
    assign delete_en_CF_2_Ctrl = Delete_En;     // delete_en
    assign mem_read_data_CF_2_DP = Mem_Read_Data;

    assign FP_Fixed_Coefficient_Reg_input_16bit_CF_2_DP = FP_Fixed_Coefficient_Reg_input_16bit;
    assign Hash_Index1_Fixed_Coefficient_Reg_input_32bit_CF_2_DP = Hash_Index1_Fixed_Coefficient_Reg_input_32bit;
    assign Hash_Index2_Fixed_Coefficient_Reg_input_32bit_CF_2_DP = Hash_Index2_Fixed_Coefficient_Reg_input_32bit;
    assign load_FP_Fixed_Coefficient_Reg_CF_2_DP = load_FP_Fixed_Coefficient_Reg;
    assign load_Hash_Index1_Fixed_Coefficient_Reg_CF_2_DP = load_Hash_Index1_Fixed_Coefficient_Reg;
    assign load_Hash_Index2_Fixed_Coefficient_Reg_CF_2_DP = load_Hash_Index2_Fixed_Coefficient_Reg;

    assign Lookup_Result = Lookup_result_DFF_output_DP_2_CF;
    assign Insert_Done = Insert_Done_DFF_output_DP_2_CF;
    assign Delete_Done = Delete_Done_DFF_output_DP_2_CF;
    assign Processing = Proseccing_DFF_output_DP_2_CF;
    assign Filter_is_Full = filter_is_full_signal_Ctrl_2_CF;
    assign Mem_Enable = mem_enable_Ctrl_2_CF;
    assign Mem_Write_Read_En = we_write_read_en_Ctrl_2_CF;
    assign Mem_Write_Data = mem_write_data_DP_2_CF;
    assign Mem_Address = mem_address_DP_2_CF;

    // assign Proseccing_DFF_output wire
    assign Proseccing_DFF_output_DP_2_Ctrl = Proseccing_DFF_output_DP_2_CF;


    data_path CF_Data_Path (
        .clk(clock_CF_2_DP),
        .reset(reset_to_DP_Ctrl_2_DP),
        .data_in(data_in_CF_2_DP),
        .insert_en(insert_en_CF_2_DP),
        .delete_en(delete_en_CF_2_DP),
        .FP_Fixed_Coefficient_Reg_input_16bit(FP_Fixed_Coefficient_Reg_input_16bit_CF_2_DP),
        .Hash_Index1_Fixed_Coefficient_Reg_input_32bit(Hash_Index1_Fixed_Coefficient_Reg_input_32bit_CF_2_DP),
        .Hash_Index2_Fixed_Coefficient_Reg_input_32bit(Hash_Index2_Fixed_Coefficient_Reg_input_32bit_CF_2_DP),
        .mem_read_data(mem_read_data_CF_2_DP),
        .attach_location(attach_location_Ctrl_2_DP),

        .load_FP_Fixed_Coefficient_Reg(load_FP_Fixed_Coefficient_Reg_CF_2_DP),
        .load_Hash_Index1_Fixed_Coefficient_Reg(load_Hash_Index1_Fixed_Coefficient_Reg_CF_2_DP),
        .load_Hash_Index2_Fixed_Coefficient_Reg(load_Hash_Index2_Fixed_Coefficient_Reg_CF_2_DP),

        .load_Data_Store_Reg(load_Data_Store_Reg_Ctrl_2_DP),
        .load_Reg_H1(load_Reg_H1_Ctrl_2_DP),
        .load_Reg_FP(load_Reg_FP_Ctrl_2_DP),
        .load_mem_Address_Reg(load_mem_Address_Reg_Ctrl_2_DP),
        .load_temp_mem_value_Reg(load_temp_mem_value_Reg_Ctrl_2_DP),
        .load_h1_memory_value_holder_Reg(load_h1_memory_value_holder_Reg_Ctrl_2_DP),
        .load_Comp_FP_mem_Reg(load_Comp_FP_mem_Reg_Ctrl_2_DP),
        .load_empty_slot_check_result_Reg(load_empty_slot_check_result_Reg_Ctrl_2_DP),
        .load_Lookup_result_DFF(load_Lookup_result_DFF_Ctrl_2_DP),
        .load_Insert_Done_DFF(load_Insert_Done_DFF_Ctrl_2_DP),
        .load_Delete_Done_DFF(load_Delete_Done_DFF_Ctrl_2_DP),
        .load_Proseccing_DFF(load_Proseccing_DFF_Ctrl_2_DP),
        .load_MUXs_Select_Manager_Reg(load_MUXs_Select_Manager_Reg_Ctrl_2_DP),
        .load_mask_gen_Reg(load_mask_gen_Reg_Ctrl_2_DP),
        .load_Reg_homeless_evicted(load_Reg_homeless_evicted_Ctrl_2_DP),
        .load_Add_homeless(load_Add_homeless_Ctrl_2_DP),

        .Lookup_result_DFF_input(lookup_result_Ctrl_2_DP),
        .Insert_Done_DFF_input(insert_done_Ctrl_2_DP),
        .Delete_Done_DFF_input(delete_done_Ctrl_2_DP),
        .Proseccing_DFF_input(Processing_DFF_input_Ctrl_2_DP),

        .MUXs_Select_Manager_Reg_input(MUXs_Select_Manager_Reg_input_Ctrl_2_DP),

        .mem_write_data(mem_write_data_DP_2_CF),
        .mem_address(mem_address_DP_2_CF),
        .Comp_FP_mem_Reg_out(Comp_FP_mem_Reg_out_DP_2_Ctrl),
        .Empty_Slot_Check_Result_Reg_out(Empty_Slot_Check_Result_Reg_out_DP_2_Ctrl),
        .FingerPrint_Reg_value_out(FingerPrint_Reg_value_out_DP_2_Ctrl),

        .Lookup_result_DFF_output(Lookup_result_DFF_output_DP_2_CF),
        .Insert_Done_DFF_output(Insert_Done_DFF_output_DP_2_CF),
        .Delete_Done_DFF_output(Delete_Done_DFF_output_DP_2_CF),        // there is an assign experssion above
                                                                        // assign Proseccing_DFF_output_DP_2_Ctrl = Proseccing_DFF_output_DP_2_CF;
        .Proseccing_DFF_output(Proseccing_DFF_output_DP_2_CF),

        .MUXs_Select_Manager_Reg_output_2ctlr(MUXs_Select_Manager_Reg_output_2ctlr_DP_2_Ctrl)
    );

    controller CF_Controller (
        .clk(clock_CF_2_Ctrl),
        .reset_main(reset_main_CF_2_Ctrl),
        .lookup_en(lookup_en_CF_2_Ctrl),
        .insert_en(insert_en_CF_2_Ctrl),
        .delete_en(delete_en_CF_2_Ctrl),
        .Comp_FP_mem_Reg_result(Comp_FP_mem_Reg_out_DP_2_Ctrl),
        .Empty_Slot_Check_Result_Reg_out_result(Empty_Slot_Check_Result_Reg_out_DP_2_Ctrl),
        .FingerPrint_Reg_value(FingerPrint_Reg_value_out_DP_2_Ctrl),

        .Processing_DFF_output(Proseccing_DFF_output_DP_2_Ctrl),
        .MUXs_Select_Manager_Reg_output_from_DataPath(MUXs_Select_Manager_Reg_output_2ctlr_DP_2_Ctrl),

        .mem_enable(mem_enable_Ctrl_2_CF),
        .we_write_read_en(we_write_read_en_Ctrl_2_CF),

        .lookup_result(lookup_result_Ctrl_2_DP),
        .insert_done(insert_done_Ctrl_2_DP),
        .delete_done(delete_done_Ctrl_2_DP),
        .Processing_DFF_input(Processing_DFF_input_Ctrl_2_DP),

        .load_Data_Store_Reg(load_Data_Store_Reg_Ctrl_2_DP),
        .load_Reg_H1(load_Reg_H1_Ctrl_2_DP),
        .load_Reg_FP(load_Reg_FP_Ctrl_2_DP),
        .load_mem_Address_Reg(load_mem_Address_Reg_Ctrl_2_DP),
        .load_temp_mem_value_Reg(load_temp_mem_value_Reg_Ctrl_2_DP),
        .load_h1_memory_value_holder_Reg(load_h1_memory_value_holder_Reg_Ctrl_2_DP),
        .load_Comp_FP_mem_Reg(load_Comp_FP_mem_Reg_Ctrl_2_DP),
        .load_empty_slot_check_result_Reg(load_empty_slot_check_result_Reg_Ctrl_2_DP),
        .load_Lookup_result_DFF(load_Lookup_result_DFF_Ctrl_2_DP),
        .load_Insert_Done_DFF(load_Insert_Done_DFF_Ctrl_2_DP),
        .load_Delete_Done_DFF(load_Delete_Done_DFF_Ctrl_2_DP),
        .load_Proseccing_DFF(load_Proseccing_DFF_Ctrl_2_DP),
        .load_MUXs_Select_Manager_Reg(load_MUXs_Select_Manager_Reg_Ctrl_2_DP),
        .load_mask_gen_Reg(load_mask_gen_Reg_Ctrl_2_DP),
        .load_Reg_homeless_evicted(load_Reg_homeless_evicted_Ctrl_2_DP),
        .load_Add_homeless(load_Add_homeless_Ctrl_2_DP),

        .MUXs_Select_Manager_Reg_input(MUXs_Select_Manager_Reg_input_Ctrl_2_DP),
        .attach_location(attach_location_Ctrl_2_DP),
        .reset_to_DP(reset_to_DP_Ctrl_2_DP),
        .filter_is_full(filter_is_full_signal_Ctrl_2_CF)
    );

endmodule

