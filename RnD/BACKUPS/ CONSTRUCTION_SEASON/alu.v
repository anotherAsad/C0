`include "mathComponents.v"
`include "control.v"

module ALU(Out, FLG, A, B, opcode);
	output[7:0] Out, FLG;
	input [7:0] A, B;
	input [3:0] opcode;
	wire  [7:0] xorOut, andOut, ornOut, mathOut, BSLOut, BSROut, ROLOut, ROROut;

	xorCKT  X1(xorOut, A, B);
	andCKT  A1(andOut, A, B);
	ornCKT  O1(ornOut, A, B, opcode[3]);
	mathCKT M(FLG[0], FLG[1], mathOut, opcode[3], A, B);	// Opcode[3] is addition/subtraction and OR/NOR bit
	
	buf		b0(FLG[2], mathOut[7]);							// Sign Bit handle

	bitshiftLeft  BSL(BSLOut, A);
	bitshiftRight BSR(BSROut, A);
	rotateLeft  ROL(ROLOut, A);
	rotateRight ROR(ROROut, A);

	bytemux8 MX(Out, mathOut, xorOut, andOut, ornOut, BSLOut, BSROut, ROLOut, ROROut, opcode[2], opcode[1], opcode[0]);
	or zerocheck(FLG[3], Out[0], Out[1], Out[2], Out[3], Out[4], Out[5], Out[6], Out[7]);
endmodule

/*
OPCODES for ALU
0000 - ADD
X001 - XOR
X010 - AND
0011 - OR
1011 - NOR
X100 - SHL
X101 - SHR
X110 - ROL
X111 - ROR
1000 - SUB

Carry and overfow will always be available from adder CKT

FLG[0] - Carry
FLG[1] - Overflow
FLG[2] - sign bit of output
FLG[3] - Out is Zero (works with AND ORN XOR)

	  ____________
   	 |            |
   	 |            |
--/--|A        RES|--/--
     |            |
--/--|B      FLAGS|--/--
     |            |
--/--|OPCODE      |
     |            |
     |____________|


*/

