`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 02:49:39 PM
// Design Name: 
// Module Name: Vending_TST
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


module Vending_TST();
    reg Clk_tb, Rst, N, D, Q;
    wire Candy;
    wire [5:0] Number;
    integer i;

    VendingMachin wanna(Clk_tb, Rst, N, D, Q, Candy, Number);
    
     always begin
      Clk_tb <= 0; #100;
      Clk_tb <= 1; #100;
     end
     
    
    
    initial begin
    
    ////////Nothing Input///////
    Rst = 1;
    N = 0; D = 0; Q = 0; 
    
    @ (posedge Clk_tb); #50; N = 0; D = 0; Q = 0; Rst = 0;  
    for(i = 0; i <3; i = i + 1) begin @(posedge Clk_tb); end
   
    N = 1; D = 1; Q = 0; //Multiple Coins Input
    @ (posedge Clk_tb); #50; N = 0; D = 0; Q = 0; Rst = 0;
    
    
    for(i = 0; i <3; i = i + 1) begin @(posedge Clk_tb); end //BUFFER
    
    
    ////////////Exatcly 25 Cents BELOW//////////
   
    N = 1; //5 Cents
    @ (posedge Clk_tb); #50; N = 0; D = 1; //+10 Cents = 15 Cents
    
    @ (posedge Clk_tb); #50; D = 1; //+10 Cents = 25 Cents 
    
    @ (posedge Clk_tb); #50; D = 0;   
    @ (posedge Clk_tb); //Nothing Input While @25 Cents (No change)
    
    Rst = 1;
    @ (posedge Clk_tb); #50; N = 0; D = 0; Q = 0; Rst = 0;  //Go back to inital
    for(i = 0; i <3; i = i + 1) begin @(posedge Clk_tb); end 
   
   
   /////////SUM of 30 Cents BELOW//////
    N = 1; //5 Cents
    @ (posedge Clk_tb); #50; N = 1; //+5 Cents = 10 Cents
    
    @ (posedge Clk_tb); #50; N = 0; D = 1; //+10 Cents = 20 Cents 
    
    @ (posedge Clk_tb); #50; D = 1; //+10 Cents = 30 Cents
    
    @ (posedge Clk_tb); #50; D = 0;   
    @ (posedge Clk_tb); //Nothing Input While @30 Cents (No change)
    
    Rst = 1;
    @ (posedge Clk_tb); #50; N = 0; D = 0; Q = 0; Rst = 0;  //Go back to inital
    for(i = 0; i <3; i = i + 1) begin @(posedge Clk_tb); end 
    
    
     /////////SUM of 35 Cents BELOW//////
    D = 1; //10 Cents
    @ (posedge Clk_tb); #50; D = 0; Q = 1; //+25 Cents = 35 Cents
    
    @ (posedge Clk_tb); #50; Q = 0;
    @ (posedge Clk_tb); //Nothing Input While @35 Cents (No change)
    
    Rst = 1;
    @ (posedge Clk_tb); #50; N = 0; D = 0; Q = 0; Rst = 0;  //Go back to inital
    for(i = 0; i <3; i = i + 1) begin @(posedge Clk_tb); end  
    
    /////////SUM of 40 Cents BELOW//////
    N = 1; //5 Cents
    @ (posedge Clk_tb); #50; N = 0; D = 1; //+10 Cents = 15 Cents
    
    @ (posedge Clk_tb); #50; D = 0; Q = 1; //+25 Cents = 40 Cents
    
    @ (posedge Clk_tb); //Nothing Input While @40 Cents (No change)
    
    Rst = 1;
    @ (posedge Clk_tb); #50; N = 0; D = 0; Q = 0; Rst = 0;  //Go back to inital
    for(i = 0; i <3; i = i + 1) begin @(posedge Clk_tb); end
    
    
    
    /////////SUM of 45 Cents BELOW//////
    N = 1; //5 Cents
    @ (posedge Clk_tb); #50; N = 1; //+5 Cents = 10 Cents
    @ (posedge Clk_tb); #50; N = 0; D = 1; //+10 Cents = 20 Cents
    
    @ (posedge Clk_tb); #50; D = 0; Q = 1; //+25 Cents = 45 Cents
    
    @ (posedge Clk_tb); //Nothing Input While @40 Cents (No change)
    
    Rst = 1;
    @ (posedge Clk_tb); #50; N = 0; D = 0; Q = 0; Rst = 0;  //Go back to inital
    for(i = 0; i <3; i = i + 1) begin @(posedge Clk_tb); end
    
    
    
    
    end //END of TESTS


endmodule

