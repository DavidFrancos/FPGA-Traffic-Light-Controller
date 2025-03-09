module traffic_light_uartrx (
    input wire clk, 
    input wire rx,
    output reg [7:0] pcInput
);
reg signed [7:0] baudCounter = 0;
initial pcInput = 0;
reg [7:0] message = 0;
reg idle = 1;
reg [3:0] sending = 0;

always @(posedge clk) begin
    if (rx == 0 && idle) begin
        idle <= 0;
        baudCounter <= -52;
    end
    if (!idle) begin
        baudCounter <= baudCounter + 1;
        if (baudCounter == 104) begin
            baudCounter <= 0;
            if (sending < 8) begin
                message <= {rx, message[7:1]};
                sending <= sending + 1;
            end
            else begin
                pcInput <= message;
                sending <= 0;
                idle <= 1;
            end
        end
    end
end

endmodule