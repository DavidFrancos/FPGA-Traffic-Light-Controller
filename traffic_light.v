module traffic_light (
    input wire clk, button, rx,
    output reg redLight, yellowLight, greenLight, debugLight1, debugLight0, tx,
    output reg [1:0] selectUart
);

reg [23:0] counter = 0;
reg [2:0] secCounter = 0;
reg [2:0] trafficLightStates = 3'b100; // 100 - go, 110 - prepare to stop, 001 - full stop
reg error = 0;
reg buttonStable = 0;
reg buttonPressed = 0;
reg override = 0;
reg overridden = 0;
reg [2:0] overrideState = 0;
wire [7:0] pcInput;

traffic_light_uarttx uarttx_module (
    .clk(clk),
    .selectUart(selectUart),
    .tx(tx)
);

traffic_light_uartrx uartrx_module (
    .clk(clk),
    .pcInput(pcInput),
    .rx(rx)
);

always @(posedge clk) begin
    case (pcInput)
        "G": begin
            overrideState <= 3'b100;
            override <= 1;
            {debugLight0,debugLight1} <= 2'b11;
        end
        "Y": begin
            overrideState <= 3'b110;
            override <= 1;
            {debugLight0,debugLight1} <= 2'b10;
        end
        "R": begin
            overrideState <= 3'b001;
            override <= 1;
            {debugLight0,debugLight1} <= 2'b01;
        end
        "X": begin
            override <= 0;
            {debugLight0,debugLight1} <= 2'b00;
        end
    endcase
    counter <= counter + 1;
    if (button && !buttonStable && !buttonPressed) begin
        buttonStable <= 1;
        selectUart <= 2'b11;
    end
    if (override && !overridden) begin
        override <= 0;
        overridden <= 1;
        trafficLightStates <= overrideState;
        counter <= 0;
        secCounter <= 0;
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
                    overridden <= 0;
                    trafficLightStates <= 3'b110;
                    selectUart <= 2'b01;
                end
            end
            3'b110: begin
                if (secCounter >= 1) begin
                    secCounter <= 0;
                    overridden <= 0;
                    trafficLightStates <= 3'b001;
                    selectUart <= 2'b10;
                end
            end
            3'b001: begin
                buttonStable <= 0;
                buttonPressed <= 0;
                if (secCounter >= 3) begin
                    secCounter <= 0;
                    overridden <= 0;
                    trafficLightStates <= 3'b100;
                    selectUart <= 2'b00;
                end
            end
        endcase
    end
    greenLight <= trafficLightStates[0];
    yellowLight <= trafficLightStates[1];
    redLight <= trafficLightStates[2];
end
endmodule