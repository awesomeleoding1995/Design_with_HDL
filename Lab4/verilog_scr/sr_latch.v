//Create SR Latch for input KEY1('panic' triggered set) & KEY0(armed/disarmed set)
//Author: Li Ding
//Last updated: 15/04/2019


module sr_latch
(
	input s, r,		//define input set, reset
	output sr_q		//define output q
);

reg SR_Q;			

always @(s, r)
	begin
		if (s == 1'b1 && r == 1'b0) SR_Q <= 1'b1;			//set
		else if (s == 1'b0 && r == 1'b1) SR_Q <= 1'b0;	//reset
		else SR_Q <= SR_Q;										//hold
	end
	
assign sr_q = SR_Q;

endmodule 
