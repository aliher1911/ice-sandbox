module replayer(
                input        clk,
                input        start,
                input        count, 
                input [7:0]  limit,
                output reg   next,
                output [7:0] addr
                );
   parameter real      TICK_PER_SEC = 1; // once a sec
   parameter integer   CLOCK_FREQ_HZ = 12000000; // per sec

   // delay in clock
   localparam integer  PERIOD = CLOCK_FREQ_HZ * TICK_PER_SEC;

   // delay count
   reg [$clog2(PERIOD):0] cycle_cnt;
   reg [7:0]              seq;

   always @(posedge clk) begin
      next <= 0;
      if (start) begin
         // initialize
         seq <= 0;
         cycle_cnt <= 0;
         next <= 1;
      end else begin
         if (count) begin
            // if counting
            if (cycle_cnt == PERIOD) begin
               // if we reached tick counter, reset it and bump seq
               cycle_cnt <= 0;
               next <= 1;
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

   // output bus only if counting
   assign addr = count ? seq : 8'bz;
   
endmodule // replayer
