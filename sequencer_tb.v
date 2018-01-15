module testbench;

	reg                clk;
	always #5 clk = (clk === 1'b0);

   reg                ready;
   reg [7:0]          data;
   wire               start;
   wire               replay;
   wire               record;
   
   sequencer uut(
                 .clk(clk),
                 .ready(ready),
                 .data(data),
                 .replay_start(start),
                 .replay_en(replay),
                 .record_en(record)
                 );

   	reg [4095:0] vcdfile;

	initial begin
		if ($value$plusargs("vcd=%s", vcdfile)) begin
			$dumpfile(vcdfile);
			$dumpvars(0, testbench);
		end

		repeat (10) @(posedge clk);

      // init
      ready <= 0;
      data <= 0;

      // feed some data
		@(posedge clk);
      data <= "1";
      ready <= 1;
		@(posedge clk);
      ready <= 0;
		repeat (5) @(posedge clk);
      
      // feed end marker
		@(posedge clk);
      data <= "0";
      ready <= 1;
		@(posedge clk);
      ready <= 0;
		repeat (5) @(posedge clk);

      // feed more data
		@(posedge clk);
      data <= "2";
      ready <= 1;
		@(posedge clk);
      ready <= 0;
		repeat (5) @(posedge clk);
      
      // feed end marker again
		@(posedge clk);
      data <= "0";
      ready <= 1;
		@(posedge clk);
      ready <= 0;
		repeat (5) @(posedge clk);

      $finish;
   end
endmodule // testbench

