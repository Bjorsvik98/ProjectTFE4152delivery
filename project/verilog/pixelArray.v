module PIXEL_ARRAY
    (
    input logic anaBias1,
    input logic anaRamp,
    input logic anaReset,
    input logic erase,
    input logic expose,
    //input logic[3:0] read,
    input logic read1,read2,read3,read4,
    inout [7:0] pixData1,
    inout [7:0] pixData2,
    inout [7:0] pixData3,
    inout [7:0] pixData4
    );

    parameter real   dv_pixel = 0.5;


    PIXEL_SENSOR  #(.dv_pixel(dv_pixel))  ps1(anaBias1, anaRamp, anaReset, erase,expose, read1,pixData1);
    PIXEL_SENSOR  #(.dv_pixel(dv_pixel*0.5))  ps2(anaBias1, anaRamp, anaReset, erase,expose, read2,pixData2);
    PIXEL_SENSOR  #(.dv_pixel(dv_pixel*0.8))  ps3(anaBias1, anaRamp, anaReset, erase,expose, read3,pixData3);
    PIXEL_SENSOR  #(.dv_pixel(dv_pixel*0.3))  ps4(anaBias1, anaRamp, anaReset, erase,expose, read4,pixData4);



endmodule