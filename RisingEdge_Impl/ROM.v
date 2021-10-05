module ROM(INSTRUCTION, ADDR);
	output [20:0] INSTRUCTION;
	input  [07:0] ADDR;

	reg [20:0] i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i0A, i0B, i0C, i0D, i0E, i0F,
			   i10, i11, i12, i13, i14, i15, i16, i17, i18, i19, i1A, i1B, i1C, i1D, i1E, i1F,
			   i20, i21, i22, i23, i24, i25, i26, i27, i28, i29, i2A, i2B, i2C, i2D, i2E, i2F,
		       i30, i31, i32, i33, i34, i35, i36, i37, i38, i39, i3A, i3B, i3C, i3D, i3E, i3F,
			   i40, i41, i42, i43, i44, i45, i46, i47, i48, i49, i4A, i4B, i4C, i4D, i4E, i4F,
			   i50, i51, i52, i53, i54, i55, i56, i57, i58, i59, i5A, i5B, i5C, i5D, i5E, i5F,
		       i60, i61, i62, i63, i64, i65, i66, i67, i68, i69, i6A, i6B, i6C, i6D, i6E, i6F,
			   i70, i71, i72, i73, i74, i75, i76, i77, i78, i79, i7A, i7B, i7C, i7D, i7E, i7F,
			   i80, i81, i82, i83, i84, i85, i86, i87, i88, i89, i8A, i8B, i8C, i8D, i8E, i8F,
			   i90, i91, i92, i93, i94, i95, i96, i97, i98, i99, i9A, i9B, i9C, i9D, i9E, i9F,
			   iA0, iA1, iA2, iA3, iA4, iA5, iA6, iA7, iA8, iA9, iAA, iAB, iAC, iAD, iAE, iAF,
			   iB0, iB1, iB2, iB3, iB4, iB5, iB6, iB7, iB8, iB9, iBA, iBB, iBC, iBD, iBE, iBF,
			   iC0, iC1, iC2, iC3, iC4, iC5, iC6, iC7, iC8, iC9, iCA, iCB, iCC, iCD, iCE, iCF,
			   iD0, iD1, iD2, iD3, iD4, iD5, iD6, iD7, iD8, iD9, iDA, iDB, iDC, iDD, iDE, iDF,
			   iE0, iE1, iE2, iE3, iE4, iE5, iE6, iE7, iE8, iE9, iEA, iEB, iEC, iED, iEE, iEF,
			   iF0, iF1, iF2, iF3, iF4, iF5, iF6, iF7, iF8, iF9, iFA, iFB, iFC, iFD, iFE, iFF;

	instrMUX bigMUX(
		INSTRUCTION,
		i00, i01, i02, i03, i04, i05, i06, i07, i08, i09, i0A, i0B, i0C, i0D, i0E, i0F,
		i10, i11, i12, i13, i14, i15, i16, i17, i18, i19, i1A, i1B, i1C, i1D, i1E, i1F,
		i20, i21, i22, i23, i24, i25, i26, i27, i28, i29, i2A, i2B, i2C, i2D, i2E, i2F,
		i30, i31, i32, i33, i34, i35, i36, i37, i38, i39, i3A, i3B, i3C, i3D, i3E, i3F,
		i40, i41, i42, i43, i44, i45, i46, i47, i48, i49, i4A, i4B, i4C, i4D, i4E, i4F,
		i50, i51, i52, i53, i54, i55, i56, i57, i58, i59, i5A, i5B, i5C, i5D, i5E, i5F,
		i60, i61, i62, i63, i64, i65, i66, i67, i68, i69, i6A, i6B, i6C, i6D, i6E, i6F,
		i70, i71, i72, i73, i74, i75, i76, i77, i78, i79, i7A, i7B, i7C, i7D, i7E, i7F,
		i80, i81, i82, i83, i84, i85, i86, i87, i88, i89, i8A, i8B, i8C, i8D, i8E, i8F,
		i90, i91, i92, i93, i94, i95, i96, i97, i98, i99, i9A, i9B, i9C, i9D, i9E, i9F,
		iA0, iA1, iA2, iA3, iA4, iA5, iA6, iA7, iA8, iA9, iAA, iAB, iAC, iAD, iAE, iAF,
		iB0, iB1, iB2, iB3, iB4, iB5, iB6, iB7, iB8, iB9, iBA, iBB, iBC, iBD, iBE, iBF,
		iC0, iC1, iC2, iC3, iC4, iC5, iC6, iC7, iC8, iC9, iCA, iCB, iCC, iCD, iCE, iCF,
		iD0, iD1, iD2, iD3, iD4, iD5, iD6, iD7, iD8, iD9, iDA, iDB, iDC, iDD, iDE, iDF,
		iE0, iE1, iE2, iE3, iE4, iE5, iE6, iE7, iE8, iE9, iEA, iEB, iEC, iED, iEE, iEF,
		iF0, iF1, iF2, iF3, iF4, iF5, iF6, iF7, iF8, iF9, iFA, iFB, iFC, iFD, iFE, iFF,
		ADDR
	);
	initial begin
		// ROM DUMP FOLLOWS
		i00 = 21'b001011100000000000000;
		i01 = 21'b011000000000011011101;
		i02 = 21'b011000001100000000000;
		i03 = 21'b011000001000000000000;
		i04 = 21'b110000100000000000000;
		i05 = 21'b111000001101100000111;
		i06 = 21'b111000001001000000101;
		i07 = 21'b110000000000001100000;
		i08 = 21'b001011100000000000100;

		i09 = 21'b111000001001000000101;
		i0A = 21'b001011100000000000111;
		i0B = 21'b110000000101001100000;
		i0C = 21'b001011100000000001000;
		i0D = 21'b111000000000000001001;
		i0E = 21'b111000000000000001001;
		i0F = 21'b111000000000000001001;
		i10 = 21'b111000000000000001001;
		i11 = 21'b111000000000000001001;
		i12 = 21'b111000000000000001001;
		i13 = 21'b111000000000000001001;
		i14 = 21'b111000000000000001001;
		i15 = 21'b111000000000000001001;
		i16 = 21'b111000000000000001001;
		i17 = 21'b111000000000000001001;
		i18 = 21'b111000000000000001001;
		i19 = 21'b111000000000000001001;
		i1A = 21'b111000000000000001001;
		i1B = 21'b111000000000000001001;
		i1C = 21'b111000000000000001001;
		i1D = 21'b111000000000000001001;
		i1E = 21'b111000000000000001001;
		i1F = 21'b111000000000000001001;
		i20 = 21'b111000000000000001001;
		i21 = 21'b111000000000000001001;
		i22 = 21'b111000000000000001001;
		i23 = 21'b111000000000000001001;
		i24 = 21'b111000000000000001001;
		i25 = 21'b111000000000000001001;
		i26 = 21'b111000000000000001001;
		i27 = 21'b111000000000000001001;
		i28 = 21'b111000000000000001001;
		i29 = 21'b111000000000000001001;
		i2A = 21'b111000000000000001001;
		i2B = 21'b111000000000000001001;
		i2C = 21'b111000000000000001001;
		i2D = 21'b111000000000000001001;
		i2E = 21'b111000000000000001001;
		i2F = 21'b111000000000000001001;
		i30 = 21'b111000000000000001001;
		i31 = 21'b111000000000000001001;
		i32 = 21'b111000000000000001001;
		i33 = 21'b111000000000000001001;
		i34 = 21'b111000000000000001001;
		i35 = 21'b111000000000000001001;
		i36 = 21'b111000000000000001001;
		i37 = 21'b111000000000000001001;
		i38 = 21'b111000000000000001001;
		i39 = 21'b111000000000000001001;
		i3A = 21'b111000000000000001001;
		i3B = 21'b111000000000000001001;
		i3C = 21'b111000000000000001001;
		i3D = 21'b111000000000000001001;
		i3E = 21'b111000000000000001001;
		i3F = 21'b111000000000000001001;
		i40 = 21'b111000000000000001001;
		i41 = 21'b111000000000000001001;
		i42 = 21'b111000000000000001001;
		i43 = 21'b111000000000000001001;
		i44 = 21'b111000000000000001001;
		i45 = 21'b111000000000000001001;
		i46 = 21'b111000000000000001001;
		i47 = 21'b111000000000000001001;
		i48 = 21'b111000000000000001001;
		i49 = 21'b111000000000000001001;
		i4A = 21'b111000000000000001001;
		i4B = 21'b111000000000000001001;
		i4C = 21'b111000000000000001001;
		i4D = 21'b111000000000000001001;
		i4E = 21'b111000000000000001001;
		i4F = 21'b111000000000000001001;
		i50 = 21'b111000000000000001001;
		i51 = 21'b111000000000000001001;
		i52 = 21'b111000000000000001001;
		i53 = 21'b111000000000000001001;
		i54 = 21'b111000000000000001001;
		i55 = 21'b111000000000000001001;
		i56 = 21'b111000000000000001001;
		i57 = 21'b111000000000000001001;
		i58 = 21'b111000000000000001001;
		i59 = 21'b111000000000000001001;
		i5A = 21'b111000000000000001001;
		i5B = 21'b111000000000000001001;
		i5C = 21'b111000000000000001001;
		i5D = 21'b111000000000000001001;
		i5E = 21'b111000000000000001001;
		i5F = 21'b111000000000000001001;
		i60 = 21'b111000000000000001001;
		i61 = 21'b111000000000000001001;
		i62 = 21'b111000000000000001001;
		i63 = 21'b111000000000000001001;
		i64 = 21'b111000000000000001001;
		i65 = 21'b111000000000000001001;
		i66 = 21'b111000000000000001001;
		i67 = 21'b111000000000000001001;
		i68 = 21'b111000000000000001001;
		i69 = 21'b111000000000000001001;
		i6A = 21'b111000000000000001001;
		i6B = 21'b111000000000000001001;
		i6C = 21'b111000000000000001001;
		i6D = 21'b111000000000000001001;
		i6E = 21'b111000000000000001001;
		i6F = 21'b111000000000000001001;
		i70 = 21'b111000000000000001001;
		i71 = 21'b111000000000000001001;
		i72 = 21'b111000000000000001001;
		i73 = 21'b111000000000000001001;
		i74 = 21'b111000000000000001001;
		i75 = 21'b111000000000000001001;
		i76 = 21'b111000000000000001001;
		i77 = 21'b111000000000000001001;
		i78 = 21'b111000000000000001001;
		i79 = 21'b111000000000000001001;
		i7A = 21'b111000000000000001001;
		i7B = 21'b111000000000000001001;
		i7C = 21'b111000000000000001001;
		i7D = 21'b111000000000000001001;
		i7E = 21'b111000000000000001001;
		i7F = 21'b111000000000000001001;
		i80 = 21'b111000000000000001001;
		i81 = 21'b111000000000000001001;
		i82 = 21'b111000000000000001001;
		i83 = 21'b111000000000000001001;
		i84 = 21'b111000000000000001001;
		i85 = 21'b111000000000000001001;
		i86 = 21'b111000000000000001001;
		i87 = 21'b111000000000000001001;
		i88 = 21'b111000000000000001001;
		i89 = 21'b111000000000000001001;
		i8A = 21'b111000000000000001001;
		i8B = 21'b111000000000000001001;
		i8C = 21'b111000000000000001001;
		i8D = 21'b111000000000000001001;
		i8E = 21'b111000000000000001001;
		i8F = 21'b111000000000000001001;
		i90 = 21'b111000000000000001001;
		i91 = 21'b111000000000000001001;
		i92 = 21'b111000000000000001001;
		i93 = 21'b111000000000000001001;
		i94 = 21'b111000000000000001001;
		i95 = 21'b111000000000000001001;
		i96 = 21'b111000000000000001001;
		i97 = 21'b111000000000000001001;
		i98 = 21'b111000000000000001001;
		i99 = 21'b111000000000000001001;
		i9A = 21'b111000000000000001001;
		i9B = 21'b111000000000000001001;
		i9C = 21'b111000000000000001001;
		i9D = 21'b111000000000000001001;
		i9E = 21'b111000000000000001001;
		i9F = 21'b111000000000000001001;
		iA0 = 21'b111000000000000001001;
		iA1 = 21'b111000000000000001001;
		iA2 = 21'b111000000000000001001;
		iA3 = 21'b111000000000000001001;
		iA4 = 21'b111000000000000001001;
		iA5 = 21'b111000000000000001001;
		iA6 = 21'b111000000000000001001;
		iA7 = 21'b111000000000000001001;
		iA8 = 21'b111000000000000001001;
		iA9 = 21'b111000000000000001001;
		iAA = 21'b111000000000000001001;
		iAB = 21'b111000000000000001001;
		iAC = 21'b111000000000000001001;
		iAD = 21'b111000000000000001001;
		iAE = 21'b111000000000000001001;
		iAF = 21'b111000000000000001001;
		iB0 = 21'b111000000000000001001;
		iB1 = 21'b111000000000000001001;
		iB2 = 21'b111000000000000001001;
		iB3 = 21'b111000000000000001001;
		iB4 = 21'b111000000000000001001;
		iB5 = 21'b111000000000000001001;
		iB6 = 21'b111000000000000001001;
		iB7 = 21'b111000000000000001001;
		iB8 = 21'b111000000000000001001;
		iB9 = 21'b111000000000000001001;
		iBA = 21'b111000000000000001001;
		iBB = 21'b111000000000000001001;
		iBC = 21'b111000000000000001001;
		iBD = 21'b111000000000000001001;
		iBE = 21'b111000000000000001001;
		iBF = 21'b111000000000000001001;
		iC0 = 21'b111000000000000001001;
		iC1 = 21'b111000000000000001001;
		iC2 = 21'b111000000000000001001;
		iC3 = 21'b111000000000000001001;
		iC4 = 21'b111000000000000001001;
		iC5 = 21'b111000000000000001001;
		iC6 = 21'b111000000000000001001;
		iC7 = 21'b111000000000000001001;
		iC8 = 21'b111000000000000001001;
		iC9 = 21'b111000000000000001001;
		iCA = 21'b111000000000000001001;
		iCB = 21'b111000000000000001001;
		iCC = 21'b111000000000000001001;
		iCD = 21'b111000000000000001001;
		iCE = 21'b111000000000000001001;
		iCF = 21'b111000000000000001001;
		iD0 = 21'b111000000000000001001;
		iD1 = 21'b111000000000000001001;
		iD2 = 21'b111000000000000001001;
		iD3 = 21'b111000000000000001001;
		iD4 = 21'b111000000000000001001;
		iD5 = 21'b111000000000000001001;
		iD6 = 21'b111000000000000001001;
		iD7 = 21'b111000000000000001001;
		iD8 = 21'b111000000000000001001;
		iD9 = 21'b111000000000000001001;
		iDA = 21'b111000000000000001001;
		iDB = 21'b111000000000000001001;
		iDC = 21'b111000000000000001001;
		iDD = 21'b111000000000000001001;
		iDE = 21'b111000000000000001001;
		iDF = 21'b111000000000000001001;
		iE0 = 21'b111000000000000001001;
		iE1 = 21'b111000000000000001001;
		iE2 = 21'b111000000000000001001;
		iE3 = 21'b111000000000000001001;
		iE4 = 21'b111000000000000001001;
		iE5 = 21'b111000000000000001001;
		iE6 = 21'b111000000000000001001;
		iE7 = 21'b111000000000000001001;
		iE8 = 21'b111000000000000001001;
		iE9 = 21'b111000000000000001001;
		iEA = 21'b111000000000000001001;
		iEB = 21'b111000000000000001001;
		iEC = 21'b111000000000000001001;
		iED = 21'b111000000000000001001;
		iEE = 21'b111000000000000001001;
		iEF = 21'b111000000000000001001;
		iF0 = 21'b111000000000000001001;
		iF1 = 21'b111000000000000001001;
		iF2 = 21'b111000000000000001001;
		iF3 = 21'b111000000000000001001;
		iF4 = 21'b111000000000000001001;
		iF5 = 21'b111000000000000001001;
		iF6 = 21'b111000000000000001001;
		iF7 = 21'b111000000000000001001;
		iF8 = 21'b111000000000000001001;
		iF9 = 21'b111000000000000001001;
		iFA = 21'b111000000000000001001;
		iFB = 21'b111000000000000001001;
		iFC = 21'b111000000000000001001;
		iFD = 21'b111000000000000001001;
		iFE = 21'b111000000000000001001;
		iFF = 21'b111000000000000001001;
		// ROM DUMP ENDS
	end
endmodule
