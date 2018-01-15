module rs232rx (
                input        clk,
                input        RX,
                output       TX,
                output [7:0] data,
                output       ready
                );
   parameter integer   BAUD_RATE = 9600;
   parameter integer   CLOCK_FREQ_HZ = 12000000;
   
   // number of clock cycles for serial bit half period
   localparam integer  HALF_PERIOD = CLOCK_FREQ_HZ / (2 * BAUD_RATE);

   // ---- Receiver data
   // shift reg for serial data read from FTDI
   reg [7:0]           buffer;

   // ---- Receiver state
   // counter with enough ticks for 3 half periods
   reg [$clog2(3*HALF_PERIOD):0] cycle_cnt;
   // received bit count
   reg [3:0]                     bit_cnt = 0;
   // attribute indicating we are receiving bits
   reg                           recv = 0;

   // ---- Receiver output regs (to connect to the bus)
   // last received byte, can read till new data overwrites it
   reg [7:0]           last_value;
   // data in buffer is valid on this cycle (pulse after data is received)
   reg                 buffer_valid;
   
   always @(posedge clk) begin
      buffer_valid <= 0;
      if (!recv) begin    // check we aren't currently receiving
         if (!RX) begin   // start bit = 0
	         // begin receiving: wait half period, reset bit count, mark as receiving
            cycle_cnt <= HALF_PERIOD;
            bit_cnt <= 0;
            recv <= 1;
         end
      end else begin
         if (cycle_cnt == 2*HALF_PERIOD) begin
	         // time to read next bit
            cycle_cnt <= 0;           // reset counter to 0 for next bit
            bit_cnt <= bit_cnt + 1;   // add next bit count
            if (bit_cnt == 9) begin
	            // we read all the bits
               buffer_valid <= 1;     // mark buffer as valid
               recv <= 0;             // reset receiving flag
               last_value <= buffer;  // copy data to output buffer
            end else begin
	            // put current bit into shift register
               buffer <= {RX, buffer[7:1]};
            end
         end else begin
	         // keep waiting for next bit
            cycle_cnt <= cycle_cnt + 1;
         end
      end
   end

   // mirror last value and byte flag to module output
   // we can use OE to only mirror data when asked and reset readiness 
   // flag after reading
   assign data = last_value;
   assign ready = buffer_valid;
   
   // echo everything
   assign TX = RX;
endmodule
