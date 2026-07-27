<div align="center">

#  Single-Cycle RISC-V Processor (RV32I Subset)

**A modular single-cycle RV32I processor built from scratch in Verilog HDL, verified in Xilinx Vivado with per-instruction directed tests and a full regression suite.**

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue?style=flat-square)
![Vivado](https://img.shields.io/badge/Tool-Xilinx%20Vivado-orange?style=flat-square)
![ISA](https://img.shields.io/badge/ISA-RV32I%20Subset-brightgreen?style=flat-square)
![Verification](https://img.shields.io/badge/Verification-Passed-success?style=flat-square)

</div>

---

## Overview

A single-cycle RISC-V CPU that executes a verified subset of RV32I — Fetch, Decode, Execute, Memory, and Write-Back all complete in one clock cycle. Every functional block (control unit, ALU, register file, memory, immediate generator) was designed and wired independently, then verified instruction-by-instruction with real Vivado waveform evidence before being combined into a regression test. Each implemented instruction was first verified independently using directed assembly programs before being validated through a complete regression test.

---
## Project Status

**Version:** v1.0

- ✅ Single-Cycle RISC-V (RV32I Subset)
- ✅ Functional RTL Implementation
- ✅ Instruction-Level Verification
- ✅ Regression Test Passed
- 🚧 Next Milestone: 5-Stage Pipelined RISC-V Processor
  
## Architecture

```
                         ┌──────────────┐
        ┌───────────────▶│      PC      │
        │                └──────┬───────┘
        │                       ▼
        │              ┌─────────────────┐        ┌───────────────────┐
        │              │  Instruction    │───────▶│  Instruction        │
        │              │    Memory       │        │  Decode (fields)    │
        │              └─────────────────┘        └─────────┬──────────┘
        │                                                    │
        │            ┌───────────────────────┬───────────────┼───────────────┐
        │            ▼                       ▼               ▼               ▼
        │   ┌─────────────────┐   ┌───────────────────┐  ┌──────────┐  ┌────────────────┐
        │   │  Main Control    │   │  Register File     │  │   Imm     │  │  ALU Control    │
        │   │ RegWrite/ALUSrc/ │   │   32 x 32-bit       │  │ Generator │  │                 │
        │   │ Mem R/W/ToReg/Br │   └─────────┬──────────┘  └─────┬─────┘  └────────┬────────┘
        │   └────────┬─────────┘             │                    │                 │
        │            │              ┌────────▼────────┐           │                 │
        │            │              │  ALUSrc Mux      │◀──────────┘                 │
        │            │              └────────┬────────┘                             │
        │            │                       ▼                                       │
        │            │              ┌─────────────────┐                              │
        │            │              │       ALU        │◀─────────────────────────────┘
        │            │              │   (10 ops)        │
        │            │              └────────┬────────┘
        │            │                       ▼ result / zero
        │            │              ┌─────────────────┐
        │            │              │   Data Memory    │
        │            │              └────────┬────────┘
        │            │                       ▼
        │            │              ┌─────────────────┐
        │            └─────────────▶│ MemToReg Mux     │──▶ write back to Register File
        │                           └─────────────────┘
        │
        └──── pc_next = (branch & zero) ? pc + imm : pc + 4
```

Control signals (`RegWrite`, `ALUSrc`, `MemRead`, `MemWrite`, `MemToReg`, `Branch`) are decoded combinationally from the opcode each cycle and drive every mux in the datapath above. Jump instructions (JAL/JALR) are reserved for a future version of the processor and are included in the roadmap below.

---

## Supported Instructions

| Category | Instructions | Type |
|---|---|---|
| Arithmetic | `ADD`, `SUB` | R |
| Logic | `AND`, `OR`, `XOR` | R |
| Shift | `SLL`, `SRL`, `SRA` | R |
| Compare | `SLT`, `SLTU` | R |
| Immediate | `ADDI` | I |
| Memory | `LW`, `SW` | I / S |
| Branch | `BEQ` | B |

*Not yet implemented: `JAL`, `JALR`, `LUI`, `AUIPC`, and the remaining branches (`BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`) — tracked in the roadmap below.*

---

## RTL Modules

| File | Module | Role |
|---|---|---|
| `risc_top.v` | `risc_top` | Top-level datapath integration |
| `pc.v` | `pc` | Program counter |
| `inst_mem.v` | `inst_mem` | Instruction memory, loaded via `$readmemh` |
| `instruction_field_extractor.v` | `instruction_field_extractor` | Splits instruction into opcode, rd, funct3, rs1, rs2 and funct7 |
| `immediate_generator.v` | `immediate_generator` |Immediate generation for implemented instruction formats (I/S/B), with support prepared for future U/J extensions. |
| `main_control.v` | `main_control` | Datapath control signal generation |
| `alu_control.v` | `alu_control` | ALU operation decode |
| `alu.v` | `alu` | 32-bit ALU, 10 operations |
| `register_file.v` | `register_file` | 32 x 32-bit register file |
| `data_memory.v` | `data_memory` | 256-word data memory |
| `risc_top_tb.v` | `risc_top_tb` | Top-level testbench |

---

## Verification

Every implemented instruction is verified in isolation with a directed assembly program and a captured Vivado waveform, then combined into a single regression program that chains arithmetic, logic, shift, compare, memory, and branch instructions together.

| Instruction | Status |
|---|:---:|
| `ADD`, `SUB` | ✅ |
| `AND`, `OR`, `XOR` | ✅ |
| `SLL`, `SRL`, `SRA` | ✅ |
| `SLT`, `SLTU` | ✅ |
| `ADDI` | ✅ |
| `LW`, `SW` | ✅ |
| `BEQ` | ✅ |
| Full regression | ✅ |

## Key Achievements

- Designed a modular single-cycle RISC-V processor from scratch.
- Implemented a parameterized RTL datapath in Verilog HDL.
- Verified every implemented instruction individually.
- Successfully completed a regression test covering the implemented ISA subset.

Each `verification//<instruction>/` folder contains the `assembly.txt` (with expected register values commented inline), the assembled `program.mem`, and a `waveform.png` used to confirm the DUT output.

![Regression waveform](<alu verification/regresion_test_1/waveform_1.png>)

---



## Roadmap

**v1.0 — Current**
✔ Single-cycle RV32I subset · ✔ Directed verification · ✔ Regression test

### Version 2.0

- [ ] JAL / JALR
- [ ] LUI / AUIPC
- [ ] Remaining Branch Instructions
- [ ] Self-checking Testbench

### Version 3.0

- [ ] Five-Stage Pipeline
- [ ] Hazard Detection
- [ ] Forwarding Unit
- [ ] Stall Logic

### Version 4.0

- [ ] AXI-Based SoC
- [ ] UART / Timer / GPIO
- [ ] Cache
- [ ] FPGA Demonstration

---

## Tools

- Verilog HDL
- Xilinx Vivado
- Vivado Simulator
- Git & GitHub
---


## Repository Structure

```text
risc_v/
├── rtl/             # RTL source files
├── verification/    # Directed tests & regression
│   ├── add/
│   ├── sub/
│   ├── lw/
│   ├── sw/
│   ├── beq/
│   └── regression/
├── docs/            # RTL schematic & synthesis reports
├── risc_top_tb.v    # Top-level testbench
├── program.mem      # Simulation program
└── README.md
```


