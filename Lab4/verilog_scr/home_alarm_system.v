//Home alarm system
//Author: Li Ding
//Last updated: 23/04/2019

//create a home alarm sub-module
module home_alarm_system
(
	//define inputs
	input KEY_0,						//armed/disarmed switch
	input KEY_1,						//'panic' feature switc
	input CLOCK_IN,					//50MHz reference clock
	input CLOCK_1,						//1Hz clock input
	input COUNT_OUT_P2,				//0.2Hz (5sec) counter input
	input COUNT_OUT_P1,				//0.1Hz (10sec) counter input
	input [3:0] MOVEMENT_SW,		//movement setting
	//define outputs
	output SIREN_LED,					//siren led
	output STROBE_LED,				//strobe light led
	output [3:0] MOVEMENT_LED,		//movement display led
	output [3:0] MOVEMENT_LATCH,	//movement latch to sr latch
	output AORT_LED,					//armed or triggered state led
	output D_LED,						//disarmed state led	
	output ENABLE_COUNT_P2,			//enable external 5sec counter
	output ENABLE_COUNT_P1			//enable external 10sec counter
	
);

//set variables LEDs and counter enable
reg siren_led;					//siren led
reg strobe_led;				//strobe led
reg [3:0] movement_led;		//movement display led
reg aort_led;					//armed or triggered state led
reg d_led;						//disarmed state led
reg enable_count_p2;			//5sec counter enable
reg enable_count_p1;			//10sec counter enable
reg [3:0] movement_latch;	//movement latch control

//declare states with parameter
parameter disarmed_state = 3'b000;	//disarmed state
parameter fivesec_latency = 3'b001; //5sec latency state
parameter armed_state = 3'b010;		//armed state (include detecting state)
parameter triggered_state = 3'b011;	//triggered state
parameter tensec_latency = 3'b100;	//10sec latency state
parameter panic_state = 3'b101;		//panic state
	
//parameter armed_latch = 3'b110;		//state used to latch movement

//variables to hold current state/next state
reg [2:0] currentState;
reg [2:0] nextState;

