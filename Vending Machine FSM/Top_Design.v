`timescale 1ns / 1ps

module Top_Design(CLK100MHZ, BTNL, BTNU, BTNC, BTNR, LED, AN, CA, CB, CC, CD, CE, CF, CG);
    input CLK100MHZ, BTNL, BTNU, BTNC, BTNR;
    output CA, CB, CC, CD, CE, CF, CG;
    output [0:0]LED;
    output [7:0] AN;    
        
    wire ClkOut, N, D, Q;
    wire [5:0] Number;
    
    ClkDiv a1(CLK100MHZ, 1'b0, ClkOut);
    
	ButtonSync One(BTNU, BTNL, ClkOut, N); //(reset, bi, ClkOut, bo)
	
	ButtonSync Two(BTNU, BTNC, ClkOut, D);
	
	ButtonSync Three(BTNU, BTNR, ClkOut, Q);
	
	VendingMachin VM(ClkOut, BTNU, N, D, Q, LED[0], Number);
	
	TwoDigitDisplay TDD(CLK100MHZ, Number, CA,CB,CC,CD,CE,CF,CG,AN);
    
endmodule