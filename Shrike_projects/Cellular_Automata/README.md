# Cellular Automata on Shrike-Lite FPGA

A hardware implementation of one-dimensional cellular automata running entirely on the Shrike-Lite FPGA. No microcontroller, firmware, or software is involved—the SLG47910 generates each automaton state and directly drives a 4×4 WS2812 LED matrix.

The project demonstrates how complex patterns can emerge from very simple logic rules implemented purely in hardware.

## Overview

The display shows successive generations of a one-dimensional cellular automaton on a 4×4 LED matrix.

For every new generation, each cell examines a three-cell neighbourhood consisting of:

* Left neighbour
* Current cell
* Right neighbour

These three bits form one of eight possible input patterns. An 8-bit rule determines whether the output cell for each pattern will be alive or dead in the next generation.

The newly generated row is inserted at the top of the display while older generations shift downward, creating a scrolling visualization of the automaton's evolution.

Changing the rule completely changes the behaviour of the system, from highly ordered structures to chaotic patterns.

## Selectable Rules

| Switch | Rule     | Colour | Description                                                                                                                                   |
| ------ | -------- | ------ | --------------------------------------------------------------------------------------------------------------------------------------------- |
| SW0    | Rule 30  | Red    | Chaotic and unpredictable. Produces complex patterns from simple initial conditions and has been studied as a pseudo-random number generator. |
| SW1    | Rule 90  | Green  | Generates the classic Sierpinski triangle fractal with strong symmetry and self-similarity.                                                   |
| SW2    | Rule 110 | White  | Exhibits highly complex behaviour. Notably, Rule 110 has been proven to be Turing complete.                                                   |
| SW3    | Rule 45  | Amber  | Produces semi-chaotic structures with characteristics similar to Rule 30 but a distinct visual appearance.                                    |

Rules can be changed at any time using the slide switches, allowing real-time observation of different automaton behaviours.

## Hardware

* Shrike-Lite development board (SLG47910 FPGA)
* 4×4 WS2812 RGB LED matrix
* Four slide switches for rule selection
