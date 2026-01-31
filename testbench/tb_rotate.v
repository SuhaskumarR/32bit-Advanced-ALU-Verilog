`timescale 1ns/1ps

module tb_rotate;

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
    localparam OP_ROL = 5'b01011;
    localparam OP_ROR = 5'b01100;
    localparam OP_RCL = 5'b01101;
    localparam OP_RCR = 5'b01110;

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------
    initial begin
        $display("======================================");
        $display(" ROTATE OPERATIONS TEST STARTED ");
        $display("======================================");

        $dumpfile("alu_rotate.vcd");
        $dumpvars(0, tb_rotate);

        // --------------------------------------------------------
        // ROL TESTS
        // --------------------------------------------------------
        $display("\n--- ROL TESTS ---");

        // Simple rotate left
        A = 32'h00000001; B = 32'd1; Opcode = OP_ROL; Cin = 0;
        #10 $display("ROL 1 by 1  -> Result=%h Flags=%b", Result, Flags);

        // MSB wrap-around
        A = 32'h80000000; B = 32'd1; Opcode = OP_ROL;
        #10 $display("ROL wrap    -> Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // ROR TESTS
        // --------------------------------------------------------
        $display("\n--- ROR TESTS ---");

        // Simple rotate right
        A = 32'h00000002; B = 32'd1; Opcode = OP_ROR;
        #10 $display("ROR 2 by 1  -> Result=%h Flags=%b", Result, Flags);

        // LSB wrap-around
        A = 32'h00000001; B = 32'd1; Opcode = OP_ROR;
        #10 $display("ROR wrap    -> Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // RCL TESTS (Rotate Through Carry Left)
        // --------------------------------------------------------
        $display("\n--- RCL TESTS ---");

        // Inject carry into LSB
        A = 32'h00000000; B = 32'd1; Cin = 1; Opcode = OP_RCL;
        #10 $display("RCL Cin->LSB -> Result=%h Flags=%b", Result, Flags);

        // MSB into carry
        A = 32'h80000000; B = 32'd1; Cin = 0; Opcode = OP_RCL;
        #10 $display("RCL MSB->C   -> Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // RCR TESTS (Rotate Through Carry Right)
        // --------------------------------------------------------
        $display("\n--- RCR TESTS ---");

        // Inject carry into MSB
        A = 32'h00000000; B = 32'd1; Cin = 1; Opcode = OP_RCR;
        #10 $display("RCR Cin->MSB -> Result=%h Flags=%b", Result, Flags);

        // LSB into carry
        A = 32'h00000001; B = 32'd1; Cin = 0; Opcode = OP_RCR;
        #10 $display("RCR LSB->C   -> Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        $display("\n======================================");
        $display(" ROTATE TEST COMPLETED ");
        $display("======================================");

        $finish;
    end

endmodule
