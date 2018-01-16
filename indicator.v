module indicator(input            clk,
                 input            reset, 
                 input [7:0]      data,
                 input            ready,
                 output reg [0:4] leds
                 );

initial begin
   leds = 5'b0;
end

always @(posedge clk) begin
   if (reset) begin
      leds <= 5'b0;
   end else if (ready) begin
      if (data == "1") leds[0] <= !leds[0];
      if (data == "2") leds[1] <= !leds[1];
      if (data == "3") leds[2] <= !leds[2];
      if (data == "4") leds[3] <= !leds[3];
      if (data == "5") leds[4] <= !leds[4];
   end
end
   
endmodule // indicator
