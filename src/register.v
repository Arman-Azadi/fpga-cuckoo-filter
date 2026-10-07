module register #(parameter WIDTH = 8) (
    input clk,                  // Clock signal
    input reset,                // Reset signal
    input en,                   // Enable signal
    input load,                 // Load signal
    input [WIDTH-1:0] data_in,  // Input data
    output reg [WIDTH-1:0] data_out  // Output data
);

    // Main register process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // If reset is active, set the register to zero
            data_out <= {WIDTH{1'b0}};
        end else if (en) begin
            // If enable is active, check the load signal
            if (load) begin
                // If load is active, store input data in the register
                data_out <= data_in;
            end else begin
                // If load is inactive, retain the current value
                data_out <= data_out;
            end
        end else begin
            // If enable is inactive, retain the current value
            data_out <= data_out;
        end
    end

endmodule