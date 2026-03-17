`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 02:23:56 PM
// Design Name: 
// Module Name: LightPatternGenrator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LightPatternGenrator(ClkOut, start, reset, play, ld3, ld2, ld1, ld0);
    input ClkOut, start, reset, play;
    output reg ld3, ld2, ld1, ld0;
       
      localparam LED0 = 0, LED1f = 1,
                 LED2f = 2, LED3f = 3,
                 LED1b = 4, LED2b = 5,
                 LED3b = 6, OFF = 7,
                 ON = 8, OFFr = 9; //LED#f means LED forward, LED#b means LED back
      reg[3:0] state, nxtState;
      
      always @ (posedge ClkOut) begin
        if (reset) begin
            state <= OFF; //Intial State: ALL LED off
        end
        
        else begin
            state <= nxtState;
        end 
    end
     
    always @(*) begin
        ld0 = 0; ld1 = 0; ld2 = 0; ld3 = 0;
    
        nxtState = state;
        
        case (state)
            OFF : begin
                if (start) begin nxtState = LED3f; end
            end
            
            LED3f: begin
                nxtState = LED2f; ld3 = 1; 
            end
            
            LED2f: begin
                nxtState = LED1f; ld2 = 1;
            end
            
            LED1f: begin
                nxtState = LED0; ld1 = 1;
            end
            
            LED0: begin
                nxtState = LED1b; ld0 = 1;
            end
            
            LED1b: begin
                nxtState = LED2b; ld1 = 1;
            end
            
            LED2b: begin
                nxtState = LED3b; ld2 = 1;
            end
            
            LED3b: begin
                if(play) begin nxtState = LED2f; ld3 = 1; end
                
                else begin nxtState = ON; ld3 = 1; end
            end
            
            ON : begin
                nxtState = OFFr;  ld0 = 1; ld1 = 1; ld2 = 1; ld3 = 1;
            end
            
            OFFr : begin
                nxtState = ON;  ld0 = 0; ld1 = 0; ld2 = 0; ld3 = 0;
            end
            
        endcase;
     end       
                   
endmodule
