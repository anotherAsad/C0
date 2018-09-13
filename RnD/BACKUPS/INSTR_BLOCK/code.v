`include "core.v"
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


module testBench();
	reg  [7:0] IMM;
	reg	 [3:0] OP;
	reg  MS1, MS0, RS2, RS1, RS0, AR2, AR1, AR0;			// AR stands or ALU_A and RegBank select lines.
	reg  BS2, BS1, BS0, IRS, CLK;  							// IRS: Immed/Reg Select
	wire [7:0] R0, R1, R2, R3, R4, R5, R6, R7, AREG, Breg;	// AREG stands for AccumulatorMux_A and RegisterInputforRegBank
	wire [7:0] BLINE, Addr, FLAGS;					// This single Bus from AREG MUX feeds RegBank and ALU both.
	
	reg    ALU_INST, JMP_INST, MEM_INST;
	wire   JMP, PL_A, PL_E, FLG_E;							// PL_A is Parallel Load Condition Available
	
	core C0(Addr, FLAGS,
			R0, R1, R2, R3, R4, R5, R6, R7,

			MEM_INST, ALU_INST, JMP_INST,
			MS1, MS0,		// Mode Select for RegBank. 00->ALU, 01->REG, 10->IMM, 11->loline/MainMEM
			IRS,			// Immeditate or Register Select. Chooses between BMUX8 and IMM inputs for ALU ARG B.
			RS2, RS1, RS0,	// Target Register select lines. Data will be written to this register.
			AR2, AR1, AR0,	// AR stands or AMUX and RegBank select lines.
			BS2, BS1, BS0,  // BS stands for BMUX input select lines
			OP, IMM,		// OP (4 bits) is ALU opcode or BranchUnit Instruction.
			CLK
		);

	initial begin
		$display("REG0\tREG1\tREG2\tREG3\tREG4\tREG5\tREG6\tREG7\tFLAGS\t\tINSTPTR");
		$monitor("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%b\t%d", R0, R1, R2, R3, R4, R5, R6, R7, FLAGS, Addr);
		CLK = 0;

		// JMP #0
		MEM_INST = 0; ALU_INST = 0; JMP_INST = 1;
		MS1 = 0; MS0 = 0;			// Mode Select for RegBank. 00->ALU, 01->REG, 10->IMM, 11->loline/MainMEM
		IRS = 0;					// Immeditate or Register Select. Chooses between BMUX8 and IMM inputs for ALU ARG B.
		RS2 = 0; RS1 = 0; RS0 = 0;	// Target Register select lines. Data will be written to this register.
		AR2 = 0; AR1 = 0; AR0 = 0;	// AR stands or AMUX and RegBank select lines.
		BS2 = 0; BS1 = 0; BS0 = 0;  // BS stands for BMUX input select lines
		OP = 4'b0111; IMM = 8'd0;		// OP (4 bits) is ALU opcode or BranchUnit Instruction.

		#1 CLK = 1; #1 CLK = 0;

		//  MOV R0, #5
		MEM_INST = 1; ALU_INST = 0; JMP_INST = 0;
		MS1 = 1; MS0 = 0;			// Mode Select for RegBank. 00->ALU, 01->REG, 10->IMM, 11->loline/MainMEM
		IRS = 1;					// Immeditate or Register Select. Chooses between BMUX8 and IMM inputs for ALU ARG B.
		RS2 = 0; RS1 = 0; RS0 = 0;	// Target Register select lines. Data will be written to this register.
		AR2 = 0; AR1 = 0; AR0 = 0;	// AR stands or AMUX and RegBank select lines.
		BS2 = 0; BS1 = 0; BS0 = 0;  // BS stands for BMUX input select lines
		OP = 4'b0111; IMM = 8'd5;	// OP (4 bits) is ALU opcode or BranchUnit Instruction.

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  MOV R1, #7
		MEM_INST = 1; ALU_INST = 0; JMP_INST = 0;
		MS1 = 1; MS0 = 0;			// Mode Select for RegBank. 00->ALU, 01->REG, 10->IMM, 11->loline/MainMEM
		IRS = 1;					// Immeditate or Register Select. Chooses between BMUX8 and IMM inputs for ALU ARG B.
		RS2 = 0; RS1 = 0; RS0 = 1;	// Target Register select lines. Data will be written to this register.
		AR2 = 0; AR1 = 0; AR0 = 0;	// AR stands or AMUX and RegBank select lines.
		BS2 = 0; BS1 = 0; BS0 = 0;  // BS stands for BMUX input select lines
		OP = 4'b0111; IMM = 8'd7;	// OP (4 bits) is ALU opcode or BranchUnit Instruction.

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  ADD R0, R0, R1			
		MEM_INST = 1; ALU_INST = 1; JMP_INST = 0;
		MS1 = 0; MS0 = 0;			// Mode Select for RegBank. 00->ALU, 01->REG, 10->IMM, 11->loline/MainMEM
		IRS = 0;					// Immeditate or Register Select. Chooses between BMUX8 and IMM inputs for ALU ARG B.
		RS2 = 0; RS1 = 0; RS0 = 0;	// Target Register select lines. Data will be written to this register.
		AR2 = 0; AR1 = 0; AR0 = 0;	// AR stands or AMUX and RegBank select lines.
		BS2 = 0; BS1 = 0; BS0 = 1;  // BS stands for BMUX input select lines
		OP = 4'b0000; IMM = 8'd7;	// OP (4 bits) is ALU opcode or BranchUnit Instruction.

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  ADD R0, R0, #9	
		MEM_INST = 1; ALU_INST = 1; JMP_INST = 0;
		MS1 = 0; MS0 = 0;			// Mode Select for RegBank. 00->ALU, 01->REG, 10->IMM, 11->loline/MainMEM
		IRS = 1;					// Immeditate or Register Select. Chooses between BMUX8 and IMM inputs for ALU ARG B.
		RS2 = 0; RS1 = 0; RS0 = 0;	// Target Register select lines. Data will be written to this register.
		AR2 = 0; AR1 = 0; AR0 = 0;	// AR stands or AMUX and RegBank select lines.
		BS2 = 0; BS1 = 0; BS0 = 1;  // BS stands for BMUX input select lines
		OP = 4'b0000; IMM = 8'd9;	// OP (4 bits) is ALU opcode or BranchUnit Instruction.

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  MOV	R7, R1
		MEM_INST = 1; ALU_INST = 0; JMP_INST = 0;
		MS1 = 0; MS0 = 1;			// Mode Select for RegBank. 00->ALU, 01->REG, 10->IMM, 11->loline/MainMEM
		IRS = 0;					// Immeditate or Register Select. Chooses between BMUX8 and IMM inputs for ALU ARG B.
		RS2 = 1; RS1 = 1; RS0 = 1;	// Target Register select lines. Data will be written to this register.
		AR2 = 0; AR1 = 0; AR0 = 1;	// AR stands or AMUX and RegBank select lines.
		BS2 = 0; BS1 = 0; BS0 = 1;  // BS stands for BMUX input select lines
		OP = 4'b0000; IMM = 8'd9;	// OP (4 bits) is ALU opcode or BranchUnit Instruction.

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  SHL	R6, R0
		MEM_INST = 1; ALU_INST = 1; JMP_INST = 0;
		MS1 = 0; MS0 = 0;			// Mode Select for RegBank. 00->ALU, 01->REG, 10->IMM, 11->loline/MainMEM
		IRS = 0;					// Immeditate or Register Select. Chooses between BMUX8 and IMM inputs for ALU ARG B.
		RS2 = 1; RS1 = 1; RS0 = 0;	// Target Register select lines. Data will be written to this register.
		AR2 = 0; AR1 = 0; AR0 = 0;	// AR stands or AMUX and RegBank select lines.
		BS2 = 0; BS1 = 0; BS0 = 1;  // BS stands for BMUX input select lines
		OP  = 4'b0100; IMM = 8'd9;	// OP (4 bits) is ALU opcode or BranchUnit Instruction.

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)		

		//  SHL	R6, R6
		MEM_INST = 1; ALU_INST = 1; JMP_INST = 0;
		MS1 = 0; MS0 = 0;			// Mode Select for RegBank. 00->ALU, 01->REG, 10->IMM, 11->loline/MainMEM
		IRS = 0;					// Immeditate or Register Select. Chooses between BMUX8 and IMM inputs for ALU ARG B.
		RS2 = 1; RS1 = 1; RS0 = 0;	// Target Register select lines. Data will be written to this register.
		AR2 = 1; AR1 = 1; AR0 = 0;	// AR stands or AMUX and RegBank select lines.
		BS2 = 0; BS1 = 0; BS0 = 1;  // BS stands for BMUX input select lines
		OP = 4'b0100; IMM = 8'd9;	// OP (4 bits) is ALU opcode or BranchUnit Instruction.

		#1 CLK = 1; #1 CLK = 0;
	end
endmodule
