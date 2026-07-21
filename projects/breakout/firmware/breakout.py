# breakout.py
# Author: Yash Sharda
# Interactive controller for the WS2812 Breakout game on Shrike Lite.

import time
import shrike
from machine import Pin, SPI

# FPGA bring-up
# Make sure to replace with your actual generated bitstream name
shrike.flash("breakout.bin") 
