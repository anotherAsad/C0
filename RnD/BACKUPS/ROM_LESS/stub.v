`include "mathComponents.v"
`include "control.v"
`include "register.v"

module instReg(Addr, PL, PL_E, CLK);
	output [7:0] Addr;
	input  [7:0] PL;
	input  CLK, PL_E;
	
	wire   [7:0] regToInc, muxToReg;
	
	bytemux2 MX(muxToReg, Addr, PL, PL_E);
	register RG(regToInc, muxToReg, CLK);
	byteIncrementer inc(Addr, regToInc);
endmodule

module main();
	reg [7:0] PL;
	reg CLK, PL_E;
	wire[7:0] Addr;

	instReg IR(Addr, PL, PL_E, CLK);

	initial begin
		$monitor("%d  %d", Addr, PL);
		PL = 8'b0;
		PL_E = 1;
		#1 CLK = 1; #1 CLK = 0;
		PL_E = 0;
		#1 CLK = 1; #1 CLK = 0;
		#1 CLK = 1; #1 CLK = 0;
		#1 CLK = 1; #1 CLK = 0;
		#1 CLK = 1; #1 CLK = 0;
		#1 CLK = 1; #1 CLK = 0;
		#1 CLK = 1; #1 CLK = 0;
	end
endmodule
