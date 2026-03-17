`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2025 02:12:31 PM
// Design Name: 
// Module Name: ButtonSync
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


module ButtonSync(reset, bi, ClkOut, bo);
//reset, bi, ClkOut, bo, state, nxtState
    input reset, bi, ClkOut;
    output reg bo;
    
    localparam WaitRise = 0, PULSE = 1,
               WaitFall = 2, ERROR = 3;
               
    reg [1:0] state, nxtState;
    
    
    always @ (posedge ClkOut) begin
        if (reset) begin
            state <= WaitRise; //Intial State
        end
        
        else begin
            state <= nxtState;
        end 
    end
        
    always @(*) begin
        nxtState = state;
        case (state)
            WaitRise : begin
                if(bi) begin nxtState = PULSE; end
                bo = 0;
            end
            
            PULSE : begin
                nxtState = WaitFall;
                bo = 1;
            end
            
            WaitFall : begin
                if(~bi) begin nxtState = WaitRise; end
                bo = 0;
            end
            default : begin
                nxtState = ERROR;
            end
         endcase;
   
    end

endmodule
