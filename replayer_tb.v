module testbench;
   reg clk;
   always #5 clk = (clk === 1'b0);

   reg start;
   reg count;
   reg [7:0] limit;
   wire [7:0] addr;
   wire       next;

   replayer #(
              .CLOCK_FREQ_HZ(1),
              .TICK_PER_SEC(3)
              )
   uut(
       .clk(clk),
       .start(start),
       .count(count),
       .limit(limit),
       .next(next),
       .addr(addr)
       );

   reg [4095:0] vcdfile;

   initial begin
		if ($value$plusargs("vcd=%s", vcdfile)) begin
			$dumpfile(vcdfile);
			$dumpvars(0, testbench);
		end

      start <= 0;
      count <= 0;
      limit <= 0;
      
		repeat (5) @ (posedge clk);
      limit <= 8'd13;
      start <= 1;
      @ (posedge clk);
      start <= 0;
      count <= 1;
      repeat (100) @(posedge clk);
      $finish;
   end // initial begin
endmodule // testbench
