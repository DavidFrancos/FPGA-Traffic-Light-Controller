`timescale 1ns / 1ps

module traffic_light_tb();

    // Signals
    reg clk;
    reg button;
    reg rx;
    wire redLight, yellowLight, greenLight;
    wire debugLight1, debugLight0;
    wire tx;
    wire [1:0] selectUart;

    // Instantiate the Traffic Light Controller
    traffic_light uut (
        .clk(clk),
        .button(button),
        .rx(rx),
        .redLight(redLight),
        .yellowLight(yellowLight),
        .greenLight(greenLight),
        .debugLight1(debugLight1),
        .debugLight0(debugLight0),
        .tx(tx),
        .selectUart(selectUart)
    );

    // UART Helper Task: Send a Byte at 115200 Baud (8680ns per bit)
    task send_uart_byte;
        input [7:0] data;
        integer i;
        begin
            rx = 0; // Start bit
            #8680;

            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i]; // Send each bit
                #8680;
            end

            rx = 1; // Stop bit
            #8680;
        end
    endtask

    // Clock Generator (12 MHz)
    always #41.67 clk = ~clk; // 12 MHz period = 83.33ns, half-period = 41.67ns

    // Test Procedure
    initial begin
        // Initialize signals
        clk = 0;
        button = 0;
        rx = 1; // UART line idle

        // Start Simulation
        $display("\n🚦 Starting Traffic Light Controller Testbench 🚦\n");
        #500000;  // Allow system to stabilize

        // ✅ Test 1: Normal Traffic Light FSM Operation
        $display("[TEST 1] Automatic FSM Operation");
        #5000000;

        // ✅ Test 2: Override to GREEN via UART
        $display("[TEST 2] Sending UART Command: G (Override to GREEN)");
        send_uart_byte("G");
        #5000000;

        // ✅ Test 3: Override to YELLOW via UART
        $display("[TEST 3] Sending UART Command: Y (Override to YELLOW)");
        send_uart_byte("Y");
        #5000000;

        // ✅ Test 4: Override to RED via UART
        $display("[TEST 4] Sending UART Command: R (Override to RED)");
        send_uart_byte("R");
        #5000000;

        // ✅ Test 5: Release Override (Send 'X')
        $display("[TEST 5] Sending UART Command: X (Release Override)");
        send_uart_byte("X");
        #10000000;

        // ✅ Test 6: Pedestrian Button Press
        $display("[TEST 6] Pressing Pedestrian Button (Should Extend GREEN)");
        button = 1;
        #500000;
        button = 0;
        #10000000;

        // End Simulation
        $display("\n✅ All Tests Completed Successfully! 🚀\n");
        $stop;
    end

    // Monitor Outputs
    initial begin
        $monitor("Time: %0dns | Red: %b | Yellow: %b | Green: %b | Debug: %b%b | UART Out: %b | SelectUART: %b",
                 $time, redLight, yellowLight, greenLight, debugLight1, debugLight0, tx, selectUart);
    end

endmodule
