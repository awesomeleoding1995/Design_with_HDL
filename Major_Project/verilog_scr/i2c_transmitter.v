//I2C transmitter submodule											//
//Author		  : Li Ding													//
//Last updated: 24/05/2019												//
//Description : this module tries to build a state machine	//
//               which is used to generate serial data (SDA)// 
//               and serial clcok (SCL)							//
//					 the transmitter is drive by 200 kHz clock 	//
module i2c_transmitter
(
	//input 
	RESET,		//reset button to state machine
	CLK_200KHZ,	//200 kHz clock to drive the transimitter 
	START,		//start signal to transfer data
	DEV_ADDR,	//slave/device address	
	REG_ADDR,	//register address
	DATA,			//data transferred
	I2C_SDA_ACK,//acknowledge signal 
	STOP,			//stop signal to start new the transmission
	
	//output
	READY,		//ready signal to inform master
	I2C_SDA_OUT,//serial data output
	I2C_SCL,		//serial clock output
	END,			//end signal to inform master
	I2C_SDA_EN,	//enable to control tri-state buffer
	ERROR_LED
);

//parameters
//declare states
localparam idle = 5'b00000;				//default state
localparam start = 5'b00001;				//1st half start state
localparam start_hold = 5'b00010;		//2nd half start state
localparam device_byte = 5'b00011;		//transmit device address
localparam devbit_hold = 5'b00100;		//prepare next bit
localparam ack_one = 5'b00101;			//wait for acknowledge signal from device
localparam ack_one_hold = 5'b00110;		//hold the ack
localparam register_byte = 5'b00111;	//transmit register address
localparam regbit_hold = 5'b01000;		//prepare next bit
localparam ack_two = 5'b01001;			//wait for acknowledge signal from device 
localparam ack_two_hold = 5'b01010;		//hold ack
localparam data_byte = 5'b01011;			//transmit data
localparam databit_hold = 5'b01100;		//prepare next bit
localparam ack_three = 5'b01101;			//wait for acknowledge signal from device
localparam ack_three_hold = 5'b01110;	//hold ack
localparam stop = 5'b01111;				//1st half stop state
localparam stop_hold = 5'b10000;			//2nd half stop state
localparam error = 5'b10001;				//slave does not ack
localparam error_hold = 5'b10010;		//end the transmission

//input definition
input RESET;
input CLK_200KHZ;
input START;
input [6:0] DEV_ADDR;
input [7:0] REG_ADDR;
input [7:0] DATA;
input I2C_SDA_ACK;
input STOP;
	
//output declaration
output wire READY;
output wire I2C_SDA_OUT;
output wire I2C_SCL;
output wire END;
output wire I2C_SDA_EN;
output wire ERROR_LED;
//internal variables declaration
//variables to strore input and output value
reg [7:0] dev_addr_write;
reg [7:0] reg_addr;
reg [7:0] data;
reg i2c_sda;
reg i2c_scl;

//internal variables
reg [4:0] state;			
reg [3:0] count = 3'b0; 

//assignment
assign I2C_SDA_OUT = i2c_sda;
assign I2C_SCL = i2c_scl;
assign I2C_SDA_EN = ((state == ack_one) || (state == ack_one_hold) || 
							(state == ack_two) || (state == ack_two_hold) || 
							(state == ack_three) || (state == ack_three_hold)) ? 1'b1 : 1'b0;
