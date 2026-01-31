`timescale 1ns/1ps

module tb_arithmetic;

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
    // Opcode values (same as design)
    // ------------------------------------------------------------
    localparam OP_ADD = 5'b00000;
    localparam OP_SUB = 5'b00001;
    localparam OP_MUL = 5'b00010;
    localparam OP_DIV = 5'b00011;

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------
    initial begin
        $display("======================================");
        $display(" ARITHMETIC OPERATIONS TEST STARTED ");
        $display("======================================");

        $dumpfile("alu_arithmetic.vcd");
        $dumpvars(0, tb_arithmetic);

        // --------------------------------------------------------
        // ADD TESTS
        // --------------------------------------------------------
        $display("\n--- ADD TESTS ---");

        // ADD normal
        A = 32'd10; B = 32'd20; Opcode = OP_ADD; Cin = 0;
        #10 $display("ADD 10 + 20 = %0d | Flags=%b", Result, Flags);

        // ADD with carry (unsigned overflow)
        A = 32'hFFFFFFFF; B = 32'd1; Opcode = OP_ADD;
        #10 $display("ADD FFFFFFFF + 1 = %h | Flags=%b", Result, Flags);

        // ADD signed overflow
        A = 32'h7FFFFFFF; B = 32'd1; Opcode = OP_ADD;
        #10 $display("ADD signed overflow | Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // SUB TESTS
        // --------------------------------------------------------
        $display("\n--- SUB TESTS ---");

        // SUB normal
        A = 32'd50; B = 32'd20; Opcode = OP_SUB;
        #10 $display("SUB 50 - 20 = %0d | Flags=%b", Result, Flags);

        // SUB with borrow
        A = 32'd20; B = 32'd50; Opcode = OP_SUB;
        #10 $display("SUB 20 - 50 = %0d | Flags=%b", Result, Flags);

        // SUB signed overflow
        A = 32'h80000000; B = 32'd1; Opcode = OP_SUB;
        #10 $display("SUB signed overflow | Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // MUL TESTS
        // --------------------------------------------------------
        $display("\n--- MUL TESTS ---");

        // MUL normal
        A = 32'd6; B = 32'd7; Opcode = OP_MUL;
        #10 $display("MUL 6 * 7 = %0d | Flags=%b", Result, Flags);

        // MUL overflow (upper bits lost)
        A = 32'hFFFFFFFF; B = 32'd2; Opcode = OP_MUL;
        #10 $display("MUL overflow | Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        // DIV TESTS
        // --------------------------------------------------------
        $display("\n--- DIV TESTS ---");

        // DIV normal
        A = 32'd100; B = 32'd5; Opcode = OP_DIV;
        #10 $display("DIV 100 / 5 = %0d | Flags=%b", Result, Flags);

        // DIV by zero
        A = 32'd100; B = 32'd0; Opcode = OP_DIV;
        #10 $display("DIV by zero | Result=%h Flags=%b", Result, Flags);

        // --------------------------------------------------------
        $display("\n======================================");
        $display(" ARITHMETIC TEST COMPLETED ");
        $display("======================================");

        $finish;
    end

endmodule
