`timescale 1ns/1ps

module tb_logical;

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
    // Opcode definitions (same as design)
    // ------------------------------------------------------------
    localparam OP_AND = 5'b00100;
    localparam OP_OR  = 5'b00101;
    localparam OP_XOR = 5'b00110;
    localparam OP_NOT = 5'b00111;

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------
    initial begin
        $display("======================================");
        $display(" LOGICAL OPERATIONS TEST STARTED ");
        $display("======================================");

        $dumpfile("alu_logical.vcd");
        $dumpvars(0, tb_logical);

        // --------------------------------------------------------
        // AND TESTS
        // --------------------------------------------------------
        $display("\n--- AND TESTS ---");

        A = 32'hFFFF0000; B = 32'h0F0F0F0F; Opcode = OP_AND; Cin = 0;
        #10 $display("AND Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // OR TESTS
        // --------------------------------------------------------
        $display("\n--- OR TESTS ---");

        A = 32'hF0F00000; B = 32'h00000F0F; Opcode = OP_OR;
        #10 $display("OR Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // XOR TESTS
        // --------------------------------------------------------
        $display("\n--- XOR TESTS ---");

        A = 32'hAAAAAAAA; B = 32'hFFFFFFFF; Opcode = OP_XOR;
        #10 $display("XOR Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // NOT TESTS
        // --------------------------------------------------------
        $display("\n--- NOT TESTS ---");

        A = 32'h00000000; Opcode = OP_NOT;
        #10 $display("NOT Result=%h Flags=%b", Result, Flags);

        A = 32'hFFFFFFFF; Opcode = OP_NOT;
        #10 $display("NOT Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        $display("\n======================================");
        $display(" LOGICAL TEST COMPLETED ");
        $display("======================================");

        $finish;
    end

endmodule
