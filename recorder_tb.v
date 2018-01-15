module testbench;
   reg clk;
   always #5 clk = (clk === 1'b0);

   reg enable;
   reg ready;
   reg [7:0] data_in;
   wire [7:0] addr;
   wire [7:0] data_out;
   wire write;
   wire [7:0] limit;
   
   recorder uut(
                .clk(clk),
                .enable(enable),
                .ready(ready),
                .data_in(data_in),
                .addr(addr),
                .data_out(data_out),
                .write(write),
                .limit(limit)
                );

	task send_byte;
		input [7:0] c;

		begin
         @(posedge clk);
         data_in <= c;
         ready <= 1;
         @(posedge clk);
         data_in <= "X";
         ready <= 0;
		end
	endtask
   
   reg [4095:0] vcdfile;

   initial begin
		if ($value$plusargs("vcd=%s", vcdfile)) begin
			$dumpfile(vcdfile);
			$dumpvars(0, testbench);
		end

      @(posedge clk);
      enable <= 1;
      
      send_byte("1");
      repeat (5) @(posedge clk);
      send_byte("3");
      
      repeat (5) @(posedge clk);
      enable <= 0;
      
      send_byte("5");
      repeat (5) @(posedge clk);

      $finish;
   end

endmodule // testbench
