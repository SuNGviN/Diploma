# Diploma
 A repository for the necessary files.

# Data Acquisition Module for CMOS Biosensors

This repository contains Verilog source files and testbenches for a data acquisition module that interfaces with multiple ADCs and a DAC via SPI. The project is part of a bachelor’s thesis at RTU MIREA (Russian Technological University), focusing on **collecting and processing data from CMOS biosensors**.

## Overview

- **SPI Master**  
  - Written in Verilog to communicate with multiple ADCs and a single DAC.  
  - Implements the necessary signals (SCLK, MOSI, MISO, CS) and control logic.  
  - Designed to handle 12-bit data transfers (configurable as needed).

- **Testbenches**  
  - Verify correct SPI functionality (timing, data alignment, chip select handling).  
  - Provide a simulated environment where MISO signals emulate the ADC outputs.  
  - Generate `.vcd` waveforms for debugging with tools like GTKWave.

- **Project Goal**  
  - Acquire analog signals from CMOS biosensors (via ADC).  
  - Perform initial data processing (e.g., filtering or scaling).  
  - Optionally output data to a DAC for analog feedback or further measurements.  
  - Transfer captured data to a PC or higher-level system (e.g., via FIFO or UART).
 
  - ## Simulation & Usage

1. **Install Icarus Verilog (iverilog)** or another Verilog simulator (e.g., ModelSim, QuestaSim, Vivado).  
2. **Compile and run** the testbench
