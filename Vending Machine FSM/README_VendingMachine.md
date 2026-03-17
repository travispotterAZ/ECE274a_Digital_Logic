# Vending Machine FSM — Lab 6

A Verilog implementation of a coin-operated vending machine finite state machine (FSM), synthesized and deployed on a Nexys4 DDR FPGA board.

---

## Overview

This lab implements a Moore-style FSM that accepts nickels (5¢), dimes (10¢), and quarters (25¢) and dispenses candy once at least 25 cents has been inserted. Change (the amount above 25¢) is displayed on the board's 7-segment display as a two-digit decimal number. Button presses are debounced and synchronized to a divided clock before reaching the FSM.

---

## File Structure

```
Lab 6/
├── VendingMachine.v         # FSM — version with IDLE dispensing state
├── VendingMachine (1).v     # FSM — version with self-looping dispensing states
├── Top_Design.v             # Top-level module wiring all components together
├── ButtonSync.v             # Button debounce/sync FSM (one-shot pulse per press)
├── ClkDiv.v                 # Clock divider: 100 MHz → ~1 kHz
├── TwoDigitDisplay.v        # 2-digit 7-segment display multiplexer
├── SevenSegment.v           # 4-bit to 7-segment decoder
├── Vending_TST.v            # Verilog testbench
├── Behav_Vending.png        # Behavioral simulation waveform screenshot
├── POST_Vending.png         # Post-implementation simulation waveform screenshot
└── Nexys4DDR_Master.xdc     # FPGA pin constraint file for Nexys4 DDR
```

---

## Module Descriptions

### `VendingMachin` (VendingMachine.v / VendingMachine (1).v)
The core FSM. Accepts clock, reset, and three coin inputs (N, D, Q) and outputs a `Candy` signal and a 6-bit `Number` representing change in cents.

**States:**

| State | Value | Meaning |
|-------|-------|---------|
| `ZERO` | 0 | 0¢ accumulated |
| `FIVE` | 1 | 5¢ |
| `TEN` | 2 | 10¢ |
| `FIFT` | 3 | 15¢ |
| `TWEN` | 4 | 20¢ |
| `TWFV` | 5 | 25¢ — dispense, 0¢ change |
| `THIRTY` | 6 | 30¢ — dispense, 5¢ change |
| `THIRFV` | 7 | 35¢ — dispense, 10¢ change |
| `FOURTY` | 8 | 40¢ — dispense, 15¢ change |
| `FRFIVE` | 9 | 45¢ — dispense, 20¢ change |
| `IDLE` | 10 | Post-dispense hold (version 1 only) |

- `Coin_Check` prevents state transitions if multiple coins are detected simultaneously.
- The two file versions differ in how dispensing states loop: version 1 transitions to a shared `IDLE` state; version 2 has each dispensing state self-loop.

---

### `Top_Design.v`
Wires all modules together for FPGA deployment.

- `CLK100MHZ` → `ClkDiv` → `ClkOut` (divided clock)
- `BTNL`, `BTNC`, `BTNR` → three `ButtonSync` instances → `N` (nickel), `D` (dime), `Q` (quarter)
- `BTNU` acts as reset throughout
- `VendingMachin` receives the synced coin signals and drives `LED[0]` (Candy) and `Number`
- `TwoDigitDisplay` takes `Number` and drives the 7-segment anode/cathode outputs

---

### `ButtonSync.v`
A 3-state FSM (WaitRise → PULSE → WaitFall) that produces a single-cycle high pulse for each button press, preventing multi-cycle triggering from a held button.

| State | Behavior |
|-------|----------|
| `WaitRise` | Waits for button to go high; output = 0 |
| `PULSE` | Outputs a single-cycle pulse (bo = 1) |
| `WaitFall` | Waits for button to be released; output = 0 |

---

### `ClkDiv.v`
Divides the 100 MHz board clock down to approximately 1 kHz using a 26-bit counter with a configurable `DivVal` parameter (default: `49999`).

---

### `TwoDigitDisplay.v`
Multiplexes two decimal digits onto the Nexys4's 8-digit 7-segment display at ~95 Hz. Separates the input number into tens and ones digits, then alternates between two display positions using the upper bits of a 20-bit counter.

---

### `SevenSegment.v`
Decodes a 4-bit input (0–9) to the 7-segment cathode signals (CA–CG). Values above 9 output `7'b1111111` (all segments off).

---

### `Vending_TST.v` (Testbench)
Simulates the following coin insertion sequences, each followed by a reset:

| Test | Coins | Total | Candy | Change |
|------|-------|-------|-------|--------|
| Multiple coins | N + D simultaneously | — | No | — |
| Exact change | N + D + D | 25¢ | Yes | 0¢ |
| 30¢ | N + N + D + D | 30¢ | Yes | 5¢ |
| 35¢ | D + Q | 35¢ | Yes | 10¢ |
| 40¢ | N + D + Q | 40¢ | Yes | 15¢ |
| 45¢ | N + N + D + Q | 45¢ | Yes | 20¢ |

---

## FPGA Button Mapping (Nexys4 DDR)

| Button | Signal | Coin |
|--------|--------|------|
| `BTNL` | N | Nickel (5¢) |
| `BTNC` | D | Dime (10¢) |
| `BTNR` | Q | Quarter (25¢) |
| `BTNU` | Rst | Reset |

**Output:**
- `LED[0]` — lights when candy is dispensed
- 7-segment display — shows change amount in cents (two decimal digits)

---

## Synthesis & Implementation

This project targets the **Nexys4 DDR** board (Xilinx Artix-7). Constraints are defined in `Nexys4DDR_Master.xdc`.

To implement in Vivado:
1. Create a new RTL project and add all `.v` files
2. Set `Top_Design` as the top module
3. Add `Nexys4DDR_Master.xdc` as the constraint file
4. Run Synthesis → Implementation → Generate Bitstream
5. Program the board via Vivado Hardware Manager

---

## Simulation

To run the testbench in Vivado:
1. Add `Vending_TST.v` as a simulation source
2. Run Behavioral Simulation
3. Compare waveform output against `Behav_Vending.png`
4. After implementation, run Post-Implementation Timing Simulation and compare against `POST_Vending.png`
