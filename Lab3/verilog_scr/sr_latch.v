 //build a SR-Latch sub-module
//Author: Li Ding
//Last updated: 4/4/2019
/*
//'case' statement shows some porblems in debouncing
module sr_latch
(
	input s, r, 				//define input set, reset
	output sr_q 
	//output sr_qn				//define output q, qn
);
// set 4 statues in sr latch
parameter HOLD = 2'b00;		//define HOLD statue 
parameter SET = 2'b10;		//define SET  statue
parameter RESET = 2'b01;	//define RESET statue
parameter INVALID = 2'b11; //define INVALID statue

reg SR_Q;
//reg SR_QN;
assign sr_q = SR_Q;
//assign sr_qn = SR_QN;

always @(s,r)
	begin
		casex ({s,r})			//case statement to assign output
			HOLD:    begin SR_Q <= SR_Q;  end			//s == 0 && r == 0
			RESET:   begin SR_Q <= 1'b0;  end		//s == 0 && r == 1
			SET:     begin SR_Q <= 1'b1;  end		//s == 1 && r == 0
			INVALID: begin SR_Q <= 1'bx;  end		//s == 1 && r == 1
			default: begin SR_Q <= 1'b0;  end		//default setting: q = 0
		endcase	
	end
	
endmodule
*/

//create another SR-Latch with 'if' statement 
module sr_latch
(
	input s, r,		//define input set, reset
	output sr_q		//define output q
);

reg SR_Q;			
assign sr_q = SR_Q;

always @(s, r)
	begin
		if (s == 1'b0 && r == 1'b0) SR_Q <= SR_Q;			//hold or store
		else if (s == 1'b1 && r == 1'b0) SR_Q <= 1'b1;	//set
		else if (s == 1'b0 && r == 1'b1) SR_Q <= 1'b0;	//reset
		else SR_Q <= 1'bx;										//invalid
	end

endmodule 
