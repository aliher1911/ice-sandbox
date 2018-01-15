module testbench;

   reg clk;
   always #5 clk = (clk === 1'b0);

   reg rd;
   reg wr;
   
   reg [7:0] addr_bus;
   wire [7:0] data_bus;
   reg [7:0]  data_reg;

   assign data_bus = wr ? data_reg : {8{1'bz}};
   
   memory uut(
              .clk(clk),
              .rd(rd),
              .wr(wr),
              .addr(addr_bus),
              .data(data_bus)
              );

   task write_byte;
      input [7:0] addr;
      input [7:0] data;
      begin
         $display("Write %h to %h", data, addr);
         @ (posedge clk);
         addr_bus <= addr;
         data_reg <= data;
         wr <= 1;
         rd <= 0;
         @ (posedge clk);
         addr_bus <= 8'b0;
         wr <= 0;
      end
   endtask // write_byte

   task read_byte;
      input [7:0] addr;
      begin
         $display("Read from %h", addr);
         @ (posedge clk);
         addr_bus <= addr;
         wr <= 0;
         rd <= 1;
         @ (posedge clk);
         addr_bus <= 8'b0;
         rd <= 0;
      end
   endtask // read_byte
   
   reg [4095:0] vcdfile;

   initial begin
		if ($value$plusargs("vcd=%s", vcdfile)) begin
			$dumpfile(vcdfile);
			$dumpvars(0, testbench);
		end

      $display("Begin simulation");
		repeat (5) @(posedge clk);

      // write data
      write_byte(1, 8'hAA);
      // read data
      read_byte(1);
      // write new
      write_byte(2, 8'hCC);
      // read new
      read_byte(2);
      // read old
      read_byte(1);

		repeat (5) @(posedge clk);
      $finish;
   end // initial begin
endmodule // testbench
