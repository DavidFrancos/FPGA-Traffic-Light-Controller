🚦 FPGA Traffic Light Controller with UART Communication

📌 Project Overview

This FPGA-based project implements a traffic light controller with UART communication. The system:

Controls LED-based traffic lights using a finite state machine (FSM).

Transmits the current traffic light state over UART to a connected PC.

Allows for a pedestrian button input to request a stop.

Uses the ICEBreaker FPGA and is written in Verilog.

⚡ Features

✅ Finite State Machine (FSM) Traffic Light Control✅ UART Communication (115200 baud rate)✅ Hardware Debounced Pedestrian Button✅ Debug LED to Indicate State Transitions✅ Fully Synthesizable on ICEBreaker FPGA

📜 Hardware Requirements

🖥️ ICEBreaker FPGA (Lattice iCE40UP5K)

🔴 3 LEDs (Red, Yellow, Green) for Traffic Lights

🕹️ 1 Button for Pedestrian Input

🖧 USB-UART Interface (FTDI/CH340)

🖥️ PC with a Serial Monitor (e.g., Tera Term, Minicom, or PuTTY)

🛠️ File Structure

FPGA_Projects/traffic_light_fpga/

│── traffic_light.v          # Main traffic light FSM

│── traffic_light_uart.v     # UART transmission module

│── constraints.pcf          # FPGA pin assignments

│── README.md                # Project documentation

💾 Synthesis & Programming (ICEBreaker FPGA)

Use the following commands to synthesize and upload the design:

yosys -p "synth_ice40 -top traffic_light -json traffic_light.json" traffic_light.v traffic_light_uart.v
nextpnr-ice40 --up5k --package sg48 --json traffic_light.json --pcf constraints.pcf --asc traffic_light.asc --pcf-allow-unconstrained
icepack traffic_light.asc traffic_light.bin
iceprog traffic_light.bin

📡 UART Communication

The FPGA sends the following messages over UART at 115200 baud rate:

----------------------------------------------------
Traffic Light State      |       UART Message
-------------------------|--------------------------
Green Light              |       "Green\n"
-------------------------|--------------------------
Yellow Light             |       "Yellow\n"
-------------------------|--------------------------
Red Light                |       "Red\n"
-------------------------|--------------------------
Pedestrian Stop          |       "Pedestrian\n"
-------------------------|--------------------------


🔍 How It Works

The system cycles through the standard traffic light states.

If the pedestrian button is pressed, the system transitions to red early.

UART transmits the current state whenever it changes.

The FSM ensures a realistic traffic light timing.



🚀 Future Improvements

Implement UART RX to allow PC control over the traffic lights.

Add PWM LED dimming for a more realistic effect.

Interface with a 7-segment display to show countdown timers.


Created by David Francos, inspired by real-world traffic light controllers.


