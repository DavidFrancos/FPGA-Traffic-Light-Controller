🚦 FPGA Traffic Light Controller with Dual UART Communication
📌 Project Overview
This FPGA-based project implements a traffic light controller with dual UART communication, allowing a PC to override traffic signals while maintaining standard automatic control. The system:

✅ Controls LED-based traffic lights using a finite state machine (FSM).
✅ Transmits the current traffic light state over UART TX to a connected PC.
✅ Receives commands via UART RX to manually override traffic lights.
✅ Allows for a pedestrian button input to request a stop.
✅ Runs on the ICEBreaker FPGA, written in Verilog.

⚡ Features
✅ Dual UART Communication (115200 baud rate)
✅ Finite State Machine (FSM) for Traffic Light Control
✅ Manual Override via UART (PC can control the lights)
✅ Pedestrian Button for Walk Request
✅ Hardware Debounced Inputs
✅ Debug LEDs to Indicate Transitions & UART Communication
✅ Fully Synthesizable on ICEBreaker FPGA

📜 Hardware Requirements
🖥️ ICEBreaker FPGA (Lattice iCE40UP5K)
🔴 3 LEDs (Red, Yellow, Green) for traffic light status
🕹️ 1 Button for pedestrian input
🖧 USB-UART Interface (FTDI/CH340)
🖥️ PC with Serial Monitor (e.g., Tera Term, Minicom, or PuTTY)

🛠 File Structure

FPGA_Projects/traffic_light_dual_uart/
│── traffic_light.v        # Main traffic light FSM & UART control
│── traffic_light_uartrx.v # UART receiver module (PC → FPGA)
│── traffic_light_uarttx.v # UART transmitter module (FPGA → PC)
│── constraints.pcf        # FPGA pin assignments
│── README.md              # Project documentation
💾 Synthesis & Programming (ICEBreaker FPGA)
Use the following commands to synthesize and upload the design:

yosys -p "synth_ice40 -top traffic_light -json traffic_light.json" traffic_light.v traffic_light_uartrx.v traffic_light_uarttx.v
nextpnr-ice40 --up5k --package sg48 --json traffic_light.json --pcf constraints.pcf --asc traffic_light.asc --pcf-allow-unconstrained
icepack traffic_light.asc traffic_light.bin
iceprog traffic_light.bin

📡 UART Communication Protocol
Traffic Light State	UART TX Message (FPGA → PC)	UART RX Command (PC → FPGA)

Green Light	"Green\n"	"G" – Override to Green

Yellow Light	"Yellow\n"	"Y" – Override to Yellow

Red Light	"Red\n"	"R" – Override to Red

"X" – Release Override

✅ Manual Override:

The PC can send "G", "Y", or "R" to force a traffic light state change.
The system will remain in override mode until it receives an "X" command.

✅ Automatic Mode:

If no override is active, the traffic light cycles normally through Green → Yellow → Red.
If the pedestrian button is pressed, it forces a transition to Red before continuing the normal cycle.

🔍 How It Works
1️⃣ Default Operation: The system cycles through the standard traffic light states automatically.
2️⃣ Manual Override (via UART RX): The PC can send "G", "Y", or "R" to override the traffic light state.
3️⃣ Release Override (via UART RX): The "X" command returns the system to normal FSM control.
4️⃣ Pedestrian Button: A button press interrupts normal operation, forcing the light to Red early before resuming.
5️⃣ Debug LEDs: Indicate current state transitions and UART activity.


📌 Created by David Francos
Inspired by real-world traffic light controllers and implemented in pure Verilog on an FPGA.
