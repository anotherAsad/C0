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
