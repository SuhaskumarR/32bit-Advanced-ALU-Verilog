`timescale 1ns/1ps

module tb_shift;

    // ------------------------------------------------------------
    // Signals
    // ------------------------------------------------------------
    reg  [31:0] A, B;
    reg  [4:0]  Opcode;
    reg         Cin;

    wire [31:0] Result;
    wire [3:0]  Flags;   // {V, C, N, Z}

    // ------------------------------------------------------------
    // DUT
    // ------------------------------------------------------------
    alu_advanced dut (
        .A(A),
        .B(B),
        .Opcode(Opcode),
        .Cin(Cin),
        .Result(Result),
        .Flags(Flags)
    );

    // ------------------------------------------------------------
    // Opcode definitions
    // ------------------------------------------------------------
    localparam OP_SHL = 5'b01000;
    localparam OP_SHR = 5'b01001;
    localparam OP_SAR = 5'b01010;

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------
    initial begin
        $display("======================================");
        $display(" SHIFT OPERATIONS TEST STARTED ");
        $display("======================================");

        $dumpfile("alu_shift.vcd");
        $dumpvars(0, tb_shift);

        // --------------------------------------------------------
        // SHL TESTS (Shift Left Logical)
        // --------------------------------------------------------
        $display("\n--- SHL TESTS ---");

        // Simple shift
        A = 32'd5; B = 32'd1; Opcode = OP_SHL; Cin = 0;
        #10 $display("SHL 5 << 1 = %0d | Flags=%b", Result, Flags);

        // Shift with carry out
        A = 32'h80000000; B = 32'd1; Opcode = OP_SHL;
        #10 $display("SHL carry test | Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // SHR TESTS (Shift Right Logical)
        // --------------------------------------------------------
        $display("\n--- SHR TESTS ---");

        // Simple shift
        A = 32'd8; B = 32'd1; Opcode = OP_SHR;
        #10 $display("SHR 8 >> 1 = %0d | Flags=%b", Result, Flags);

        // MSB zero-fill check
        A = 32'h80000000; B = 32'd1; Opcode = OP_SHR;
        #10 $display("SHR zero-fill | Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // SAR TESTS (Shift Right Arithmetic)
        // --------------------------------------------------------
        $display("\n--- SAR TESTS ---");

        // Positive number
        A = 32'd8; B = 32'd1; Opcode = OP_SAR;
        #10 $display("SAR 8 >>> 1 = %0d | Flags=%b", Result, Flags);

        // Negative number (sign extension)
        A = 32'hFFFFFFF8; B = 32'd1; Opcode = OP_SAR;
        #10 $display("SAR -8 >>> 1 = %0d | Flags=%b", Result, Flags);

        // --------------------------------------------------------
        $display("\n======================================");
        $display(" SHIFT TEST COMPLETED ");
        $display("======================================");

        $finish;
    end

endmodule

