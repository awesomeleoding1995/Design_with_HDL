//Top level entity
//Author: Li Ding
//Last updated: 23/04/2019

//join all sub-modules together
module Lab4_Lee
(
	input key_0,				//states switch
	input key_1,				//panic feature switch
	input [3:0] SW,			//movement input switch
	input clk_50,				//50MHz clock
	
	output led_7,				//armed/triggered display
	output led_6,				//disarmed display
	output [3:0] led_52,		//movement display
	output led_1,				//strobe light display
	output led_0				//siren light display
);

//use wire to connect sub-modules
wire K0;
wire K1;
wire clk_10;
wire clk_1;
wire countout_p2;
wire countout_p1;
wire enable_p2;
wire enable_p1;
wire [3:0] move_led;
wire [3:0] move_latch;


//key0 and key1 debouncing
sr_latch key0_debounce (.s(key_0), .r(!key_0), .sr_q(K0));
sr_latch key1_debounce (.s(key_1), .r(!key_1), .sr_q(K1));
	
//create clocks
//1kHz clock to drive state machine
//1Hz clock to drive strobe light
//counter_timer #(22, 2500000) pones_timer (.clk_in(clk_50), .clk_out(clk_10));
//counter_timer #(25, 25000000) ones_timer (.clk_in(clk_50), .clk_out(clk_1));

//for modelsim simulation: reference clk period = 100ps
//use period = 50ps clk to drive state machine
//use period = 25ps clk to drive strobe light
counter_timer #(2, 2) onems_timer (.clk_in(clk_50), .clk_out(clk_10));
counter_timer #(3, 4) ones_timer (.clk_in(clk_50), .clk_out(clk_1));

//create counters
//5 second and 10 second counters
//counter #(6, 50) fivesec_counter (.clk_in(clk_10), .enable_count(enable_p2), .count_out(countout_p2));
//counter #(7, 100) tensec_counter (.clk_in(clk_10), .enable_count(enable_p1), .count_out(countout_p1));

//for modelsim simulation: reference clk period = 100ps
//count 800ps and 1600ps respectively
counter #(3, 5) fivesec_counter (.clk_in(clk_10), .enable_count(enable_p2), .count_out(countout_p2));
counter #(4, 10) tensec_counter  (.clk_in(clk_10), .enable_count(enable_p1), .count_out(countout_p1));

//connect the state machine
home_alarm_system testDemo
(
	//input connection
	.KEY_0(K0), 
	.KEY_1(K1),
	.CLOCK_IN(clk_10), 
	.CLOCK_1(clk_1),
	.COUNT_OUT_P2(countout_p2), 
	.COUNT_OUT_P1(countout_p1),
	.MOVEMENT_SW(SW),
	
	//output connection
	.SIREN_LED(led_0), 
	.STROBE_LED(led_1),
	.MOVEMENT_LED(move_led), 
	.MOVEMENT_LATCH(move_latch),
	.AORT_LED(led_7), 
	.D_LED(led_6),
	.ENABLE_COUNT_P2(enable_p2),
	.ENABLE_COUNT_P1(enable_p1)	
);

//movement display latch 
sr_latch movement_dislay3 (.s(move_led[3]), .r(move_latch[3]), .sr_q(led_52[3]));
sr_latch movement_dislay2 (.s(move_led[2]), .r(move_latch[2]), .sr_q(led_52[2]));
sr_latch movement_dislay1 (.s(move_led[1]), .r(move_latch[1]), .sr_q(led_52[1]));
sr_latch movement_dislay0 (.s(move_led[0]), .r(move_latch[0]), .sr_q(led_52[0]));
endmodule
