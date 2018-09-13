`include "core.v"

module testbench();
	reg reset, CLK;
	wire Q;
	TRflipflop TRFF(Q, reset, CLK);

	initial begin
		$monitor("%d", Q);
		CLK = 0;
		reset = 1;
#2 CLK = ~CLK;
#2 CLK = ~CLK;
		reset = 1;
		#2 CLK = ~CLK;
#2 CLK = ~CLK;
#2 CLK = ~CLK;
#2 CLK = ~CLK;

#2 CLK = ~CLK;
#2 CLK = ~CLK;

#2 CLK = ~CLK;
#2 CLK = ~CLK;
#2 CLK = ~CLK;
#2 CLK = ~CLK;
	end
endmodule
