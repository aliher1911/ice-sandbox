module top (input      clk,
            input      RX,
            output     TX,
            output reg LED1,
            output reg LED2,
            output reg LED3,
            output reg LED4,
            output reg LED5
            );
   // wires between blocks and ready signal from rs323 to led
   wire [7:0]           data;
   // input data readiness
   wire                 ready;
   
   // should have rs232 module to receive data (has reg on output)
   rs232rx recv(clk, RX, TX, data, ready);

   // led module to show data, has internal  reg to show data if valid  
   indicator show(
                  .clk(clk),
                  .data(data),
                  .ready(ready),
                  .leds({LED1, LED2, LED3, LED4, LED5})
                  );
   
endmodule // top
