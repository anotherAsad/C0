`include "alu.v"
`include "register.v"

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
*/

module main();
	reg  [7:0] A, B, opcode;
	wire [7:0] res, flag;
	integer lc0, lc1, lc2;
	
	ALU potato(res, flag, A, B, opcode[3:0]);
	initial begin
		$monitor("%d,%d - %d\t\t%d %d %d", flag[1], flag[0], res, A, B, opcode[3]);
		opcode = 8'b00001000;

		for(lc1 = 0; lc1 <= 255; lc1=lc1+10) begin
			for(lc2 = 0; lc2 <= 255; lc2=lc2+5) begin
				#1
				A = lc1;
				B = lc2;
			end
		end
	end
endmodule
