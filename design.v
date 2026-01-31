`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    alu_advanced
// Description:    32-bit combinational ALU with arithmetic, logical,
//                 shift, rotate, and rotate-through-carry operations.
//                 Generates status flags: Overflow, Carry, Negative, Zero.
//////////////////////////////////////////////////////////////////////////////////

module alu_advanced(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [4:0]  Opcode,
    input  wire        Cin,
    output reg  [31:0] Result,
    output wire [3:0]  Flags   // {V, C, N, Z}
);

    // =====================================================================
    // Opcode Definitions
    // =====================================================================
    localparam OP_ADD = 5'b00000;
    localparam OP_SUB = 5'b00001;
    localparam OP_MUL = 5'b00010;
    localparam OP_DIV = 5'b00011;

    localparam OP_AND = 5'b00100;
    localparam OP_OR  = 5'b00101;
    localparam OP_XOR = 5'b00110;
    localparam OP_NOT = 5'b00111;

    localparam OP_SHL = 5'b01000;
    localparam OP_SHR = 5'b01001;
    localparam OP_SAR = 5'b01010;

    localparam OP_ROL = 5'b01011;
    localparam OP_ROR = 5'b01100;
    localparam OP_RCL = 5'b01101;
    localparam OP_RCR = 5'b01110;

    // =====================================================================
    // Internal Signals
    // =====================================================================
    reg  [32:0] temp_arith;
    reg  [32:0] T;            // rotate-through-carry temp
    reg         flag_c;
    reg         flag_v;

    wire        flag_n;
    wire        flag_z;

    wire [4:0] shamt = B[4:0];

    // =====================================================================
    // ALU Logic (Combinational)
    // =====================================================================
    always @(*) begin
        // -------- defaults (prevent latches) --------
        Result      = 32'b0;
        temp_arith = 33'b0;
        T           = 33'b0;
        flag_c      = 1'b0;
        flag_v      = 1'b0;

        case (Opcode)

            // -------------------------------------------------------------
            // Arithmetic
            // -------------------------------------------------------------
            OP_ADD: begin
                temp_arith = {1'b0, A} + {1'b0, B};
                Result     = temp_arith[31:0];
                flag_c     = temp_arith[32];
                flag_v     = (~(A[31] ^ B[31])) & (A[31] ^ Result[31]);
            end

            OP_SUB: begin
                temp_arith = {1'b0, A} - {1'b0, B};
                Result     = temp_arith[31:0];
                flag_c     = ~temp_arith[32]; // 1 = no borrow
                flag_v     = (A[31] ^ B[31]) & (A[31] ^ Result[31]);
            end

            OP_MUL: begin
                Result = A * B;
                flag_c = |((A * B) >> 32); // upper bits lost
            end

            OP_DIV: begin
                if (B != 0)
                    Result = A / B;
                else
                    flag_v = 1'b1; // divide-by-zero indication
            end

            // -------------------------------------------------------------
            // Logical
            // -------------------------------------------------------------
            OP_AND: Result = A & B;
            OP_OR : Result = A | B;
            OP_XOR: Result = A ^ B;
            OP_NOT: Result = ~A;

            // -------------------------------------------------------------
            // Shifts
            // -------------------------------------------------------------
            OP_SHL: begin
                if (shamt == 0) begin
                    Result = A;
                    flag_c = Cin;
                end else begin
                    Result = A << shamt;
                    flag_c = A[32 - shamt];
                end
            end

            OP_SHR: begin
                if (shamt == 0) begin
                    Result = A;
                    flag_c = Cin;
                end else begin
                    Result = A >> shamt;
                    flag_c = A[shamt - 1];
                end
            end

            OP_SAR: begin
                if (shamt == 0) begin
                    Result = A;
                    flag_c = Cin;
                end else begin
                    Result = $signed(A) >>> shamt;
                    flag_c = A[shamt - 1];
                end
            end

            // -------------------------------------------------------------
            // Rotates
            // -------------------------------------------------------------
            OP_ROL: begin
                if (shamt == 0) begin
                    Result = A;
                    flag_c = Cin;
                end else begin
                    Result = (A << shamt) | (A >> (32 - shamt));
                    flag_c = Result[0];
                end
            end

            OP_ROR: begin
                if (shamt == 0) begin
                    Result = A;
                    flag_c = Cin;
                end else begin
                    Result = (A >> shamt) | (A << (32 - shamt));
                    flag_c = Result[31];
                end
            end

            // -------------------------------------------------------------
            // Rotate Through Carry (33-bit ring)
            // -------------------------------------------------------------
            OP_RCL: begin
                if (shamt == 0) begin
                    Result = A;
                    flag_c = Cin;
                end else begin
                    T      = {A, Cin};
                    T      = (T << shamt) | (T >> (33 - shamt));
                    Result = T[32:1];
                    flag_c = T[0];
                end
            end

            OP_RCR: begin
                if (shamt == 0) begin
                    Result = A;
                    flag_c = Cin;
                end else begin
                    T      = {A, Cin};
                    T      = (T >> shamt) | (T << (33 - shamt));
                    Result = T[32:1];
                    flag_c = T[32];
                end
            end

            // -------------------------------------------------------------
            default: begin
                Result = 32'b0;
                flag_c = 1'b0;
                flag_v = 1'b0;
            end

        endcase
    end

    // =====================================================================
    // Flags
    // =====================================================================
    assign flag_n = Result[31];
    assign flag_z = (Result == 32'b0);

    assign Flags = {flag_v, flag_c, flag_n, flag_z};

endmodule
