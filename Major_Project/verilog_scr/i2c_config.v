//I2C config module/submodule 							  //
//Author		  : Li Ding										  //
//Last updated: 29/05/2019									  //
//Description : this module tries to execute the 	  //
//					 configuration data to slave via I2C  //

module i2c_config
(
	//input
	RESET_I2C,		//reset i2c bus
	RESET_CONFIG,	//reset for configuration
	REF_CLK,			//50MHz reference clock 
	
	//inout
	I2C_SDA,			//serial data
	
	//output
	I2C_BUSY,		//internal busy signal
	I2C_SCL,			//serial clock
	I2C_ERROR_LED	//error light
);

//parameter
parameter config_width = 24;
parameter reg_data_width = 16;
parameter data_totalsize = 20;		//temp size
parameter slave_addr = 8'h72;

//states declaration
localparam wait_ready = 3'b000;
localparam data_preload = 3'b001;
localparam start_config = 3'b010;
localparam stop_config = 3'b011;
localparam config_complete = 3'b100;

//input declaration
input RESET_I2C;
input RESET_CONFIG;
input REF_CLK;

//inout declaration
inout I2C_SDA;

//output declaration
output I2C_SCL;
output I2C_BUSY;
output I2C_ERROR_LED;

//internal variables declaration
reg [config_width - 1:0] config_data; 
reg [reg_data_width - 1:0] reg_data;
reg start;
reg stop;
reg [2:0] state;
reg [4:0] data_index;	//temp size

//internal connection
wire reset;
wire clk_200kHz;
wire i2c_ready;
wire i2c_end;

//assignment
assign reset = RESET_I2C;
assign I2C_BUSY = (state == config_complete) ? 1'b0 : 1'b1;

//assignment for ModelSim simulation
//assign clk_200kHz = REF_CLK;


//clock divider submodule
clock_divider #(.ref_rate(50000000), .target_rate(200000), .count_width(6)) clock_200kHz
(
	//input
	.RESET_CLK(reset),
	.CLK_IN(REF_CLK),
	
	//output
	.CLK_OUT(clk_200kHz)
);


//i2c controller
i2c_controller	i2c_control
(
	//input
	.RESET_CTRL(reset),				//reset
	.CLK_200KHZ(clk_200kHz),		//reference clock
	.CONFIG_DATA(config_data),		//configure data (include slave address, register address and data)
	.START_BIT(start),				//start bit
	.STOP_BIT(stop),					//stop bit
	//inout
	.I2C_SDA(I2C_SDA),				//sda bus
	//output
	.I2C_SCL(I2C_SCL),				//scl bus
	.READY(i2c_ready),				//ready signal
	.END(i2c_end),						//end signal
	.ERROR_LED(I2C_ERROR_LED)		//error light
);

//configuration state machine
always @(posedge clk_200kHz, posedge RESET_CONFIG)
	begin
		if (RESET_CONFIG == 1'b1)
			begin
				data_index <= 0;
				state <= wait_ready;
			end
		else
			begin
				case (state)
					wait_ready:
						begin
							if (i2c_ready == 1'b1)
								begin
									state <= data_preload;
								end
							else
								begin
									state <= wait_ready;
								end
						end
					data_preload:
						begin
							state <= start_config;
						end
					start_config:
						begin
							if (i2c_end == 1'b1)
								begin
									state <= stop_config;
								end
							else
								begin
									state <= start_config;
								end
						end
					stop_config:
						begin
							if (data_index == data_totalsize - 1'b1)
								begin
									data_index <= 0;
									state <= config_complete;
								end
							else
								begin
									data_index <= data_index + 1'b1;
									state <= wait_ready;
								end
						end
					config_complete:
						begin
							state <= config_complete;
						end
					default:
						begin
							state <= config_complete;
						end
				endcase
			end
	end 
	
//output logic of state machine
always @(state, reg_data, config_data)
	begin
		case (state)
			wait_ready:
				begin
					start = 1'b0;
					stop = 1'b0;
					config_data = 0;
				end
			data_preload:
				begin
					start = 1'b1;
					stop = 1'b0;
					config_data = {slave_addr, reg_data};
				end
			start_config:
				begin
					start = 1'b0;
					stop = 1'b0;
					config_data = config_data;
				end
			stop_config:
				begin
					start = 1'b0;
					stop = 1'b1;	//inform the i2c controller to start next 3 byte transmission
					config_data = config_data;
				end
			config_complete:
				begin
					start = 1'b0;
					stop = 1'b0;
					config_data = 0;
				end
			default:
				begin
					start = 1'b0;
					stop = 1'b0;
					config_data = 0;
				end
		endcase
	end

//configuration data
always @(*)
	begin
		case (data_index)
		
			0: reg_data <= 16'h0218;	//set N value at 6144
			1: reg_data <= 16'h1630;	//set N value at 6144
			2: reg_data <= 16'h1846;	//set N value at 6144
			3: reg_data <= 16'h9600;	//24 bit RGB 4:4:4 (separate syncs)
			4: reg_data <= 16'h9ae0;	//output format 4:4:4, 8 bit colour depth, no need to set input style
			5: reg_data <= 16'h9c30;	//disabe CSC
			6: reg_data <= 16'ha2a4;	//power down control
			7: reg_data <= 16'hba60;	//must be default for proper operation
			8: reg_data <= 16'he0d0;	//disable interupt
			9: reg_data <= 16'h9803;	//must be set to 0x03 for proper operation
			10: reg_data <= 16'h0100;	//must be set to default value
			11: reg_data <= 16'h0300;	//must be set to 0b1110000
			12: reg_data <= 16'h1510;	//must be set to 0x30 for proper operation
			13: reg_data <= 16'h4110;	//must be set to 0b01 for proper operation 
			14: reg_data <= 16'h49a8;	//must be set to 0xa4 for proper operation
			15: reg_data <= 16'h9902;	//must be set to 0xa4 for proper operation
			16: reg_data <= 16'h9d61;	//select HDMI mode
			17: reg_data <= 16'ha3a4;	//no clock delay 
			18: reg_data <= 16'haf16;	//must be set to 0xd0 for proper operation
			19: reg_data <= 16'hf900;	//must be set to 0x00 for proper operation
			
			default: reg_data <= 16'h0000;
			
		endcase
	end

	
			

endmodule 