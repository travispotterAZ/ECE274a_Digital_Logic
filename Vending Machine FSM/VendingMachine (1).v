`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 10:26:14 PM
// Design Name: 
// Module Name: VendingMachine
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


module VendingMachin(Clk, Rst, N, D, Q, Candy, Number); //Clock, Reset, Nickel, Dime, Quarter
    input Clk, Rst, N, D, Q;
    output reg Candy;
    output reg[5:0] Number;
    
    reg Coin_Check;
    
    localparam  ZERO = 0, FIVE = 1, 
                TEN  = 2, FIFT = 3,
                TWEN = 4, TWFV = 5,
                THIRTY = 6, THIRFV = 7,
                FOURTY = 8, FRFIVE = 9,
                IDLE = 10;
      
    reg[3:0] state, nxtState;
      
    always @ (posedge Clk) begin
        if (Rst) begin
            state <= ZERO; //Intial State: Number = 0 Cents
        end
        
        else begin
            state <= nxtState;
        end 
    end
     
    always @(*) begin
        //default values
        nxtState = state;
        Candy = 0;
        //no default for Number will latch it
        
        
        Coin_Check = N&&D  ||  N&&Q   || D&&Q  ; //Checks if multiple coins input
        
        if (!Coin_Check) begin //If coin_check false then we want to update case
            
            case (state)
            
                ZERO : begin
                    Candy = 0;
                    Number = 0; //in canse no coin is input (or multiple)
                    if (N) begin nxtState = FIVE; end
                    else if (D) begin nxtState = TEN; end
                    else if (Q) begin nxtState = TWFV; end
                    else begin nxtState = ZERO; Number = 0; end
                end
                
                FIVE: begin
                    Candy = 0;
                    Number = 5;
                    if (N) begin nxtState = TEN; end
                    else if (D) begin nxtState = FIFT; end
                    else if (Q) begin nxtState = THIRTY;end
                    else begin nxtState = FIVE; Number = 5; end
                end
                
                TEN: begin
                    Candy = 0;
                    Number = 10;
                    if (N) begin nxtState = FIFT; end
                    else if (D) begin nxtState = TWEN; end
                    else if (Q) begin nxtState = THIRFV; end
                    else begin nxtState = TEN; Number = 10; end
                end
                
                FIFT: begin
                    Candy = 0;
                    Number = 15;
                    if (N) begin nxtState = TWEN; end
                    else if (D) begin nxtState = TWFV; end
                    else if (Q) begin nxtState = FOURTY; end
                    else begin nxtState = FIFT; Number = 15; end
                end
                
                TWEN: begin
                    Candy = 0;
                    Number = 20;
                    if (N) begin nxtState = TWFV; end
                    else if (D) begin nxtState = THIRTY; end
                    else if (Q) begin nxtState = FRFIVE; end
                    else begin nxtState = TWEN; Number = 20; end
                end
                
                TWFV: begin
                    Candy = 1;
                    Number = 0; //Updates number to equal change
                    nxtState = TWFV;
                end
                
                THIRTY: begin 
                    Candy = 1;
                    Number = 5;
                    nxtState = THIRTY;
                end 
               
                THIRFV: begin 
                    Candy = 1;
                    Number = 10;
                    nxtState = THIRFV;
                end
                
                FOURTY: begin 
                    Candy = 1;
                    Number = 15;
                    nxtState = FOURTY;
                end
                
                FRFIVE: begin 
                    Candy = 1;
                    Number = 20;
                    nxtState = FRFIVE;
                end
                
                default: begin
                Number = 33;
                Candy = 0;
                end
                
            endcase;
            
        end //Coin_Check
     else begin end //else for COIN_CHECK
     
     end       
                   
endmodule