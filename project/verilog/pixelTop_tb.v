`timescale 1 ns / 1 ps


module pixelTop_tb;
    
    logic clk =0;
    logic reset =0;
    parameter integer clk_period = 500;
    parameter integer sim_end = clk_period*2400;
    always #clk_period clk=~clk;

    parameter real    dv_pixel = 0.5;

    //Analog signals
   logic              anaBias1;
   logic              anaRamp;
   logic              anaReset;

   //Tie off the unused lines
   assign anaReset = 1;

   //Digital
   logic              erase;
   logic              expose;
   //logic[3:0]         read;
   logic read1;
   logic read2;
   logic read3;
   logic read4;
   tri[7:0]         pixData1; //  We need this to be a wire, because we're tristating it
   tri[7:0]         pixData2;
   tri[7:0]         pixData3;
   tri[7:0]         pixData4;



    
    pixelTop #(.dv_pixel(dv_pixel)) pix(.clk(clk), .reset(reset), .pixelDataOut(pixelDataOut));
    
    //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------
   logic[7:0] data;

   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign anaRamp = convert ? clk : 0;

   // During expoure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign anaBias1 = expose ? clk : 0;

   // If we're not reading the pixData, then we should drive the bus
   assign pixData1 = read1 ? 8'bZ: data;
   assign pixData2 = read2 ? 8'bZ: data;
   assign pixData3 = read3 ? 8'bZ: data;
   assign pixData4 = read4 ? 8'bZ: data;

   // When convert, then run a analog ramp (via anaRamp clock) and digtal ramp via
   // data bus.
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         data =0;
      end
      if(convert) begin
         data +=  1;
      end
      else begin
         data = 0;
      end
   end // always @ (posedge clk or reset)

   //------------------------------------------------------------
   // Readout from databus
   //------------------------------------------------------------
//    logic [7:0] pixelDataOut;
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         pixelDataOut = 0;
      end
      else if(read1) begin
           pixelDataOut <= pixData1;
      end
      else if(read2) begin
           pixelDataOut <= pixData2;
      end
      else if(read3) begin
           pixelDataOut <= pixData3;
      end
      else if(read4) begin
           pixelDataOut <= pixData4;
      end
      
   end
    

    initial
        begin
            $display("Hei");
            reset = 1;

            #clk_period  reset=0;

            

            $dumpfile("pixelTop_tb.vcd");
            $dumpvars(0,pixelTop_tb);

            #sim_end
                $stop;


        end



endmodule