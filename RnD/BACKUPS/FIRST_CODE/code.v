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

module uArch();
	reg  [7:0] IMM;
	reg	 [3:0] opcode_alu;
	reg  E, MS1, MS0, RS2, RS1, RS0, AR2, AR1, AR0;			// AR stands or ALU_A and RegBank select lines.
	reg  BS2, BS1, BS0, IRS;  	// IRS: Immed/Reg Select
	wire [7:0] R0, R1, R2, R3, R4, R5, R6, R7, AREG, Breg;	// AREG stands for AccumulatorMux_A and RegisterInputforRegBank
	wire [7:0] Bline, FLG, ALU;								// This single Bus from AREG MUX feeds RegBank and ALU both.
	integer lc0, lc1, lc2;
	
	regBank  RB0(R0, R1, R2, R3, R4, R5, R6, R7, ALU, AREG, IMM, MS1, MS0, RS2, RS1, RS0, E);
	bytemux8 AREGMUX(AREG, R0, R1, R2, R3, R4, R5, R6, R7, AR2, AR1, AR0);
	bytemux8 BMUX0(Breg, R0, R1, R2, R3, R4, R5, R6, R7, BS2, BS1, BS0); // BS stands for B_Input select lines
	bytemux2 BMUX1(Bline, Breg, IMM, IRS);
	ALU		 ALU0(ALU, FLG, AREG, Bline, opcode_alu);					// ALU stands for ALU output, ALU0 is the actual.
	initial begin
		$monitor("%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", R0, R1, R2, R3, R4, R5, R6, R7);

		//  MOV R0, #5
		MS1 = 1'b1; MS0 = 1'b0;		//  Move Mode Select: Immediate Move			
		RS2 = 1'b0; RS1 = 1'b0; RS0 = 1'b0;	// Register Select: 0
		BS2 = 1'b1; BS1 = 1'b1; BS0 = 1'b1;	// B arg of alu, does not matter
		AR2 = 1'b1; AR1 = 1'b1; AR0 = 1'b1; // A arg of alu, does not matter
		IMM = 8'd5;							// 5 on the immed line
		IRS = 1'b0;

		#1 E = 1; #1 E = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  MOV R1, #7
		MS1 = 1'b1; MS0 = 1'b0;		//  Move Mode Select: Immediate Move			
		RS2 = 1'b0; RS1 = 1'b0; RS0 = 1'b1;	// Register Select: 1
		BS2 = 1'b1; BS1 = 1'b1; BS0 = 1'b1;	// B arg of alu, does not matter
		AR2 = 1'b1; AR1 = 1'b1; AR0 = 1'b1; // A arg of alu, does not matter
		IMM = 8'd7;							// 7 on the immed line
		IRS = 1'b0;

		#1 E = 1; #1 E = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  ADD R0, R0, R1			
		MS1 = 1'b0; MS0 = 1'b0;		//  Move Mode Select: ALU move		
		RS2 = 1'b0; RS1 = 1'b0; RS0 = 1'b0;	// Register Select: 0. Select R0 for write
		BS2 = 1'b0; BS1 = 1'b0; BS0 = 1'b1;	// B arg of alu, selects R1
		AR2 = 1'b0; AR1 = 1'b0; AR0 = 1'b0; // A arg of ALU/REG_IN, selects R0. Since ALU mode is selected, A has ALU input
		IMM = 8'd5;							// Immed does not matter
		IRS = 1'b0;							// IRS in register mode. B inp of ALU is from REG
		opcode_alu = 4'b0000;				// Addition opcode

		#1 E = 1; #1 E = 0;		// Clock High and Low (High captures Data, Low writes to pin)

		//  ADD R0, R0, #9			
		MS1 = 1'b0; MS0 = 1'b0;		//  Move Mode Select: ALU move		
		RS2 = 1'b0; RS1 = 1'b0; RS0 = 1'b0;	// Register Select: 0. Select R0 for write
		BS2 = 1'b0; BS1 = 1'b0; BS0 = 1'b1;	// B arg of alu, selects R1. DNC
		AR2 = 1'b0; AR1 = 1'b0; AR0 = 1'b0; // A arg of ALU/REG_IN, selects R0. Since ALU mode is selected, A has ALU input
		IMM = 8'd9;							// Immed:9
		IRS = 1'b1;							// IRS in IMMED mode.
		opcode_alu = 4'b0000;				// Addition opcode

		#1 E = 1; #1 E = 0;

		//  MOV	R7, R1		
		MS1 = 1'b0; MS0 = 1'b1;		//  Move Mode Select: REG (to REG) Move		
		RS2 = 1'b1; RS1 = 1'b1; RS0 = 1'b1;	// Register Select: 7. Select R7 for write
		BS2 = 1'b0; BS1 = 1'b0; BS0 = 1'b1;	// B arg of alu, selects R1. DNC
		AR2 = 1'b0; AR1 = 1'b0; AR0 = 1'b0; // A arg of ALU/REG_IN, selects R0. Since ALU mode is selected, A has ALU input
		IMM = 8'd9;							// Immed:9. DNC
		IRS = 1'b1;							// IRS in IMMED mode. DNC
		opcode_alu = 4'b0000;				// Addition opcode

		#1 E = 1; #1 E = 0;

		//  SHL	R6, R0
		MS1 = 1'b0; MS0 = 1'b0;		//  Move Mode Select: REG (to REG) Move		
		RS2 = 1'b1; RS1 = 1'b1; RS0 = 1'b0;	// Register Select: 6. Select R6 for write
		BS2 = 1'b0; BS1 = 1'b0; BS0 = 1'b1;	// B arg of alu, selects R1. DNC
		AR2 = 1'b0; AR1 = 1'b0; AR0 = 1'b0; // A arg of ALU/REG_IN, selects R0. Since ALU mode is selected, A has ALU input
		IMM = 8'd9;							// Immed:9. DNC
		IRS = 1'b1;							// IRS in IMMED mode. DNC
		opcode_alu = 4'b0100;				// Shift Left opcode

		#1 E = 1; #1 E = 0;
	end
endmodule
