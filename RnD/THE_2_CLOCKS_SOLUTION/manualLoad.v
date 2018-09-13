`include "core.v"
`include "ROM.v"
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

module pinAbstractedCPU(Addr, FLAGS, R0, R1, R2, R3, R4, R5, R6, R7, INS, CLK);
	// A rudimentary instruction decoder for the CPU core follows in the form of bufs, nors and xors.
	output [07:0] R0, R1, R2, R3, R4, R5, R6, R7, Addr, FLAGS;
	input  [20:0] INS;
	input  CLK;
	//   [X X] [X] [X X X X] [X X X] [X X X] [X X X | X X X X X]
	// INSTYPE I/R  OPCODE   TGT_REG  AMUX    BMUX  | IMM
	//	
	//	INSTYPE: 00->JMP, 01->MOV, 10->CMP, 11->MATH
	//  I/R    : 0->BREG, 1->IMM
	wire  MEM_INST, ALU_INST, JMP_INST, IRS, MS1, MS0, CLK;
	wire  w0, w1, w2;

	buf b0(ALU_INST, INS[20]);
	buf b1(MEM_INST, INS[19]);
	nor n0(JMP_INST, INS[20], INS[19]);

	xor  x0(w0, INS[20], INS[18]);
	xor  x1(w1, INS[19], INS[18]);
	nand n1(w2, INS[20], INS[19]);
	and  a0(MS1, w0, w2);
	and  a1(MS0, w1, w2);

	core C0(Addr, FLAGS,
			R0, R1, R2, R3, R4, R5, R6, R7,

			MEM_INST, ALU_INST, JMP_INST,
			MS1, MS0,		// Mode Select for RegBank. 00->ALU, 01->REG, 10->IMM, 11->loline/MainMEM
			INS[18],			// Immeditate or Register Select. Chooses between BMUX8 and IMM inputs for ALU ARG B.
			INS[13], INS[12], INS[11],	// Target Register select lines. Data will be written to this register.
			INS[10], INS[09], INS[08],	// AR stands or AMUX and RegBank select lines.
			INS[07], INS[06], INS[05],  // BS stands for BMUX input select lines
			INS[17:14], INS[7:0],		// OP (4 bits) is ALU opcode or BranchUnit Instruction.
			CLK
		);
endmodule

module testBench();
	wire [7:0] R0, R1, R2, R3, R4, R5, R6, R7, Addr_CPU, Addr, FLAGS;
	reg  CLK;
	reg  [20:0] INS;

	pinAbstractedCPU C0(Addr, FLAGS,
						R0, R1, R2, R3, R4, R5, R6, R7,
						INS, CLK);

	initial begin
		$display("REG0\tREG1\tREG2\tREG3\tREG4\tREG5\tREG6\tREG7\tFLAGS\t\tINSTPTR");
		$monitor("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%b\t%d", R0, R1, R2, R3, R4, R5, R6, R7, FLAGS, Addr);
//		$monitor("%d\t%d\t%d\t%b\t%d", Addr_CPU, Addr_MANUAL, Addr, INS, CLK);
		CLK = 0;

		INS = 21'b001011100000000000000; #1 CLK = 1; 
		INS = 21'b011000000000000000000; #1 CLK = 1; 
		INS = 21'b011000001100000000000; #1 CLK = 1;
		INS = 21'b111000001101100000001; #1 CLK = 1; 
		INS = 21'b111000001101100000001; #1 CLK = 1;
		INS = 21'b111000001101100000001; #1 CLK = 1;
		INS = 21'b111000001101100000001; #1 CLK = 1;
		INS = 21'b111000001101100000001; #1 CLK = 1;
		INS = 21'b111000001101100000001; #1 CLK = 1;
		INS = 21'b111000001101100000001; #1 CLK = 1;
		INS = 21'b111000001101100000001; #1 CLK = 1;
		INS = 21'b001011100000000001010; #1 CLK = 1;

	end
endmodule


// Manual Instruction Supply
/*
		// JMP #0
		INS = 21'b001011100000011111111; 
		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  MOV R0, #5
		INS = 21'b011000000000000000101;
		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  MOV R1, #7
		INS = 21'b011000000100000000111;
		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  ADD R0, R0, R1	
		INS = 21'b110000000000000100000;		
		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  ADD R0, R0, #9
		INS = 21'b111000000000000001001;
		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  MOV	R7, R1
		INS = 21'b010000011100100000000;
		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)
		
		//  CMP R7, #7
		INS = 21'b101100000011100000111; 
		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)	

		//  JE #64
		INS = 21'b001101100000000111111; 
		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)	

		//  SHL	R6, R0
		INS = 21'b110010011000000000000;
	 	#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)	
	
		//  SHL	R5, #3
		INS = 21'b111010010100000000011;
		#1 CLK = 1; #1 CLK = 0;

		INS = 21'b000000000000000000000;
		#1 CLK = 1; #1 CLK = 0;
*/
