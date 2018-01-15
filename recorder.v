module recorder(
                clk,
                enable,
                ready,
                data_in,
                addr,
                data_out,
                write,
                limit
                );
   // control
   input        clk;
   input        enable;
   // serial interface
   input        ready;
   input [7:0]  data_in;
   // memory writes
   output [7:0] addr;
   output [7:0] data_out;
   output       write;
   // replayer info
   output reg [7:0] limit = 0;
   
   always @(posedge clk) begin
      if (ready & enable) begin
         // increment counter on next tick
         limit <= limit + 1;
      end
   end

   assign addr = (enable & ready) ? limit : 8'bz;
   assign data_out = (enable & ready) ? data_in : 8'bz;
   assign write = (enable & ready);
   
endmodule // recorder
