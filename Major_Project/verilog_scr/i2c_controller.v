//I2C controller module/submodule						  //
//Author		  : Li Ding										  //
//Last updated: 24/05/2019									  //
//Description : this module tries to package the I2C //
//					 transmitter and complete the serial  //
//					 data transmission function			  //

module i2c_controller
(
	//input
	RESET_CTRL,		//reset
	CLK_200KHZ,		//reference clock
	CONFIG_DATA,	//configure data (include slave address, register address and data)
	START_BIT,		//start bit
	STOP_BIT,		//stop bit
	
	//inout
	I2C_SDA,			//sda bus
	//output
	I2C_SCL,			//scl bus
	READY,			//ready signal
	END,				//end signal
	ERROR_LED
);

//parameter
parameter data_width = 24;

//input declaration 
input RESET_CTRL;
input CLK_200KHZ;
input [data_width - 1:0] CONFIG_DATA;
input START_BIT;
input STOP_BIT;

//inout declaration 
inout I2C_SDA;

//output declaration
output I2C_SCL;
output READY;
output END; 
output ERROR_LED;

//internal variables declaration
wire i2c_sda_out;

//internal connection
wire reset;
wire clk_200kHz;
wire i2c_sda_oe;
wire i2c_sda_ack;

//assignment
assign reset = RESET_CTRL;
assign clk_200kHz = CLK_200KHZ;
assign I2C_SDA = (i2c_sda_oe) ? 1'bz : i2c_sda_out; 
assign i2c_sda_ack = I2C_SDA;


//i2c transmitter submodule
i2c_transmitter i2c_write
(
	//input 
	.RESET(reset),							//reset button to state machine
	.CLK_200KHZ(clk_200kHz),				//clock to drive state machine
	.START(START_BIT),					//start signal to transfer data
	.DEV_ADDR(CONFIG_DATA[23:17]),	//slave/device address	
	.REG_ADDR(CONFIG_DATA[15:8]),		//register address
	.DATA(CONFIG_DATA[7:0]),			//data transferred
	.I2C_SDA_ACK(i2c_sda_ack),			//acknowledge signal 
	.STOP(STOP_BIT),						//stop signal to end the transmission
	
	//output
	.READY(READY),							//ready signal to inform master
	.I2C_SDA_OUT(i2c_sda_out),			//serial data output
	.I2C_SCL(I2C_SCL),					//serial clock output
	.END(END),								//end signal to inform master
	.I2C_SDA_EN(i2c_sda_oe),			//enable to control tri-state buffer
	.ERROR_LED(ERROR_LED)							//error led
);


endmodule 