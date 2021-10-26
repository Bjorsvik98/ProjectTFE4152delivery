//====================================================================
//        Copyright (c) 2021 Carsten Wulff Software, Norway
// ===================================================================
// Created       : wulff at 2021-10-11
// ===================================================================
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//====================================================================


`timescale 1 ns / 1 ps


module pixelSensorFsm(
                       input logic        clk,
                       input  logic      reset,
                       output logic erase,
                       output logic expose,
                       output logic read1,
                       output logic read2,
                       output logic read3,
                       output logic read4,
                      output logic convert

                      );


     //State duration in clock cycles
   parameter integer c_erase = 5;
   parameter integer c_expose = 255;
   parameter integer c_convert = 255;
   parameter integer c_read = 5;

   //------------------------------------------------------------
   // State Machine
   //------------------------------------------------------------
  parameter ERASE=0, EXPOSE=1, CONVERT=2, READ1=3, READ2=4, READ3=5, READ4=6, IDLE=7;

   // logic               convert;
   // logic               convert_stop;
   logic [2:0]         state,next_state;   //States
   integer           counter;            //Delay counter in state machine

   // Control the output signals
   always_ff @(negedge clk ) begin
      case(state)
        ERASE: begin
           erase <= 1;
           read1 <= 0;
           read2 <= 0;
           read3 <= 0;
           read4 <= 0;
           expose <= 0;
           convert <= 0;
        end
        EXPOSE: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           read3 <= 0;
           read4 <= 0;
           expose <= 1;
           convert <= 0;
        end
        CONVERT: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           read3 <= 0;
           read4 <= 0;
           expose <= 0;
           convert = 1;
        end
        READ1: begin
           erase <= 0;
           read1 <= 1;
           read2 <= 0;
           read3 <= 0;
           read4 <= 0;
           expose <= 0;
           convert <= 0;
        end
        READ2: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 1;
           read3 <= 0;
           read4 <= 0;
           expose <= 0;
           convert <= 0;
        end
        READ3: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           read3 <= 1;
           read4 <= 0;
           expose <= 0;
           convert <= 0;
        end
        READ4: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           read3 <= 0;
           read4 <= 1;
           expose <= 0;
           convert <= 0;
        end


        IDLE: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           read3 <= 0;
           read4 <= 0;
           expose <= 0;
           convert <= 0;

        end
      endcase // case (state)
   end // always @ (state)

   // Control the state transitions
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         state = IDLE;
         next_state = ERASE;
         counter  = 0;
         convert  = 0;
      end
      else begin
         case (state)
           ERASE: begin
              if(counter == c_erase) begin
                 next_state <= EXPOSE;
                 state <= IDLE;
              end
           end
           EXPOSE: begin
              if(counter == c_expose) begin
                 next_state <= CONVERT;
                 state <= IDLE;
              end
           end
           CONVERT: begin
              if(counter == c_convert) begin
                 next_state <= READ1;
                 state <= IDLE;
              end
           end
           READ1:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= READ2;
             end
           READ2:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= READ3;
             end
           READ3:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= READ4;
             end
           READ4:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= ERASE;
             end    

           IDLE:
             state <= next_state;
         endcase // case (state)
         if(state == IDLE)
           counter = 0;
         else
           counter = counter + 1;
      end
   end // always @ (posedge clk or posedge reset)


endmodule // test