//when current state is idle and state machine has been reset, send ready signal
assign READY = ((RESET == 1'b0) && (state == idle)) ? 1'b1 : 1'b0; 
assign END = ((state == stop_hold) || (state == error_hold)) ? 1'b1 : 1'b0;
assign ERROR_LED = ((state == error) || (state == error_hold)) ? 1'b1 : 1'b0;

//generate SCL
always @(negedge CLK_200KHZ, posedge RESET)
	begin
		if (RESET == 1'b1)	//reset to pull SCL high
			begin
				i2c_scl <= 1'b1;
			end
		else  					//pull SCL high in idle or start or stop states
			begin
				if ((state == idle) || (state == start) || 
				(state == stop) || (state == stop_hold) || 
				(state == error) || (state == error_hold))
					begin
						i2c_scl <= 1'b1;
					end
				else
					begin
						i2c_scl <= ~i2c_scl;
					end
			end
	end


//build state machine for SDA
always @(posedge CLK_200KHZ, posedge RESET)
	begin
		if (RESET == 1'b1)				//reset the state machine to idle state
			begin
				state <= idle;				//reset to idle state
				dev_addr_write <= 8'b0;	//reset first byte
				reg_addr <= 8'b0;			//reset second byte
				data <= 8'b0;				//reset third byte
			end
		//SDA state machine
		else
			case (state)
				idle:							//idle state
					begin
						if (START == 1'b1)//start signal received
							begin
								state <= start;	
								dev_addr_write <= {DEV_ADDR, 1'b0}; //write command 
								reg_addr <= REG_ADDR;
								data <= DATA;
							end
						else
							begin
								state <= idle;
							end
					end
				start: 						//start state (receive start signal)
					begin
						state <= start_hold;
						count <= 3'b111;	//preload count number
					end
				start_hold:
					begin
						state <= device_byte;
					end
				device_byte:				//device byte sate (send device/slave address and r/w)
					begin
						state <= devbit_hold;
					end
				devbit_hold:
					begin
						if (count == 3'b0)
							begin
								state <= ack_one;
							end
						else
							begin
								state <= device_byte;
								count <= count - 1'b1;	//start with MSB so use count down transation
							end
					end
				ack_one:						//ack state (wait for acknowledge)
					begin
						state <= ack_one_hold;
					end
				ack_one_hold:
					begin
						if (I2C_SDA_ACK == 1'b0)
							begin
								state <= register_byte;
								count <= 3'b111;
							end
						else
							begin
								//state <= error;
								state <= register_byte;						
							end
					end
				register_byte:				//register byte state (send register address)
					begin
						state <= regbit_hold;
					end
				regbit_hold:
					begin
						if (count == 3'b0)
							begin
								state <= ack_two;
							end
						else
							begin
								state <= register_byte;
								count <= count - 1'b1;	//start with MSB so use count down transation
							end
					end
				ack_two:						//ack state (wait for acknowledge)
					begin
						state <= ack_two_hold;
					end
				ack_two_hold:
					begin
						if (I2C_SDA_ACK == 1'b0)
							begin
								state <= data_byte;
								count <= 3'b111;
							end
						else
							begin
								//state <= error;
								state <= data_byte;
							end
					end
				data_byte:					//data byte state (send data/value)
					begin
						state <= databit_hold;
					end
				databit_hold:
					begin
						if (count == 3'b0)
							begin
								state <= ack_three;
							end
						else
							begin
								state <= data_byte;
								count <= count - 1'b1;	
							end
					end
				ack_three:					//ack state (wait for acknowledge)
					begin
						state <= ack_three_hold;
					end
				ack_three_hold:
					begin
						if (I2C_SDA_ACK == 1'b0)
							begin
								state <= stop;
							end
						else
							begin
								//state <= error;
								state <= stop;
							end
					end
				stop:							//stop state (receive stop signal)
					begin
						state <= stop_hold;
					end
				stop_hold:
					begin
						if (STOP == 1)
							begin
								state <= idle;
							end
						else
							begin
								state <= stop_hold;
							end
					end
				error:
					begin
						state <= error_hold;
					end
				error_hold:
					begin
						state <= error_hold;
					end
				default:						//default state is idle state
					begin
						state <= idle;
					end
			endcase
	end

//build state machine output logic 
always @(state, dev_addr_write, reg_addr, data, count, I2C_SDA_ACK)
	begin
		case (state)
			idle:
				begin
					i2c_sda = 1'b1;
				end
			start:
				begin
					i2c_sda = 1'b1;						//hold the sda
				end
			start_hold:
				begin
					i2c_sda = 1'b0;						//pull down sda
				end
			device_byte:
				begin
					i2c_sda = dev_addr_write[count];	//send slave/device address
				end
			devbit_hold:
				begin
					i2c_sda = dev_addr_write[count];	//send slave/device address
				end
			ack_one:
				begin
					if (I2C_SDA_ACK == 1'b0)
						begin
							i2c_sda = 1'b0;
						end
					else
						begin
							//i2c_sda = 1'b1;
							i2c_sda = 1'b0;
						end
				end
			ack_one_hold:
				begin
					if (I2C_SDA_ACK == 1'b0)
						begin
							i2c_sda = 1'b0;
						end
					else
						begin
							//i2c_sda = 1'b1;
							i2c_sda = 1'b0;
						end
				end
			register_byte:
				begin
					i2c_sda = reg_addr[count];			//send register address
				end
			regbit_hold:
				begin
					i2c_sda = reg_addr[count];			//hold register address				
				end
			ack_two:
				begin
					if (I2C_SDA_ACK == 1'b0)
						begin
							i2c_sda = 1'b0;
						end
					else
						begin
							//i2c_sda = 1'b1;
							i2c_sda = 1'b0;
						end				//receive ack
				end
			ack_two_hold:
				begin
					if (I2C_SDA_ACK == 1'b0)
						begin
							i2c_sda = 1'b0;
						end
					else
						begin
							//i2c_sda = 1'b1;
							i2c_sda = 1'b0;
						end
				end
			data_byte:
				begin
					i2c_sda = data[count];				//send data
				end
			databit_hold:
				begin
					i2c_sda = data[count];				//send data
				end
			ack_three:
				begin
					if (I2C_SDA_ACK == 1'b0)
						begin
							i2c_sda = 1'b0;
						end
					else
						begin
							//i2c_sda = 1'b1;
							i2c_sda = 1'b0;
						end
				end
			ack_three_hold:
				begin
					if (I2C_SDA_ACK == 1'b0)
						begin
							i2c_sda = 1'b0;
						end
					else
						begin
							//i2c_sda = 1'b1;
							i2c_sda = 1'b0;
						end
				end
			stop:
				begin
					i2c_sda = 1'b0;						//keep sda to 0 until state changes
				end
			stop_hold:
				begin
					i2c_sda = 1'b1;
				end
			error:
				begin
					i2c_sda = 1'b0;						
				end
			error_hold:
				begin
					i2c_sda = 1'b1;
				end
			default:
				begin
					i2c_sda = 1'b1;
				end
		endcase
	end



endmodule 