module System(
    input Clock,
    input Reset,
    input [31:0] Data_in,
    input Lookup_En,
    input Insert_En,
    input Delete_En,

    input [15:0] FP_Fixed_Coefficient_Reg_input_16bit,
    input [31:0] Hash_Index1_Fixed_Coefficient_Reg_input_32bit,
    input [31:0] Hash_Index2_Fixed_Coefficient_Reg_input_32bit,

    input load_FP_Fixed_Coefficient_Reg,
    input load_Hash_Index1_Fixed_Coefficient_Reg,
    input load_Hash_Index2_Fixed_Coefficient_Reg,

    output Lookup_Result,
    output Insert_Done,
    output Delete_Done,
    output Processing,
    output Filter_is_Full
);

    // Wries between Cuckoo filter & Memory
        // Cuckoo_filter to Memory
        wire mem_enable_CF_2_Mem;
        wire [0:0] write_read_en_CF_2_Mem;
        wire [63:0] write_data_CF_2_Mem;
        wire [15:0] mem_address_CF_2_Mem;

        // Memory to Cuckoo_filter 
        wire [63:0] read_data_Mem_2_CF;
    

    Cuckoo_Filter CF(
        .clock(Clock),
        .reset(Reset),
        .Data_in(Data_in),
        .Lookup_En(Lookup_En),
        .Insert_En(Insert_En),
        .Delete_En(Delete_En),
        .FP_Fixed_Coefficient_Reg_input_16bit(FP_Fixed_Coefficient_Reg_input_16bit),
        .Hash_Index1_Fixed_Coefficient_Reg_input_32bit(Hash_Index1_Fixed_Coefficient_Reg_input_32bit),
        .Hash_Index2_Fixed_Coefficient_Reg_input_32bit(Hash_Index2_Fixed_Coefficient_Reg_input_32bit),
        .Mem_Read_Data(read_data_Mem_2_CF),

        .load_FP_Fixed_Coefficient_Reg(load_FP_Fixed_Coefficient_Reg),
        .load_Hash_Index1_Fixed_Coefficient_Reg(load_Hash_Index1_Fixed_Coefficient_Reg),
        .load_Hash_Index2_Fixed_Coefficient_Reg(load_Hash_Index2_Fixed_Coefficient_Reg),

        .Lookup_Result(Lookup_Result),
        .Insert_Done(Insert_Done),
        .Delete_Done(Delete_Done),
        .Processing(Processing),
        .Filter_is_Full(Filter_is_Full),
        .Mem_Enable(mem_enable_CF_2_Mem),
        .Mem_Write_Read_En(write_read_en_CF_2_Mem),
        .Mem_Write_Data(write_data_CF_2_Mem),
        .Mem_Address(mem_address_CF_2_Mem)
    );

    blk_mem_16bit_rest MEMORY(
        .clka(Clock),
        .rsta(Reset),
        .ena(mem_enable_CF_2_Mem),
        .wea(write_read_en_CF_2_Mem),
        .addra(mem_address_CF_2_Mem),
        .dina(write_data_CF_2_Mem),
        .douta(read_data_Mem_2_CF),
        .rsta_busy()
    );


    /*
    ///////////////////////////////////////////////////////////////////

    // Wries between Shadow (Cuckoo filter & Memory)
        // Cuckoo_filter to Memory
        wire sh_mem_enable_CF_2_Mem;
        wire  sh_write_read_en_CF_2_Mem;
        wire [63:0] sh_write_data_CF_2_Mem;
        wire [15:0] sh_mem_address_CF_2_Mem;

        // Memory to Cuckoo_filter 
        wire [63:0] sh_read_data_Mem_2_CF;


    Cuckoo_Filter Sh_CF(
        .clock(Clock),
        .reset(Reset),
        .Data_in(Data_in),
        .Lookup_En(Lookup_En),
        .Insert_En(Insert_En),
        .Delete_En(Delete_En),
        .Mem_Read_Data(sh_read_data_Mem_2_CF),

        .Lookup_Result(Lookup_Result),
        .Insert_Done(Insert_Done),
        .Delete_Done(Delete_Done),
        .Processing(Processing),
        .Mem_Enable(sh_mem_enable_CF_2_Mem),
        .Mem_Write_Read_En(sh_write_read_en_CF_2_Mem),
        .Mem_Write_Data(sh_write_data_CF_2_Mem),
        .Mem_Address(sh_mem_address_CF_2_Mem)
    );

    memory_64bit  Sh_memory(
        .clk(Clock),
        .rst(Reset),
        .enable(sh_mem_enable_CF_2_Mem),
        .write_enable(sh_write_read_en_CF_2_Mem),
        .write_data(sh_write_data_CF_2_Mem),
        .address(sh_mem_address_CF_2_Mem),
        .read_data(sh_read_data_Mem_2_CF)
    );
    */




endmodule
