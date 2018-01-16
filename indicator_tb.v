module testbench;

   // define test signals
   reg clk;
   always #5 clk = (clk === 1'b0);

   reg [7:0] data;
   reg       ready;
   reg       reset;
   
   wire      LED1;
   wire      LED2;
   wire      LED3;
   wire      LED4;
   wire      LED5;

   // instantiate module
   indicator uut(
                 .clk(clk),
                 .reset(reset),
                 .data(data),
                 .ready(ready),
                 .leds({LED1, LED2, LED3, LED4, LED5})
                 );
   
   // define tasks if needed in terms of testbench signals
   task set_data;
      input [7:0] c;
      begin
         ready <= 0;
         repeat (5) @(posedge clk);
         ready <= 1;
         data <= c;
         repeat (1) @(posedge clk);
         ready <= 0;
         repeat (1) @(posedge clk);         
      end
   endtask // set_data

   task do_reset;
      begin
         @(posedge clk);
         reset <= 1;
         @(posedge clk);
         reset <= 0;
      end
   endtask // reset
   
   reg [4095:0] vcdfile;

   // define test
   initial begin
      // write simulation output to a file
		if ($value$plusargs("vcd=%s", vcdfile)) begin
			$dumpfile(vcdfile);
			$dumpvars(0, testbench);
		end

      // test sequence

      // initial delay
      repeat (100) @(posedge clk);

      set_data("1");
      set_data("2");
      set_data("2");

      do_reset();

      set_data("1");
      
      repeat (100) @(posedge clk);
      
      // end simulation sequence
      $finish;
   end
endmodule
