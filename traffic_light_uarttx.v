module traffic_light_uarttx (
    input wire clk, 
    input wire [1:0] selectUart,
    output reg tx
);
reg [23:0] counter = 0;
reg [1:0] prevSelectUart = 1;
reg [6:0] baudCounter = 0;
reg [7:0] message [10:0];
reg stop = 0;
reg start = 1;
reg [3:0] sending = 0;
reg [3:0] index = 0;
reg [3:0] messageLength;
reg [7:0] tempShift;
integer i;
initial begin
    tx = 1;
end 


always @(posedge clk) begin
    case (selectUart)
        2'b00: begin
            message[0] <= "G";
            message[1] <= "r";
            message[2] <= "e";
            message[3] <= "e";
            message[4] <= "n";
            message[5] <= " ";
            message[6] <= 8'd0;
            message[7] <= 8'd0;
            message[8] <= 8'd0;
            message[9] <= 8'd0;
            message[10] <= 8'd0;
            messageLength <= 6;
        end
        2'b01: begin
            message[0] <= "Y";
            message[1] <= "e";
            message[2] <= "l";
            message[3] <= "l";
            message[4] <= "o";
            message[5] <= "w";
            message[6] <= " ";
            message[7] <= 8'd0;
            message[8] <= 8'd0;
            message[9] <= 8'd0;
            message[10] <= 8'd0;
            messageLength <= 7;
        end
        2'b10: begin
            message[0] <= "R";
            message[1] <= "e";
            message[2] <= "d";
            message[3] <= " ";
            message[4] <= 8'd0;
            message[5] <= 8'd0;
            message[6] <= 8'd0;
            message[7] <= 8'd0;
            message[8] <= 8'd0;
            message[9] <= 8'd0;
            message[10] <= 8'd0;
            messageLength <= 4;
        end
        2'b11: begin
            message[0] <= "P";
            message[1] <= "e";
            message[2] <= "d";
            message[3] <= "e";
            message[4] <= "s";
            message[5] <= "t";
            message[6] <= "r";
            message[7] <= "i";
            message[8] <= "a";
            message[9] <= "n";
            message[10] <= " ";
            messageLength <= 11;
        end 
    endcase
    baudCounter <= baudCounter + 1;
    if (baudCounter >= 104) begin
        baudCounter <= 0;
        if (index == messageLength || selectUart == prevSelectUart) begin 
            tx <= 1;
            index <= 0;
            prevSelectUart <= selectUart;
        end
        else if (start) begin
            tx <= 0;
            start <= 0;
        end
        else if (stop) begin
            stop <= 0;
            sending <= 0;
            start <= 1;
        end
        else begin
            if (sending < 8) begin
                tx <= tempShift[0];  
                tempShift <= tempShift >> 1;
                sending <= sending + 1;
            end
            else begin
                stop <= 1;
                tx <= 1;
                index <= index + 1;
                tempShift <= message[index];
            end
        end
    end
end

endmodule