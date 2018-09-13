module dlatch(Q, D, E);
	output Q;
	input D, E;
	
	wire wto1, back1, back2;
	wire notD;

	not n0(notD, D);
	nand n1(Q, wto1, back1);
	nand n2(wto1, Q, back2);
	nand n3(back1, D, E);
	nand n3(back2, notD, E);
endmodule

module register(out, in, E);
	output[7:0] out;
	input [7:0] in;
	input E;

	dlatch d0(out[0], in[0], E);
	dlatch d1(out[1], in[1], E);
	dlatch d2(out[2], in[2], E);
	dlatch d3(out[3], in[3], E);
	dlatch d4(out[4], in[4], E);
	dlatch d5(out[5], in[5], E);
	dlatch d6(out[6], in[6], E);
	dlatch d7(out[7], in[7], E);
endmodule
