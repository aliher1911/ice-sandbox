module replayer(
                input        clk,
                input        enable, 
                input        start,
                input [7:0]  limit,
                output reg   read,  // memory read signal
                output reg   ready, // data ready on the bus
                output [7:0] addr
                );
   parameter real      TICK_PER_SEC = 1; // once a sec
   parameter integer   CLOCK_FREQ_HZ = 12000000; // per sec

   // delay in clock
   localparam integer  PERIOD = CLOCK_FREQ_HZ * TICK_PER_SEC;

   // delay enable
   reg [$clog2(PERIOD):0] cycle_cnt;
   reg [7:0]              seq;

   always @(posedge clk) begin
      read <= 0;
      if (start) begin
         // initialize
         seq <= 0;
         cycle_cnt <= 0;
         read <= 1;
      end else begin
         if (enable) begin
            // if replaying
            if (cycle_cnt == PERIOD) begin
               // if we reached tick enableer, reset it and bump seq
               cycle_cnt <= 0;
               read <= 1;
               if (seq == (limit - 1)) begin
                  // seq reached end, reset
                  seq <= 0;
               end else begin
                  // bump seq
                  seq <= seq + 1;
               end
            end else begin // if (cycle_cnt == PERIOD)
               // advance counter
               cycle_cnt <= cycle_cnt + 1;
            end
         end
      end
   end

   always @(posedge clk) ready <= read;
   
   // output bus only if enabled
   assign addr = enable ? seq : 8'bz;
   
endmodule // replayer
