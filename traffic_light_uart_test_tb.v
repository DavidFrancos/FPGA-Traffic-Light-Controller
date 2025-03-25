`timescale 1ns/1ps

module traffic_light_uart_test_tb ();
    
    reg clk = 0;
    reg rx = 0;
    wire led, ledError;

    traffic_light_uart_test uut (
        .clk(clk),
        .rx(rx),
        .led(led),
        .ledError(ledError)
    );


    always #41.66 clk = ~clk;

    initial begin
        $dumpfile("traffic_light_uart_test_tb.vcd");  
        $dumpvars(0, traffic_light_uart_test_tb);

        clk = 0;
        #1000000000

        $stop;
    end



endmodule