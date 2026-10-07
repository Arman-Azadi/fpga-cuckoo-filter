module mask_generator (
    input wire [15:0] stencil,          // 16-bit stencil input
    input wire [63:0] background,       // 64-bit background input
    input wire insert_en,               // Insert enable signal
    input wire delete_en,               // Delete enable signal
    input wire [1:0] attach_location,   // 2-bit control signal for location
    output wire [63:0] mask_out,        // 64-bit output mask
    output wire [15:0] evicted          // 16-bit evicted chunk
);

    reg [63:0] temp_mask;

    // Determine which chunk to evict based on attach_location
    reg [15:0] evicted_chunk;  // The chunk to be evicted

    always @(*) begin
    // ابتدا پیش‌فرض را قرار بدهیم
    temp_mask = background;
    evicted_chunk = 16'b0;

    case (attach_location)
        2'b00: begin
            evicted_chunk = background[15:0];
            temp_mask[15:0] = (insert_en) ? stencil : (delete_en) ? 16'b0 : background[15:0];
        end
        2'b01: begin
            evicted_chunk = background[31:16];
            temp_mask[31:16] = (insert_en) ? stencil : (delete_en) ? 16'b0 : background[31:16];
        end
        2'b10: begin
            evicted_chunk = background[47:32];
            temp_mask[47:32] = (insert_en) ? stencil : (delete_en) ? 16'b0 : background[47:32];
        end
        2'b11: begin
            evicted_chunk = background[63:48];
            temp_mask[63:48] = (insert_en) ? stencil : (delete_en) ? 16'b0 : background[63:48];
        end
        default: begin
            evicted_chunk = 16'b0;
            temp_mask = background;
        end
    endcase

    end

    // Generate the output mask
    assign mask_out = temp_mask;
    // Output the evicted chunk
    assign evicted = evicted_chunk;

endmodule