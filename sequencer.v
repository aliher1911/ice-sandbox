module sequencer(
                 clk,
                 
                 // serial data for end of sequence detection
                 ready,
                 data,

                 // sequencing of data
                 replay_start,
                 replay_en,
                 record_en,
                 );
   
   input clk;
   
   // serial data for end of sequence detection
   input ready;
   input [7:0] data;
                             
   // sequencing of data
   output reg  replay_start = 0;
   output reg  replay_en = 0;
   output      record_en;
   
   always @(posedge clk) begin
      // we received marker to switch to replay mode
      if (ready && data == "0" && !replay_en) begin
         replay_start <= 1;
      end else begin
         replay_start <= 0;
      end
      replay_en <= replay_en | replay_start;
   end

   assign record_en = !replay_en & !replay_start;

endmodule // sequencer
