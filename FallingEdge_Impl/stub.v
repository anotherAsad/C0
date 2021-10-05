`include "core.v"

module testbench();
	reg PL_E, CLK;
	reg [7:0] PL;
	wire[7:0] Addr;
	integer i;

	instPtr PC(Addr, PL, PL_E, CLK);
	
	initial begin
		CLK = 0;
		PL = 8'b00000000;
		PL_E = 1;
		#1 CLK = 1; #1 CLK = 0;
		PL_E = 0;
		for(i=0; i<10; i=i+1)begin
			$display("TRU:%d %d", Addr, CLK);
			#1 CLK = ~CLK;
			#100;
		end
	end
endmodule
