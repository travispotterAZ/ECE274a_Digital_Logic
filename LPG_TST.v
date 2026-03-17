`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 02:54:19 PM
// Design Name: 
// Module Name: LPG_TST
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


module LPG_TST();
    reg ClkOut, start, reset, play;
    wire ld3, ld2, ld1, ld0;
    
    LightPatternGenrator LEDs(ClkOut, start, reset, play, ld3, ld2, ld1, ld0);
    
     always begin
      ClkOut <= 0; #100;
      ClkOut <= 1; #100;
     end
    
    integer i;
    
    initial begin
    
    reset = 1;
    start = 0;
    play = 0;
    
    @ (posedge ClkOut); #50;
    
    reset = 0; start = 0; play = 0;
    
    @ (posedge ClkOut);
    @ (posedge ClkOut);
    
    reset = 0;
    start = 1;
    play = 0;     
    
    @ (posedge ClkOut); #50; reset = 0; start = 0; play = 0;
    for(i = 0; i < 14; i = i + 1) begin @(posedge ClkOut); end
    
    reset = 1;
    start = 0;
    play = 0;
    
    @ (posedge ClkOut); #50; reset = 0; start = 0; play = 0;
    
    reset = 0;
    start = 1;
    play = 0;    
         
    @ (posedge ClkOut); #50; reset = 0; start = 0; play = 0;
    @ (posedge ClkOut);
    
    reset = 0;
    start = 0;
    play = 1;   
    
    @ (posedge ClkOut); #50; reset = 0; start = 0; play = 0;
    @ (posedge ClkOut);
    @ (posedge ClkOut);
    @ (posedge ClkOut);
    @ (posedge ClkOut);
    
    reset = 0;
    start = 0;
    play = 1;
    
    @ (posedge ClkOut); #50; reset = 0; start = 0; play = 0;
    for(i = 0; i < 5; i = i + 1) begin @(posedge ClkOut); end
    
    
    reset = 0;
    start = 0;
    play = 1;
    
    @ (posedge ClkOut); #50; reset = 0; start = 0; play = 0;
    for(i = 0; i < 6; i = i + 1) begin @(posedge ClkOut); end
    
    reset = 0;
    start = 0;
    play = 1;
    
    @ (posedge ClkOut); #50; reset = 0; start = 0; play = 0;
        
    reset = 0;
    start = 0;
    play = 0;
    
    @ (posedge ClkOut); #50;  reset = 0; start = 0; play = 0;
    for(i = 0; i < 5; i = i + 1) begin @(posedge ClkOut); end    
    
    end


endmodule
