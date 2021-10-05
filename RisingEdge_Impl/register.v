module dlatch(Q, D, E);
	output Q;
	input D, E;

	wire wto1, back1, back2;
	wire notD;

	not  n0(notD, D);
	nand n1(Q, wto1, back1);
	nand n2(wto1, Q, back2);
	nand n3(back1, D, E);
	nand n4(back2, notD, E);
endmodule

module flipflop(Q, D, CLK);				// Falling edge triggered
	output Q;
	input  D, CLK;
	// flipflop clock control
	wire  notCLK, D1toD2;
	not n0(notCLK, CLK);
	// flipflop wire-up
	dlatch D1(D1toD2, D, notCLK);
	dlatch D2(Q, D1toD2, CLK);
endmodule

module flipflop_new(Q, D, CLK);
	output reg  Q;
	input  wire D, CLK;
	// sequential description
	always @(negedge CLK)
		Q <= D;
endmodule

module register(out, in, CLK);
	output[7:0] out;
	input [7:0] in;
	input CLK;
	// flipflop array.
	flipflop d0(out[0], in[0], CLK);
	flipflop d1(out[1], in[1], CLK);
	flipflop d2(out[2], in[2], CLK);
	flipflop d3(out[3], in[3], CLK);
	flipflop d4(out[4], in[4], CLK);
	flipflop d5(out[5], in[5], CLK);
	flipflop d6(out[6], in[6], CLK);
	flipflop d7(out[7], in[7], CLK);
endmodule

module regBank(R0, R1, R2, R3, R4, R5, R6, R7, ALU, REG, IMM, MS1, MS0, RS2, RS1, RS0, CLK, E);
	// E is the global enable; when 0, the decoder spurts 0, disabling all register inputs.
	output [7:0] R0, R1, R2, R3, R4, R5, R6, R7;
	input  [7:0] ALU, REG, IMM;
	input  MS0, MS1, RS0, RS1, RS2, E, CLK;
	// internal wires
	supply0 [7:0] loline;	// Might one day replace with MEM.
	wire    [7:0] MXOUT;
	wire    R0E, R1E, R2E, R3E, R4E, R5E, R6E, R7E; 		// Register Enables
	wire    R0CLK, R1CLK, R2CLK, R3CLK, R4CLK, R5CLK, R6CLK, R7CLK;
	// DEC used to pass enables to register. MX4 used to select the Register input
	bitdecoder8 DEC(R0E, R1E, R2E, R3E, R4E, R5E, R6E, R7E, RS2, RS1, RS0, E);
	bytemux4	MX4(MXOUT, ALU, REG, IMM, loline, MS1, MS0);
	// clock gating for rising edge.
	or CLK_GATE_0(R0CLK, ~R0E, CLK);
	or CLK_GATE_1(R1CLK, ~R1E, CLK);
	or CLK_GATE_2(R2CLK, ~R2E, CLK);
	or CLK_GATE_3(R3CLK, ~R3E, CLK);
	or CLK_GATE_4(R4CLK, ~R4E, CLK);
	or CLK_GATE_5(R5CLK, ~R5E, CLK);
	or CLK_GATE_6(R6CLK, ~R6E, CLK);
	or CLK_GATE_7(R7CLK, ~R7E, CLK);
	// register wire-up
	register RG0(R0, MXOUT, R0CLK);
	register RG1(R1, MXOUT, R1CLK);
	register RG2(R2, MXOUT, R2CLK);
	register RG3(R3, MXOUT, R3CLK);
	register RG4(R4, MXOUT, R4CLK);
	register RG5(R5, MXOUT, R5CLK);
	register RG6(R6, MXOUT, R6CLK);
	register RG7(R7, MXOUT, R7CLK);
endmodule

/*				TEST BENCH
module main();
	reg [7:0] D;
	reg  CLK;
	wire[7:0] O;

	register R(O, D, CLK);
	initial begin
		CLK = 0;
		$monitor("%d", O);
		D = 8'd123;
		#1
		CLK = 1;
		#1
		CLK = 0;
	end
endmodule
*/
