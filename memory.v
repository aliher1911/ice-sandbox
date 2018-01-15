module memory(
              input       clk,
              input       rd,
              input       wr,
              input [7:0] addr,
              inout [7:0] data
              );

   // data storage
   reg [7:0]              array [0:255];
   // output
   reg [7:0]              out;
   reg                    ready;

   always @(posedge clk) begin
      ready <= 0;
      if (wr) begin
         // writing to memory
         array[addr] <= data;
      end else if (rd) begin
         // reading from memory
         out <= array[addr];
         ready <= 1;
      end
   end

   // send data from output conveyor
   assign data = (ready) ? out : {8{1'bz}};

endmodule // memory
