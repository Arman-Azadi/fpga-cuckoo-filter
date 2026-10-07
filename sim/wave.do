onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 30 System_tb
add wave -noupdate -radix unsigned /System_tb/Clock
add wave -noupdate -radix unsigned /System_tb/Reset
add wave -noupdate -radix unsigned /System_tb/Data_in
add wave -noupdate -radix unsigned /System_tb/Lookup_En
add wave -noupdate -radix unsigned /System_tb/Insert_En
add wave -noupdate -radix unsigned /System_tb/Delete_En
add wave -noupdate -radix unsigned /System_tb/Lookup_Result
add wave -noupdate -radix unsigned /System_tb/Insert_Done
add wave -noupdate -radix unsigned /System_tb/Delete_Done
add wave -noupdate -radix unsigned /System_tb/Processing
add wave -noupdate /System_tb/system/CF/Filter_is_Full
add wave -noupdate -divider -height 30 {Important Signals}
add wave -noupdate -divider <NULL>
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/present_state
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/next_state
add wave -noupdate -radix binary /System_tb/system/CF/CF_Controller/Row_Position_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Data_Store_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_mem_Address_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_temp_mem_value_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_h1_memory_value_holder_Reg
add wave -noupdate -radix binary /System_tb/system/CF/CF_Controller/MUXs_Select_Manager_Reg_output_from_DataPath
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Add_homeless
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Reg_homeless_evicted
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/limit_loop_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/limit_memory_wait_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Reg_FP
add wave -noupdate /System_tb/system/CF/CF_Controller/counter_hash_pipline
add wave -noupdate -divider <NULL>
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Data_Store_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Data_Store_Reg/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Data_Store_Reg/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_FP_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_H1_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/fingerprint_hash_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index1_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index2_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index3_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_Address_Reg_out
add wave -noupdate -radix hexadecimal /System_tb/system/CF/CF_Data_Path/temp_mem_value_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/h1_memory_value_holder_Reg_out
add wave -noupdate -radix binary /System_tb/system/CF/CF_Data_Path/Comp_FP_mem_Reg_out
add wave -noupdate -radix binary /System_tb/system/CF/CF_Data_Path/empty_slot_check_result_Reg/data_out
add wave -noupdate -radix hexadecimal /System_tb/system/CF/CF_Data_Path/mask_gen_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_generator_inst/stencil
add wave -noupdate -radix hexadecimal /System_tb/system/CF/CF_Data_Path/mask_generator_inst/background
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_generator_inst/attach_location
add wave -noupdate -radix binary /System_tb/system/CF/CF_Data_Path/MUXs_Select_Manager_Reg_out
add wave -noupdate -divider -height 30 Memory
add wave -noupdate /System_tb/system/MEMORY/rsta
add wave -noupdate /System_tb/system/MEMORY/rsta_busy
add wave -noupdate /System_tb/system/MEMORY/ena
add wave -noupdate /System_tb/system/MEMORY/wea
add wave -noupdate -radix unsigned /System_tb/system/MEMORY/addra
add wave -noupdate /System_tb/system/MEMORY/dina
add wave -noupdate -radix unsigned /System_tb/system/MEMORY/douta
add wave -noupdate -divider -height 30 {New Divider}
add wave -noupdate -radix unsigned /System_tb/i
add wave -noupdate -radix unsigned /System_tb/mem_index
add wave -noupdate -divider -height 30 System
add wave -noupdate -radix unsigned /System_tb/system/Clock
add wave -noupdate -radix unsigned /System_tb/system/Reset
add wave -noupdate -radix unsigned /System_tb/system/Data_in
add wave -noupdate -radix unsigned /System_tb/system/Lookup_En
add wave -noupdate -radix unsigned /System_tb/system/Insert_En
add wave -noupdate -radix unsigned /System_tb/system/Delete_En
add wave -noupdate -radix unsigned /System_tb/system/Lookup_Result
add wave -noupdate -radix unsigned /System_tb/system/Insert_Done
add wave -noupdate -radix unsigned /System_tb/system/Delete_Done
add wave -noupdate -radix unsigned /System_tb/system/Processing
add wave -noupdate -radix unsigned /System_tb/system/write_data_CF_2_Mem
add wave -noupdate -radix unsigned /System_tb/system/mem_address_CF_2_Mem
add wave -noupdate -radix hexadecimal /System_tb/system/read_data_Mem_2_CF
add wave -noupdate -divider -height 30 {CF (Cuckoo Filter)}
add wave -noupdate -radix unsigned /System_tb/system/CF/clock
add wave -noupdate -radix unsigned /System_tb/system/CF/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/Data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/Lookup_En
add wave -noupdate -radix unsigned /System_tb/system/CF/Insert_En
add wave -noupdate -radix unsigned /System_tb/system/CF/Delete_En
add wave -noupdate -radix unsigned /System_tb/system/CF/Mem_Read_Data
add wave -noupdate -radix unsigned /System_tb/system/CF/Lookup_Result
add wave -noupdate -radix unsigned /System_tb/system/CF/Insert_Done
add wave -noupdate -radix unsigned /System_tb/system/CF/Delete_Done
add wave -noupdate -radix unsigned /System_tb/system/CF/Processing
add wave -noupdate -radix unsigned /System_tb/system/CF/Mem_Write_Data
add wave -noupdate -radix unsigned /System_tb/system/CF/Mem_Address
add wave -noupdate -radix unsigned /System_tb/system/CF/mem_write_data_DP_2_CF
add wave -noupdate -radix unsigned /System_tb/system/CF/mem_address_DP_2_CF
add wave -noupdate -radix unsigned /System_tb/system/CF/Lookup_result_DFF_output_DP_2_CF
add wave -noupdate -radix unsigned /System_tb/system/CF/Insert_Done_DFF_output_DP_2_CF
add wave -noupdate -radix unsigned /System_tb/system/CF/Delete_Done_DFF_output_DP_2_CF
add wave -noupdate -radix unsigned /System_tb/system/CF/Proseccing_DFF_output_DP_2_CF
add wave -noupdate -radix unsigned /System_tb/system/CF/clock_CF_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/data_in_CF_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/insert_en_CF_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/delete_en_CF_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/mem_read_data_CF_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/clock_CF_2_Ctrl
add wave -noupdate -radix unsigned /System_tb/system/CF/reset_main_CF_2_Ctrl
add wave -noupdate -radix unsigned /System_tb/system/CF/lookup_en_CF_2_Ctrl
add wave -noupdate -radix unsigned /System_tb/system/CF/insert_en_CF_2_Ctrl
add wave -noupdate -radix unsigned /System_tb/system/CF/delete_en_CF_2_Ctrl
add wave -noupdate -radix unsigned /System_tb/system/CF/Comp_FP_mem_Reg_out_DP_2_Ctrl
add wave -noupdate -radix unsigned /System_tb/system/CF/Empty_Slot_Check_Result_Reg_out_DP_2_Ctrl
add wave -noupdate -radix unsigned /System_tb/system/CF/Proseccing_DFF_output_DP_2_Ctrl
add wave -noupdate -radix unsigned /System_tb/system/CF/MUXs_Select_Manager_Reg_output_2ctlr_DP_2_Ctrl
add wave -noupdate -radix unsigned /System_tb/system/CF/lookup_result_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/insert_done_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/delete_done_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/Processing_DFF_input_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_Data_Store_Reg_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_Reg_H1_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_Reg_FP_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_mem_Address_Reg_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_temp_mem_value_Reg_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_h1_memory_value_holder_Reg_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_Comp_FP_mem_Reg_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_empty_slot_check_result_Reg_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_Lookup_result_DFF_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_Insert_Done_DFF_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_Delete_Done_DFF_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_Proseccing_DFF_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_mask_gen_Reg_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_Reg_homeless_evicted_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/load_Add_homeless_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/MUXs_Select_Manager_Reg_input_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/attach_location_Ctrl_2_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/reset_to_DP_Ctrl_2_DP
add wave -noupdate -divider -height 30 {Data Path}
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/insert_en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/delete_en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_read_data
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/attach_location
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_Data_Store_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_Reg_H1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_Reg_FP
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_mem_Address_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_temp_mem_value_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_h1_memory_value_holder_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_Comp_FP_mem_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_empty_slot_check_result_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_Lookup_result_DFF
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_Insert_Done_DFF
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_Delete_Done_DFF
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_Proseccing_DFF
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_mask_gen_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_Reg_homeless_evicted
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/load_Add_homeless
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Lookup_result_DFF_input
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Insert_Done_DFF_input
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Delete_Done_DFF_input
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Proseccing_DFF_input
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/MUXs_Select_Manager_Reg_input
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_write_data
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_address
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Comp_FP_mem_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Empty_Slot_Check_Result_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Lookup_result_DFF_output
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Insert_Done_DFF_output
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Delete_Done_DFF_output
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Proseccing_DFF_output
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/MUXs_Select_Manager_Reg_output_2ctlr
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Data_Store_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_H1_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_FP_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_Address_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/temp_mem_value_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/h1_memory_value_holder_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_gen_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_homeless_evicted_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Add_homeless_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/FP_mux_2to1_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Add_mux_4to1_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Mask_mux_2to1_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/fingerprint_hash_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index1_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index2_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Empty_Slot_Check_Module_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_evicted_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index3_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/MUXs_Select_Manager_Reg_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Data_Store_Reg/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Data_Store_Reg/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Data_Store_Reg/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Data_Store_Reg/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Data_Store_Reg/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Data_Store_Reg/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_H1/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_H1/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_H1/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_H1/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_H1/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_H1/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_FP/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_FP/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_FP/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_FP/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_FP/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_FP/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_Address_Reg/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_Address_Reg/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_Address_Reg/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_Address_Reg/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_Address_Reg/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mem_Address_Reg/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/temp_mem_value_Reg/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/temp_mem_value_Reg/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/temp_mem_value_Reg/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/temp_mem_value_Reg/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/temp_mem_value_Reg/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/temp_mem_value_Reg/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/h1_memory_value_holder_Reg/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/h1_memory_value_holder_Reg/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/h1_memory_value_holder_Reg/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/h1_memory_value_holder_Reg/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/h1_memory_value_holder_Reg/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/h1_memory_value_holder_Reg/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Comp_FP_mem_Reg/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Comp_FP_mem_Reg/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Comp_FP_mem_Reg/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Comp_FP_mem_Reg/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Comp_FP_mem_Reg/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Comp_FP_mem_Reg/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/empty_slot_check_result_Reg/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/empty_slot_check_result_Reg/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/empty_slot_check_result_Reg/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/empty_slot_check_result_Reg/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/empty_slot_check_result_Reg/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/empty_slot_check_result_Reg/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Lookup_result_DFF/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Lookup_result_DFF/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Lookup_result_DFF/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Lookup_result_DFF/d
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Lookup_result_DFF/q
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Insert_Done_DFF/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Insert_Done_DFF/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Insert_Done_DFF/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Insert_Done_DFF/d
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Insert_Done_DFF/q
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Delete_Done_DFF/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Delete_Done_DFF/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Delete_Done_DFF/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Delete_Done_DFF/d
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Delete_Done_DFF/q
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Proseccing_DFF/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Proseccing_DFF/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Proseccing_DFF/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Proseccing_DFF/d
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Proseccing_DFF/q
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/MUXs_Select_Manager_Reg/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/MUXs_Select_Manager_Reg/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/MUXs_Select_Manager_Reg/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/MUXs_Select_Manager_Reg/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/MUXs_Select_Manager_Reg/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/MUXs_Select_Manager_Reg/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_gen_Reg/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_gen_Reg/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_gen_Reg/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_gen_Reg/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_gen_Reg/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_gen_Reg/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_homeless_evicted/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_homeless_evicted/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_homeless_evicted/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_homeless_evicted/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_homeless_evicted/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Reg_homeless_evicted/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Add_homeless_Reg/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Add_homeless_Reg/reset
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Add_homeless_Reg/en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Add_homeless_Reg/load
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Add_homeless_Reg/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Add_homeless_Reg/data_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/FP_mux_2to1_inst/in0
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/FP_mux_2to1_inst/in1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/FP_mux_2to1_inst/sel
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/FP_mux_2to1_inst/out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mux_4to1_inst/in0
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mux_4to1_inst/in1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mux_4to1_inst/in2
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mux_4to1_inst/in3
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mux_4to1_inst/sel
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mux_4to1_inst/out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Mask_mux_2to1_inst/in0
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Mask_mux_2to1_inst/in1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Mask_mux_2to1_inst/sel
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Mask_mux_2to1_inst/out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/fingerprint_inst/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/fingerprint_inst/fingerprint
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/fingerprint_inst/temp
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index1_inst/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index1_inst/index1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index1_inst/hash_value
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index2_inst/index1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index2_inst/fingerprint
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index2_inst/index2
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index2_inst/hash_value
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/num1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/num2
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/equal_bits
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp0/num1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp0/num2
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp0/equal
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp1/num1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp1/num2
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp1/equal
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp2/num1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp2/num2
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp2/equal
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp3/num1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp3/num2
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/compare_FP_mem/comp3/equal
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Empty_Slot_Check/data_in
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/Empty_Slot_Check/slot_status
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_generator_inst/stencil
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_generator_inst/background
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_generator_inst/insert_en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_generator_inst/delete_en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_generator_inst/attach_location
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_generator_inst/mask_out
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_generator_inst/evicted
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/mask_generator_inst/evicted_chunk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index3_inst/index1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index3_inst/fingerprint
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index3_inst/index2
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Data_Path/hash_index3_inst/hash_value
add wave -noupdate -divider -height 30 Controller
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/clk
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/reset_main
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/lookup_en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/insert_en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/delete_en
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/Comp_FP_mem_Reg_result
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/Empty_Slot_Check_Result_Reg_out_result
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/Processing_DFF_output
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/MUXs_Select_Manager_Reg_output_from_DataPath
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/lookup_result
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/insert_done
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/delete_done
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/Processing_DFF_input
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Data_Store_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Reg_H1
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Reg_FP
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_mem_Address_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_temp_mem_value_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_h1_memory_value_holder_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Comp_FP_mem_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_empty_slot_check_result_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Lookup_result_DFF
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Insert_Done_DFF
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Delete_Done_DFF
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Proseccing_DFF
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_mask_gen_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Reg_homeless_evicted
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/load_Add_homeless
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/MUXs_Select_Manager_Reg_input
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/attach_location
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/reset_to_DP
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/present_state
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/next_state
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/Row_Position_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/limit_loop_Reg
add wave -noupdate -radix unsigned /System_tb/system/CF/CF_Controller/limit_memory_wait_Reg
add wave -noupdate -divider -height 30 Memory
add wave -noupdate /System_tb/system/MEMORY/ena
add wave -noupdate /System_tb/system/MEMORY/wea
add wave -noupdate -radix unsigned /System_tb/system/MEMORY/addra
add wave -noupdate /System_tb/system/MEMORY/dina
add wave -noupdate /System_tb/system/MEMORY/douta
add wave -noupdate /System_tb/system/MEMORY/rsta
add wave -noupdate /System_tb/system/MEMORY/rsta_busy
add wave -noupdate /System_tb/system/CF/CF_Controller/counter_hash_pipline
add wave -noupdate /System_tb/system/CF/Filter_is_Full
add wave -noupdate /System_tb/system/CF/CF_Data_Path/FP_Fixed_Coefficient_Reg_input_16bit
add wave -noupdate /System_tb/system/CF/CF_Data_Path/Hash_Index1_Fixed_Coefficient_Reg_input_32bit
add wave -noupdate /System_tb/system/CF/CF_Data_Path/Hash_Index2_Fixed_Coefficient_Reg_input_32bit
add wave -noupdate /System_tb/system/CF/CF_Data_Path/load_FP_Fixed_Coefficient_Reg
add wave -noupdate /System_tb/system/CF/CF_Data_Path/load_Hash_Index1_Fixed_Coefficient_Reg
add wave -noupdate /System_tb/system/CF/CF_Data_Path/load_Hash_Index2_Fixed_Coefficient_Reg
add wave -noupdate /System_tb/system/CF/CF_Data_Path/FP_Fixed_Coefficient_Reg_out
add wave -noupdate /System_tb/system/CF/CF_Data_Path/Hash_Index1_Fixed_Coefficient_Reg_out
add wave -noupdate /System_tb/system/CF/CF_Data_Path/Hash_Index2_Fixed_Coefficient_Reg_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8076 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 490
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {10403992235 ps} {10404027785 ps}
