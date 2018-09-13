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

/*
IR runs on inverted clock of the original. But is still falling edge active.
        _____		
   ____/		   <-- for this interval the PC has the same value
								
   ____
       \_____   so if the REG clock is like this, the reg will have loaded and secured its input safely during a same 					instruction from PC
*/

module instReg(Addr, PL, PL_E, CLK);
	output [7:0] Addr;
	input  [7:0] PL;
	input  CLK, PL_E;
	wire   invCLK;			
							
	wire   [7:0] regToInc, muxToReg;
	
	not      n0(invCLK, CLK);
	bytemux2 MX(muxToReg, Addr, PL, PL_E);
	register RG(regToInc, muxToReg, invCLK);
	byteIncrementer inc(Addr, regToInc);
endmodule

module uArch();
	reg  [7:0] IMM;
	reg	 [3:0] opcode_alu;
	reg  E, MS1, MS0, RS2, RS1, RS0, AR2, AR1, AR0;			// AR stands or ALU_A and RegBank select lines.
	reg  BS2, BS1, BS0, IRS, CLK, flagWbit;  				// IRS: Immed/Reg Select
	wire [7:0] R0, R1, R2, R3, R4, R5, R6, R7, AREG, Breg;	// AREG stands for AccumulatorMux_A and RegisterInputforRegBank
	wire [7:0] Bline, FLG, ALU, FLAG, Addr;					// This single Bus from AREG MUX feeds RegBank and ALU both.
	integer lc0, lc1, lc2;
	
	reg    JS2, JS1, JS0, j;
	wire   JMP, PL_E;

	regBank  RB0(R0, R1, R2, R3, R4, R5, R6, R7, ALU, AREG, IMM, MS1, MS0, RS2, RS1, RS0, CLK, E);
	bytemux8 AREGMUX(AREG, R0, R1, R2, R3, R4, R5, R6, R7, AR2, AR1, AR0);
	bytemux8 BMUX0(Breg, R0, R1, R2, R3, R4, R5, R6, R7, BS2, BS1, BS0); // BS stands for B_Input select lines
	bytemux2 BMUX1(Bline, Breg, IMM, IRS);
	ALU		 ALU0(ALU, FLG, AREG, Bline, opcode_alu);					// ALU stands for ALU output, ALU0 is the actual.
	register flags(FLAG,FLG, flagWbit);

	bitmux8  jmpMux(JMP, FLAG[7], FLAG[6], FLAG[5], FLAG[4], FLAG[3], FLAG[2], FLAG[1], FLAG[0], JS2, JS1, JS0);
	xnor	 jmpXnor(PL_E, JMP, j);
	instReg  PC(Addr, IMM, PL_E, CLK);		// Parallel load to be given as IMM

	initial begin
		$monitor("%d  %d  %d  %d  %d  %d  %d  %d\t%d", R0, R1, R2, R3, R4, R5, R6, R7, Addr);
		flagWbit = 1; #1 flagWbit = 0;
		CLK = 0;
		// JMP #0
		IMM = 0;
		JS2 = 0; JS1 = 0; JS0 = 0; j = 0;
		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)
		j = 1;

		E = 1;
		//  MOV R0, #5
		MS1 = 1'b1; MS0 = 1'b0;		//  Move Mode Select: Immediate Move			
		RS2 = 1'b0; RS1 = 1'b0; RS0 = 1'b0;	// Register Select: 0
		BS2 = 1'b1; BS1 = 1'b1; BS0 = 1'b1;	// B arg of alu, does not matter
		AR2 = 1'b1; AR1 = 1'b1; AR0 = 1'b1; // A arg of alu, does not matter
		IMM = 8'd5;							// 5 on the immed line
		IRS = 1'b0;

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  MOV R1, #7
		MS1 = 1'b1; MS0 = 1'b0;		//  Move Mode Select: Immediate Move			
		RS2 = 1'b0; RS1 = 1'b0; RS0 = 1'b1;	// Register Select: 1
		BS2 = 1'b1; BS1 = 1'b1; BS0 = 1'b1;	// B arg of alu, does not matter
		AR2 = 1'b1; AR1 = 1'b1; AR0 = 1'b1; // A arg of alu, does not matter
		IMM = 8'd7;							// 7 on the immed line
		IRS = 1'b0;

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  ADD R0, R0, R1			
		MS1 = 1'b0; MS0 = 1'b0;		//  Move Mode Select: ALU move		
		RS2 = 1'b0; RS1 = 1'b0; RS0 = 1'b0;	// Register Select: 0. Select R0 for write
		BS2 = 1'b0; BS1 = 1'b0; BS0 = 1'b1;	// B arg of alu, selects R1
		AR2 = 1'b0; AR1 = 1'b0; AR0 = 1'b0; // A arg of ALU/REG_IN, selects R0. Since ALU mode is selected, A has ALU input
		IMM = 8'd5;							// Immed does not matter
		IRS = 1'b0;							// IRS in register mode. B inp of ALU is from REG
		opcode_alu = 4'b0000;				// Addition opcode

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  ADD R0, R0, #9			
		MS1 = 1'b0; MS0 = 1'b0;		//  Move Mode Select: ALU move		
		RS2 = 1'b0; RS1 = 1'b0; RS0 = 1'b0;	// Register Select: 0. Select R0 for write
		BS2 = 1'b0; BS1 = 1'b0; BS0 = 1'b1;	// B arg of alu, selects R1. DNC
		AR2 = 1'b0; AR1 = 1'b0; AR0 = 1'b0; // A arg of ALU/REG_IN, selects R0. Since ALU mode is selected, A has ALU input
		IMM = 8'd9;							// Immed:9
		IRS = 1'b1;							// IRS in IMMED mode.
		opcode_alu = 4'b0000;				// Addition opcode

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  MOV	R7, R1		
		MS1 = 1'b0; MS0 = 1'b1;		//  Move Mode Select: REG (to REG) Move		
		RS2 = 1'b1; RS1 = 1'b1; RS0 = 1'b1;	// Register Select: 7. Select R7 for write
		BS2 = 1'b0; BS1 = 1'b0; BS0 = 1'b1;	// B arg of alu, selects R1. DNC
		AR2 = 1'b0; AR1 = 1'b0; AR0 = 1'b0; // A arg of ALU/REG_IN, selects R0. Since ALU mode is selected, A has ALU input
		IMM = 8'd9;							// Immed:9. DNC
		IRS = 1'b1;							// IRS in IMMED mode. DNC
		opcode_alu = 4'b0000;				// Addition opcode. DNC

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  SHL	R6, R0
		MS1 = 1'b0; MS0 = 1'b0;		//  Move Mode Select: REG (to REG) Move		
		RS2 = 1'b1; RS1 = 1'b1; RS0 = 1'b0;	// Register Select: 6. Select R6 for write
		BS2 = 1'b0; BS1 = 1'b0; BS0 = 1'b1;	// B arg of alu, selects R1. DNC
		AR2 = 1'b0; AR1 = 1'b0; AR0 = 1'b0; // A arg of ALU/REG_IN, selects R0. Since ALU mode is selected, A has ALU input
		IMM = 8'd9;							// Immed:9. DNC
		IRS = 1'b1;							// IRS in IMMED mode. DNC
		opcode_alu = 4'b0100;				// Shift Left opcode

		#1 CLK = 1; #1 CLK = 0;		// Clock High and Low (High captures Data, Low writes to pin)
	end
endmodule
