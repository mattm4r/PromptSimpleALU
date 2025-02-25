`define default_netname none

module tt_um_mattm4r (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // ALU Inputs
    wire [3:0] A = ui_in[3:0];  // First operand
    wire [3:0] B = ui_in[7:4];  // Second operand
    wire [2:0] opcode = uio_in[2:0];  // ALU operation selector

    reg [7:0] result;  // ALU result (8 bits for multiplication and division)

    always @(*) begin
        case (opcode)
            3'b000: result = A + B;  // Addition
            3'b001: result = A - B;  // Subtraction
            3'b010: result = A & B;  // Bitwise AND
            3'b011: result = A | B;  // Bitwise OR
            3'b100: result = A ^ B;  // Bitwise XOR
            3'b101: result = {4'b0000, ~A}; // Bitwise NOT of A (only lower 4 bits used)
            3'b110: result = A * B;  // Multiplication (4-bit x 4-bit = 8-bit result)
            3'b111: result = (B != 0) ? (A / B) : 8'b11111111; // Division (handle divide by zero)
            default: result = 8'b00000000;
        endcase
    end

    // Assign outputs
    assign uo_out = result;  // Output ALU result
    assign uio_out = 0;
    assign uio_oe  = 0;

endmodule

