module traffic_light (
    input wire clk, button,
    output reg redLight, yellowLight, greenLight, debugLight1, debugLight0,
    output reg [1:0] selectUart,
    output reg tx
);

reg [23:0] counter = 0;
reg [2:0] secCounter = 0;
reg [2:0] trafficLightStates = 3'b100; // 100 - go, 110 - prepare to stop, 001 - full stop
reg error = 0;
reg buttonStable = 0;
reg buttonPressed = 0;

traffic_light_uart uart_module (
    .clk(clk),
    .selectUart(selectUart),
    .tx(tx)
);
 
always @(posedge clk) begin
    counter <= counter + 1;
    if (button && !buttonStable && !buttonPressed) begin
        buttonStable <= 1;
        selectUart <= 2'b11;
    end
    if (counter == 12000000) begin
        counter <= 0;
        secCounter <= secCounter + 1;
        case (trafficLightStates)
            3'b100: begin
                if (buttonStable) begin
                    counter <= 11999999;
                    buttonPressed <= 1;
                end
                if (secCounter >= 3) begin
                    secCounter <= 0;
                    trafficLightStates <= 3'b110;
                    selectUart <= 2'b01;
                end
            end
            3'b110: begin
                if (secCounter >= 1) begin
                    secCounter <= 0;
                    trafficLightStates <= 3'b001;
                    selectUart <= 2'b10;
                end
            end
            3'b001: begin
                buttonStable <= 0;
                buttonPressed <= 0;
                if (secCounter >= 3) begin
                    secCounter <= 0;
                    trafficLightStates <= 3'b100;
                    selectUart <= 2'b00;
                end
            end
        endcase
    end
    greenLight <= trafficLightStates[0];
    yellowLight <= trafficLightStates[1];
    redLight <= trafficLightStates[2];
    {debugLight1,debugLight0} <= selectUart;
end




endmodule