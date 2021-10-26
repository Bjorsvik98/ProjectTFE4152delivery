
module pixelTop
    (
    input logic     clk,
    input logic     reset,
    output logic [7:0] pixelDataOut

    );

   parameter real    dv_pixel = 0.5;  //Set the expected photodiode current (0-1)

   //Analog signals
   logic              anaBias1;
   logic              anaRamp;
   logic              anaReset;

   //Tie off the unused lines
   assign anaReset = 1;

   //Digital
   wire             erase;
   wire             expose;
   wire             read1;
   wire             read2;
   wire             read3;
   wire             read4;
   wire             convert;

   tri[7:0]         pixData1; //  We need this to be a wire, because we're tristating it
   tri[7:0]         pixData2;
   tri[7:0]         pixData3;
   tri[7:0]         pixData4;

    PIXEL_ARRAY  #(.dv_pixel(dv_pixel))  ps1(anaBias1, anaRamp, anaReset, erase,expose, read1,read2,read3,read4,pixData1,pixData2,pixData3,pixData4);

    pixelSensorFsm #(.c_erase(5),.c_expose(255),.c_convert(255),.c_read(5))  fsm1(.clk(clk),.reset(reset),.erase(erase),.expose(expose),.read1(read1),.read2(read2),.read3(read3),.read4(read4),.convert(convert));
    

   
endmodule