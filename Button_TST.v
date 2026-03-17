`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2025 03:07:33 PM
// Design Name: 
// Module Name: Button_TST
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


module Button_TST();
    reg reset;
    reg bi;
    reg ClkOut;
    wire bo;
    
     ButtonSync LevelToPulse(reset, bi, ClkOut, bo);
     
     always begin
      ClkOut <= 0; #10;
      ClkOut <= 1; #10;
     end
  
     
     initial begin
        
        //CASE #1
        //@(posedge ClkOut);
        reset <= 1;
        bi <= 0;
       
        @(posedge ClkOut) #5; //CASE #2
        reset = 0;
        bi = 0;
     
        @(posedge ClkOut) #5; //CASE #3
        reset = 0;
        bi = 1;
     
        @(posedge ClkOut) #5; //CASE #4
        reset = 0;
        bi = 1;
            
        @(posedge ClkOut) #5; //CASE #5
        reset = 0;
        bi = 1;
            
        @(posedge ClkOut) #5; //CASE #6
        reset = 0;
        bi = 1;
            
        @(posedge ClkOut) #5; //CASE #7
        reset = 0;
        bi = 0;
            
        @(posedge ClkOut) #5; //CASE #8
        reset = 0;
        bi = 0;;
            
        @(posedge ClkOut) #5; //CASE #9
        reset = 0;
        bi = 1;
            
        @(posedge ClkOut) #5; //CASE #10
        reset = 0;
        bi = 0;
         
     end

endmodule
