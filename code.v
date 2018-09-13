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

module pinAbstractedCPU(Addr, FLAGS, R0, R1, R2, R3, R4, R5, R6, R7, INS, CLK1, CLK2);
	// A rudimentary instruction decoder for the CPU core follows in the form of bufs, nors and xors.
	output [07:0] R0, R1, R2, R3, R4, R5, R6, R7, Addr, FLAGS;
	input  [20:0] INS;
	input   CLK1, CLK2;
	//   [X X] [X] [X X X X] [X X X] [X X X] [X X X | X X X X X]
	// INSTYPE I/R  OPCODE   TGT_REG  AMUX    BMUX  | IMM
	//	
	//	INSTYPE: 00->JMP, 01->MOV, 10->CMP, 11->MATH
	//  I/R    : 0->BREG, 1->IMM
	wire  MEM_INST, ALU_INST, JMP_INST, IRS, MS1, MS0;
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
			CLK1, CLK2
		);
endmodule

module testBench();
	wire [7:0] R0, R1, R2, R3, R4, R5, R6, R7, Addr_CPU, Addr, FLAGS;
	reg  CLK, reset, resetClocker;
	wire CLK1, CLK2, clockSelect, negClockSelect;
	wire  [20:0] INS;
	supply0 [7:0] Addr_MANUAL;

	integer i;

	// The clocker flip flop changes state every falling edge of main clock. This is used to enable or disable CLK1 and CLK2
	// in alternating turns by the following and gates.
	TRflipflop clocker(clockSelect, resetClocker, CLK);		// Every Clock Cycle, the clock select changes b/w 0 and 1
	not		   n0(negClockSelect, clockSelect);
	and		   a0(CLK1, clockSelect, CLK);
	and		   a2(CLK2, negClockSelect, CLK);

	bytemux2 boot(Addr, Addr_CPU, Addr_MANUAL, reset);

	pinAbstractedCPU C0(Addr_CPU, FLAGS,
						R0, R1, R2, R3, R4, R5, R6, R7,
						INS, CLK1, CLK2);

	ROM ROM1(INS, Addr);

	initial begin
		$display("REG0\tREG1\tREG2\tREG3\tFLAGS\t\tINSTPTR\tINSTRUCTION");
//		$monitor("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%b\t%d", R0, R1, R2, R3, R4, R5, R6, R7, FLAGS, Addr);
//		$display("A_CPU\tA_MAN\tAddr\tINS\t\t\tR3\tR0");
		CLK = 0;
// This reset sets the clocker FlipFlop to zero in first cycle and loads the MANUAL_ADDRESS to the CPU in the second.
		resetClocker = 0;
		// Set Clocker to Zero
		#5 resetClocker = 1;
		#5 CLK = 1; #5 CLK = 0;
		#5 resetClocker = 0;
	
		// By no coincidence, the clocker has the zero output and the CPU receives instruction 0 (due to manual load).
		//The zero output from the clocker ensure that the next clock tick is received at the JUMPS unit. Hence the first
		// instruction "JMP #0" stores the address 0 in the PC, and subsequently receives instruction 1 from the ROM.

		// Set PC to 0
		$display("MANUAL ADDRESS LOAD");
		reset = 1;
		#5 CLK = 1; #5 CLK = 0;
		#5 $display("%d\t%d\t%d\t%d\t%b\t%d\t%b %b %b %b %b %b", R0, R1, R2, R3, FLAGS, Addr, INS[20:19], INS[18],
												INS[17:14], INS[13:11], INS[10:8], INS[7:0]);
		#1 reset = 0;
		$display("ADDRESS CONTROL TO CPU");
		forever begin
			#5 $display("%d\t%d\t%d\t%d\t%b\t%d\t%b %b %b %b %b %b", R0, R1, R2, R3, FLAGS, Addr, INS[20:19], INS[18],
													INS[17:14], INS[13:11], INS[10:8], INS[7:0]);
			#5 CLK = 1; #5 CLK = 0;				// One Clock tick: lo->hi->lo
		end
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
