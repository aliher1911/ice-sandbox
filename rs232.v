module top (input  clk,
            input  RX,
            output TX,
            output LED1,
            output LED2,
            output LED3,
            output LED4,
            output LED5
            );
   // memory/indicator data bus
   wire [7:0]           data;
   // memory address bus
   wire [7:0]           addr;
   // memory control signals
   wire                 read;
   wire                 write;
   // component enablers
   wire                 record;
   wire                 replay;
   wire                 replay_start;

   // indicator data selection
   wire                 indicator_ready;
   wire                 serial_ready;
   wire                 memory_ready;                
   
   // input data and readiness
   wire                 ready;
   wire [7:0]           serial_data;
   // number of chars in seq
   wire [7:0]           limit;
   
   // sequencer defined a FSM of operation
   sequencer seq(
                 .clk(clk),
                 .ready(ready),
                 .data(serial_data),
                 .replay_start(replay_start),
                 .replay_en(replay),
                 .record_en(record)
                 );
   
   // should have rs232 module to receive data (has reg on output)
   rs232rx recv(
                .clk(clk),
                .RX(RX),
                .TX(TX),
                .data(serial_data),
                .ready(ready));

   // recorder
   recorder rec(
                .clk(clk),
                .enable(record),
                .ready(ready),
                .data_in(serial_data),
                .addr(addr),
                .data_out(data),
                .write(write),
                .limit(limit)
                );

   // replayer
   replayer play(
                 .clk(clk),
                 .enable(replay),
                 .start(replay_start),
                 .limit(limit),
                 .read(read),
                 .ready(memory_ready),
                 .addr(addr)
                 );
   
   // memory
   memory mem(
              .clk(clk),
              .rd(read),
              .wr(write),
              .addr(addr),
              .data(data)
              );
   
   // led module to show data, has internal  reg to show data if valid  
   indicator show(
                  .clk(clk),
                  .data(data),
                  .ready(indicator_ready),
                  .leds({LED1, LED2, LED3, LED4, LED5})
                  );

   assign indicator_ready = memory_ready | write;
   
endmodule // top