//create stateMemory logic
always @(posedge CLOCK_IN)
	begin: stateMemory
		//panic state has the highest priority 
		if(KEY_1 == 1'b0) 
			begin 
				currentState <= panic_state; 
			end
		else 
			begin 
				currentState <= nextState; 
			end
	end

//create nextState logic
//several sensetive signal: key0, external clock signals and movement
always @(currentState, KEY_0, COUNT_OUT_P2, COUNT_OUT_P1, MOVEMENT_SW)
	begin: nextStateLogic
		//using a 'case' statement
		case(currentState)
			disarmed_state:
				begin
					if(KEY_0 == 1'b0)						//press key0 to arm the alarm
						nextState = fivesec_latency;	//key0 pressed enter next state
					else
						nextState = disarmed_state;	//stay in current state
				end
			fivesec_latency:
				begin
					if(COUNT_OUT_P2 == 1'b1)			//detect count_complete signal from 5sec counter
						nextState = armed_state;		//enter next state
					else
						nextState = fivesec_latency;	//stay in current state and wait for signal
				end
			armed_state:
				begin
					if(KEY_0 == 1'b0)						//press key0 to disarm the alarm
						nextState = disarmed_state;	//key0 pressed back to disarmed state
					else if(MOVEMENT_SW == 4'b0)		//detect movement
						nextState = armed_state;
					else
						nextState = triggered_state;	//movement detected go to triggered state
				end
			triggered_state:
				begin
					if(KEY_0 == 1'b0)						//press key0 to disarm the alarm
						nextState = disarmed_state;
					else
						nextState = tensec_latency;	//enter 10sec latency
				end
			tensec_latency:
				begin
					if(KEY_0 == 1'b0)						//press key0 to disarm the alarm
						nextState = disarmed_state;
					else if(COUNT_OUT_P1 == 1'b1)		//detect count_complete signal from 10sec counter
						nextState = armed_state;		//back to armed state
						//nextState = armed_latch;
					else
						nextState = tensec_latency;	//stay in current state and wait for signal
				end
			panic_state:
				begin
					if(KEY_0 == 1'b0)						//press key0 to disarm the alarm
						nextState = disarmed_state;
					else
						nextState = panic_state;		
				end
			//armed_latch:
				//begin
					//if(KEY_0 == 1'b0)						//press key0 to disarm the alarm
						//nextState = disarmed_state;
					//else
						//nextState = armed_latch;		//enter 10sec latency
				//end
			default:
				begin
						nextState = disarmed_state;	//stay in current state
				end
				
		endcase
	end
//create outputLogic
always @(currentState, KEY_0, COUNT_OUT_P2, COUNT_OUT_P1, CLOCK_1, MOVEMENT_SW)
	begin: outputLogic
		//using a 'case' statement
		case(currentState)
			disarmed_state:
				begin
					siren_led = 1'b0;						//siren off
					strobe_led = 1'b0;					//strobe off
					movement_led = 4'b0000;				//movement display off
					aort_led = 1'b0;						//armed or triggered light off
					d_led = 1'b1;							//disarmed light on
					enable_count_p2 = 1'b0;				//set counter enable 0
					enable_count_p1 = 1'b0;
					movement_latch = 4'b1111;
				end
			fivesec_latency:
				begin
					siren_led = 1'b0;
					strobe_led = 1'b0;
					movement_led = 4'b0000;
					aort_led = 1'b0;
					d_led = 1'b1;							//disarmed light still on
					enable_count_p2 = 1'b1;				//enable counting for 5 second
					enable_count_p1 = 1'b0;
					movement_latch = 4'b0000;
				end
			armed_state:
				begin
					siren_led = 1'b0;
					strobe_led = 1'b0;
					movement_led = 4'b0000;
					aort_led = 1'b1;						//armed light on
					d_led = 1'b0;
					enable_count_p2 = 1'b0;
					enable_count_p1 = 1'b0;
					movement_latch = 4'b0000;
				end
			triggered_state:
				begin
					siren_led = 1'b1;						//siren on
					strobe_led = &CLOCK_1;				//strobe light blinks 
					movement_led = MOVEMENT_SW;		//display movement
					aort_led = 1'b1;						//triggered light on
					d_led = 1'b0;
					enable_count_p2 = 1'b0;
					enable_count_p1 = 1'b0;
					movement_latch = 4'b0000;
				end
			tensec_latency:
				begin
					siren_led = 1'b1;						//siren sitll on
					strobe_led = &CLOCK_1;				//strobe light blinks
					movement_led = MOVEMENT_SW;		//display movement
					aort_led = 1'b1;						//triggered light still on
					d_led = 1'b0;
					enable_count_p2 = 1'b0;
					enable_count_p1 = 1'b1;				//enable counting for 10 second
					movement_latch = 4'b0000;
				end
			panic_state:
				begin
					siren_led = 1'b1;
					strobe_led = &CLOCK_1;
					movement_led = 4'b0000;					//skip movement detect
					aort_led = 1'b1;
					d_led = 1'b0;
					enable_count_p2 = 1'b0;
					enable_count_p1 = 1'b0;
					movement_latch = 4'b1111;
				end
			//armed_latch:
				//begin
					//siren_led = 1'b0;
					//strobe_led = 1'b0;
					//movement_led = 4'b0000;
					//aort_led = 1'b1;						//armed light on
					//d_led = 1'b0;
					//enable_count_p2 = 1'b0;
					//enable_count_p1 = 1'b0;
					//movement_latch = 4'b0000;
				//end
			default:
				begin
					siren_led = 1'b0;						//siren off
					strobe_led = 1'b0;					//strobe off
					movement_led = 4'b0000;				//movement display off
					aort_led = 1'b0;						//armed or triggered light off
					d_led = 1'b1;							//disarmed light on
					enable_count_p2 = 1'b0;				//set counter enable 0
					enable_count_p1 = 1'b0;
					movement_latch = 4'b1111;
				end
		
		endcase
	end

//Final assignment
assign SIREN_LED = siren_led;
assign STROBE_LED = strobe_led; 
assign MOVEMENT_LED = movement_led;
assign AORT_LED = aort_led;
assign D_LED = d_led;	
assign ENABLE_COUNT_P2 = enable_count_p2;			
assign ENABLE_COUNT_P1 = enable_count_p1;
assign MOVEMENT_LATCH = movement_latch;
endmodule

