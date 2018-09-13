// mathCKT Uses implicit XORs
module fAddr(outC, sum, inC, A, B);
	output outC, sum;
	input  inC, A, B;
	wire   abSum, abCarry, hA2Carry;

	xor x1(abSum, A, B);
	and a1(abCarry, A, B);
	xor x2(sum, abSum, inC);
	and a2(hA2Carry, abSum, inC);

	or  o1(outC, hA2Carry, abCarry);
endmodule

module mathCKT(outC, sum, ovFL, inC, A, B);
	output outC, ovFL;			// ovFL is overflow flag
	output [7:0] sum;
	input  inC;
	input  [7:0] A, B;
	
	wire   [6:0] cp;			// Carry Propogation Wire
	wire   [7:0] xCon;			// XOR to B connector
	
	xor x0(xCon[0], B[0], inC);
	xor x1(xCon[1], B[1], inC);
	xor x2(xCon[2], B[2], inC);
	xor x3(xCon[3], B[3], inC);
	xor x4(xCon[4], B[4], inC);
	xor x5(xCon[5], B[5], inC);
	xor x6(xCon[6], B[6], inC);
	xor x7(xCon[7], B[7], inC);

	fAddr f0(cp[0], sum[0], inC  , A[0], xCon[0]);
	fAddr f1(cp[1], sum[1], cp[0], A[1], xCon[1]);
	fAddr f2(cp[2], sum[2], cp[1], A[2], xCon[2]);
	fAddr f3(cp[3], sum[3], cp[2], A[3], xCon[3]);
	fAddr f4(cp[4], sum[4], cp[3], A[4], xCon[4]);
	fAddr f5(cp[5], sum[5], cp[4], A[5], xCon[5]);
	fAddr f6(cp[6], sum[6], cp[5], A[6], xCon[6]);
	fAddr f7(outC , sum[7], cp[6], A[7], xCon[7]);

	xor ovF(ovFL, cp[6], outC);		// Overflow Check
endmodule

// R for Result
module xorCKT(R, A, B);
	input [7:0] A, B;
	output[7:0] R;

	xor x0(R[0], A[0], B[0]);
	xor x1(R[1], A[1], B[1]);
	xor x2(R[2], A[2], B[2]);
	xor x3(R[3], A[3], B[3]);
	xor x4(R[4], A[4], B[4]);
	xor x5(R[5], A[5], B[5]);
	xor x6(R[6], A[6], B[6]);
	xor x7(R[7], A[7], B[7]);
endmodule	

module orCKT(R, A, B);
	input [7:0] A, B;
	output[7:0] R;

	or x0(R[0], A[0], B[0]);
	or x1(R[1], A[1], B[1]);
	or x2(R[2], A[2], B[2]);
	or x3(R[3], A[3], B[3]);
	or x4(R[4], A[4], B[4]);
	or x5(R[5], A[5], B[5]);
	or x6(R[6], A[6], B[6]);
	or x7(R[7], A[7], B[7]);
endmodule

module andCKT(R, A, B);
	input [7:0] A, B;
	output[7:0] R;

	and x0(R[0], A[0], B[0]);
	and x1(R[1], A[1], B[1]);
	and x2(R[2], A[2], B[2]);
	and x3(R[3], A[3], B[3]);
	and x4(R[4], A[4], B[4]);
	and x5(R[5], A[5], B[5]);
	and x6(R[6], A[6], B[6]);
	and x7(R[7], A[7], B[7]);
endmodule
	
	
