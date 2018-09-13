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

// Remember, the B vector in mathCKT is carried from external XORs
module mathCKT(outC, sum, ovFL, inC, A, B);
	output outC, ovFL;			// ovFL is overflow flag
	output [7:0] sum;
	input  inC;
	input  [7:0] A, B;
	
	wire   [6:0] cp;			// Carry Propogation Wire

	fAddr f0(cp[0], sum[0], inC  , A[0], B[0]);
	fAddr f1(cp[1], sum[1], cp[0], A[1], B[1]);
	fAddr f2(cp[2], sum[2], cp[1], A[2], B[2]);
	fAddr f3(cp[3], sum[3], cp[2], A[3], B[3]);
	fAddr f4(cp[4], sum[4], cp[3], A[4], B[4]);
	fAddr f5(cp[5], sum[5], cp[4], A[5], B[5]);
	fAddr f6(cp[6], sum[6], cp[5], A[6], B[6]);
	fAddr f7(outC , sum[7], cp[6], A[7], B[7]);

	xor ovF(ovFL, cp[6], outC);		// Overflow Check
endmodule
	
	
