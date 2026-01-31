# 32-bit Advanced ALU in Verilog

##  Project Overview
This project implements a **32-bit Advanced Arithmetic Logic Unit (ALU)** using **Verilog HDL**.  
The ALU supports arithmetic, logical, shift, rotate, and rotate-through-carry operations along with full status flag generation.

The design is fully verified using **Icarus Verilog** and **GTKWave**, with modular testbenches for each operation category.

---

##  Supported Operations

### Arithmetic Operations
- Addition (ADD)
- Subtraction (SUB)
- Multiplication (MUL)
- Division (DIV)

### Logical Operations
- AND
- OR
- XOR
- NOT

### Shift Operations
- Logical Shift Left (SHL)
- Logical Shift Right (SHR)
- Arithmetic Shift Right (SAR)

### Rotate Operations
- Rotate Left (ROL)
- Rotate Right (ROR)
- Rotate Through Carry Left (RCL)
- Rotate Through Carry Right (RCR)

---

## Status Flags
The ALU generates the following flags:
- **V (Overflow)** – Signed overflow detection
- **C (Carry)** – Carry/borrow or shifted-out bit
- **N (Negative)** – MSB of result
- **Z (Zero)** – Result equals zero

---

##  Verification Strategy
Verification is done using **separate testbenches** for better readability and modular testing:

- `tb_arithmetic.v`
- `tb_logical.v`
- `tb_shift.v`
- `tb_rotate.v`

Each testbench validates normal and corner cases, and waveforms are analyzed using GTKWave.

---

##  How to Run Simulation

```bash
iverilog -g2012 -o out.vvp design/alu_advanced.v testbench/tb_arithmetic.v
vvp out.vvp
gtkwave alu_arithmetic.vcd
