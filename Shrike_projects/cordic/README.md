# CORDIC Math Coprocessor — Shrike Lite (SLG47910)

A 4-mode fixed-point math coprocessor implemented on the Shrike Lite FPGA from Vicharak. The host (RP2040) sends a single 8-bit SPI command and reads back the result.

---

## Modes

The top 2 bits of the command byte select the operation. The lower 6 bits carry the operand.

| Mode | Operation  | Engine                        |
|------|------------|-------------------------------|
| 00   | Cosine     | CORDIC circular rotation      |
| 01   | Sine       | CORDIC circular rotation      |
| 10   | Multiply   | Shift-and-add (3-bit operands)|
| 11   | Tangent    | Cascaded sin/cos divider      |

Valid angle range: **0 to 45 degrees**. All values are Q1.6 fixed-point (divide raw output by 64 to get float).

---

## Packet Format

```
[ 7:6 ]  mode select
[ 5:0 ]  operand

Trig  : bits[5:0] = angle in Q1.6 (e.g. 30 deg → int(0.5236 * 64) = 33)
MUL   : bits[5:3] = operand A (3-bit signed), bits[2:0] = operand B (3-bit signed)
```

---

## File Structure

```
cordic_circular.v   CORDIC rotation core, computes sin and cos
cordic_divide.v     Linear vectoring for division (tangent)
cordic_multiply.v   Shift-and-add integer multiplier
spi_target.v        SPI peripheral, configurable CPOL/CPHA/width
top.v               Top-level
cordic.py           MicroPython (RP2040)
```

---

## Architecture Notes

- All arithmetic is Q1.6 fixed-point. Accumulators inside `cordic_circular` are extended to 12-bit internally to prevent overflow across the 7 rotation iterations.
- The angle input uses **zero-padding** (not sign extension) on the top 2 bits. Sign-extending caused positive angles above 30° to be misinterpreted as negative during intermediate CORDIC subtractions.
- Tangent is cascaded: Mode 11 fires `cordic_circular` first, then `cordic_divide` triggers automatically on `circ_done`.

---

## Validation

Tested with 80 vectors via the MicroPython test across all four modes.

| Mode      | Max Absolute Error |
|-----------|--------------------|
| Cosine    | 0.019              |
| Sine      | 0.019              |
| Tangent   | 0.071              |
| Multiply  | 0.000000           |

---

## Target Platform

- FPGA: Vicharak Shrike Lite 
- Host: RP2040 over SPI at 1 MHz, CPOL=0 CPHA=0
