module traffic_light (
    input wire clk, button, rx,
    output reg redLight, yellowLight, greenLight, tx, a,b,c,d,e,f,g,
    output reg [1:0] selectUart
);

reg [23:0] counter = 0;
reg [2:0] secCounter = 0;
reg [2:0] secCounterDisplay = 3'd4;
reg [2:0] trafficLightStates = 3'b100; // 100 - go, 110 - prepare to stop, 001 - full stop
reg error = 0;
reg buttonStable = 0;
reg buttonPressed = 0;
reg override = 0;
reg overridden = 0;
reg [2:0] overrideState = 0;
wire [7:0] pcInput;
reg [7:0] segmentDisplay = 0;
assign unused = 0;

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
        end
        "Y": begin
            overrideState <= 3'b110;
            override <= 1;
        end
        "R": begin
            overrideState <= 3'b001;
            override <= 1;
        end
        "X": begin
            override <= 0;
        end
    endcase



    counter <= counter + 1;



    if (button && !buttonStable && !buttonPressed) begin
        buttonStable <= 1;
        selectUart <= 2'b11;
        secCounterDisplay <= secCounterDisplay - 1;
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
    end
        case (trafficLightStates)
            3'b100: begin
                if (buttonStable) begin
                    buttonPressed <= 1;
                    secCounter <= secCounter + 1;
                    buttonStable <= 0;
                end
                else if (secCounter >= 4) begin
                    secCounter <= 0;
                    overridden <= 0;
                    trafficLightStates <= 3'b110;
                    selectUart <= 2'b01;
                end
            end
            3'b110: begin;
                if (secCounter >= 2) begin
                    secCounter <= 0; 
                    overridden <= 0;
                    trafficLightStates <= 3'b001;
                    selectUart <= 2'b10;
                end
            end
            3'b001: begin
                if (secCounter >= 4) begin
                    secCounter <= 0;
                    overridden <= 0;
                    trafficLightStates <= 3'b100;
                    selectUart <= 2'b00;     
                    buttonPressed <= 0;  
                end
            end
        endcase

    case (trafficLightStates)
        3'b100: secCounterDisplay <= 4 - secCounter;
        3'b110: secCounterDisplay <= 2 - secCounter;
        3'b001: secCounterDisplay <= 4 - secCounter;
    endcase

    case (secCounterDisplay) // 7 segment second display
        3'd0: segmentDisplay <= 7'b1111110; //0
        3'd1: segmentDisplay <= 7'b0110000; //1
        3'd2: segmentDisplay <= 7'b1101101; //2 
        3'd3: segmentDisplay <= 7'b1111001; //3
        3'd4: segmentDisplay <= 7'b0110011; //4
        3'd5: segmentDisplay <= 7'b1011011; //5
        3'd6: segmentDisplay <= 7'b1011111; //6
        3'd7: segmentDisplay <= 7'b1110000; //7
        3'd8: segmentDisplay <= 7'b1111111; //8
        3'd9: segmentDisplay <= 7'b1111011; //9
        default: segmentDisplay <= 7'b0000000;
    endcase
    if (override) segmentDisplay <= 0;

    {a,b,c,d,e,f,g} = ~segmentDisplay;
    greenLight <= trafficLightStates[0];
    yellowLight <= trafficLightStates[1];
    redLight <= trafficLightStates[2];
end
endmodule

