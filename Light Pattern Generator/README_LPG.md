# Light Pattern Generator FSM — Lab 5

A Verilog implementation of a light pattern generator finite state machine (FSM) deployed on a Nexys4 DDR FPGA board. Four LEDs animate in a bouncing scanner pattern, with a looping mode and an all-on/all-off flash finale.

---

## Overview

This lab implements a Moore-style FSM that drives four LEDs through a defined sequence: scanning forward from LED3 → LED0, then bouncing back LED1 → LED3. A `play` input controls whether the pattern loops continuously or terminates with all LEDs flashing on and off. Button presses are debounced and synchronized to a 1 Hz divided clock before being passed to the FSM.

---

## File Structure

```
Lab 5/Files Completed/
├── LightPatternGenrator.v   # Core light pattern FSM
├── ButtonSync.v             # Button debounce/sync FSM (one-shot pulse)
├── ClkDiv.v                 # Clock divider: 100 MHz → 1 Hz
├── Top_Design.v             # Top-level module connecting all components
├── Button_TST.v             # Testbench for ButtonSync
├── LPG_TST.v                # Testbench for LightPatternGenrator
├── Button.png               # ButtonSync simulation waveform screenshot
├── Post_Button.png          # Post-implementation ButtonSync waveform
├── Generator.png            # LPG behavioral simulation waveform screenshot
├── Post_LPG.png             # Post-implementation LPG waveform
└── Nexys4DDR_Master.xdc     # FPGA pin constraints for Nexys4 DDR
```

---

## Module Descriptions

### `LightPatternGenrator.v`
The core FSM. Drives four LED outputs (`ld3`–`ld0`) through a bouncing light sequence.

**States:**

| State | LEDs On | Description |
|-------|---------|-------------|
| `OFF` | None | Idle — waits for `start` to begin |
| `LED3f` | ld3 | Scan forward: step 1 |
| `LED2f` | ld2 | Scan forward: step 2 |
| `LED1f` | ld1 | Scan forward: step 3 |
| `LED0` | ld0 | Bounce point: rightmost LED |
| `LED1b` | ld1 | Scan back: step 1 |
| `LED2b` | ld2 | Scan back: step 2 |
| `LED3b` | ld3 | Scan back: step 3 — loop or finish |
| `ON` | All | Flash all LEDs on |
| `OFFr` | None | Flash all LEDs off — then back to `ON` |

**Control inputs:**

| Signal | Behavior |
|--------|----------|
| `start` | Triggers the FSM from `OFF` to begin the pattern |
| `reset` | Returns FSM to `OFF` state immediately |
| `play` | When high at `LED3b`, loops the pattern; when low, transitions to the flash finale (`ON`/`OFFr`) |

---

### `ButtonSync.v`
A 3-state FSM that converts a raw button level into a single-cycle pulse, preventing the FSM from registering multiple triggers from one button hold.

| State | Behavior |
|-------|----------|
| `WaitRise` | Waits for button high; output = 0 |
| `PULSE` | Outputs one-cycle pulse (bo = 1) |
| `WaitFall` | Waits for button release; output = 0 |

---

### `ClkDiv.v`
Divides the 100 MHz board clock to 1 Hz using a 26-bit counter with `DivVal = 49999999`. Each LED state persists for one full second, making the bounce pattern visible to the eye.

---

### `Top_Design.v`
Connects all modules for FPGA deployment.

- `CLK100MHZ` → `ClkDiv` → `ClkOut` (1 Hz)
- `BTND` → `ButtonSync` (reset = `BTNU`) → `bo` (play signal)
- `BTNC` → `start` input directly
- `BTNU` → `reset` input directly
- `LightPatternGenrator` drives `LED[3:0]`

---

## FPGA Button Mapping (Nexys4 DDR)

| Button | Signal | Function |
|--------|--------|----------|
| `BTNC` | start | Begin the light pattern |
| `BTND` | play input (synced) | Loop pattern when held at end of sequence |
| `BTNU` | reset | Reset FSM to OFF state |

**Output:** `LED[3:0]` — four rightmost LEDs on the Nexys4 board

---

## Testbenches

### `Button_TST.v`
Tests `ButtonSync` through 10 clock cycles with a button press held for several cycles, verifying that only a single pulse is produced per press. Reference waveform: `Button.png` / `Post_Button.png`.

### `LPG_TST.v`
Tests `LightPatternGenrator` through multiple scenarios:
- Reset then idle (no start)
- Full sequence without `play` (terminates at flash)
- Reset mid-sequence
- `play` asserted at different points in the bounce to trigger loop continuation

Reference waveforms: `Generator.png` / `Post_LPG.png`.

---

## Synthesis & Implementation

This project targets the **Nexys4 DDR** board (Xilinx Artix-7). Constraints are in `Nexys4DDR_Master.xdc`.

To implement in Vivado:
1. Create a new RTL project and add all `.v` source files
2. Set `Top_Design` as the top module
3. Add `Nexys4DDR_Master.xdc` as the constraint file
4. Run Synthesis → Implementation → Generate Bitstream
5. Program the board via Vivado Hardware Manager

---

## Simulation

To run either testbench in Vivado:
1. Add `Button_TST.v` or `LPG_TST.v` as a simulation source
2. Run Behavioral Simulation
3. Compare waveforms against the corresponding `.png` screenshots
4. Optionally run Post-Implementation Timing Simulation and compare against `Post_Button.png` / `Post_LPG.png`
