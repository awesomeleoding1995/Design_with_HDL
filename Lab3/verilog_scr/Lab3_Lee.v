//Lab3_Lee LED display
//Author: Li Ding
//Last updated: 4/4/1019
//TLE 
module Lab3_Lee 
(
	input preset, tact_sw1, tact_sw0,	//define preset, tactile swtich
	output [7:0] tle_q						//define output
);

wire [3:0] DATA;								//initial data input
wire [3:0] Q1, Q2, Q3, Q4, Q5, Q6, Q7;	//set wire to connect registers
wire sw_clk;									//set wire to connect tactile switch and clock
assign DATA = tle_q;							//set to 0000

wire [3:0] TLE_Q;

sr_latch switch_debouce						//use sr-latch debouce switch to collect stable clock signal
(
	.s(!tact_sw1),								//reset clk to 0
	.r(!tact_sw0),
	.sr_q(sw_clk)
);


four_bit_register #(4,4'b0010) first_register	//first register to deposite 7th number
(
	.fb_d(DATA),
	.fb_clk(sw_clk),
	.fb_preset(preset),
	.fb_q(Q1)
);

four_bit_register #(4,4'b1001) second_register	//second register to deposite 6th number
(
	.fb_d(Q1),
	.fb_clk(sw_clk),
	.fb_preset(preset),
	.fb_q(Q2)
);

four_bit_register #(4,4'b0101) third_register	//third register to deposite 5th number
(
	.fb_d(Q2),
	.fb_clk(sw_clk),
	.fb_preset(preset),
	.fb_q(Q3)
);

four_bit_register #(4,4'b0000) fourth_register	//fourth register to deposite 4th number
(
	.fb_d(Q3),
	.fb_clk(sw_clk),
	.fb_preset(preset),
	.fb_q(Q4)
);

four_bit_register #(4,4'b0000) fifth_register	//fifth register to deposite 3rd number
(
	.fb_d(Q4),
	.fb_clk(sw_clk),
	.fb_preset(preset),
	.fb_q(Q5)
);

four_bit_register #(4,4'b0111) sixth_register	//sixth register to deposite 2nd number
(
	.fb_d(Q5),
	.fb_clk(sw_clk),
	.fb_preset(preset),
	.fb_q(Q6)
);

four_bit_register #(4,4'b0011) seventh_register//seventh register to deposite 1st number
(
	.fb_d(Q6),
	.fb_clk(sw_clk),
	.fb_preset(preset),
	.fb_q(Q7)
);
four_bit_register #(4,4'b0000) last_register//last register to deposite 0000
(
	.fb_d(Q7),
	.fb_clk(sw_clk),
	.fb_preset(preset),
	.fb_q(TLE_Q)
);

assign tle_q = {4'b0000, TLE_Q};

endmodule

