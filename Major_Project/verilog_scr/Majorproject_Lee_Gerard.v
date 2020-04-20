//Top Level Entity 											  //
//Authors		  : Li Ding	& Zhe Bai					  //
//Last updated: 3/06/2019									  //
//Description : this module integrates all sub-module//
//					 together									  //

module Majorproject_Lee_Gerard
(
	//input 
	CLOCK_50,		//50MHz clock
	RESET,			//reset
	RESET_I2C,		//reset for i2c
	
	//inout
	SDA,				//I2C serial data bus
	
	//output
	SCL,				//I2C serial clk bus
	I2C_LED,			//error led
	H_SYNC,			//horizontal sync
	V_SYNC,			//vertical sync
	DE,				//data enable (DE)
	DATA,				//24-bit input data
	CLK				//vga clock
);

//parameters
parameter datawidth = 24;
parameter purecolour = 24'hff0000;

//input declaration
input CLOCK_50;
input RESET;
input RESET_I2C;

//inout declaration
inout SDA;

//output declaration
output SCL;
output I2C_LED;
output H_SYNC;
output V_SYNC;
output DE;
output [datawidth - 1:0] DATA;
output CLK;

//internal variables
wire [datawidth -1:0] temp_colour;

wire clk_50 = CLOCK_50;
wire reset = RESET;
wire clk_25;
wire busy;

//asssignment
assign temp_colour = purecolour;


//PLL 25.175MHz module
systemclock clk_25MHz(

	.CLOCK50(clk_50),		//50MHz reference clock
	.PLLRESET(1'b0),			//reset pin for PLL
	.CLOCK25(clk_25)		//output 25MHz clock
);


//I2C config module
i2c_config i2c_submodule
(
	//input
	.RESET_I2C(RESET_I2C),		//reset i2c bus
	.RESET_CONFIG(reset),		//reset for configuration
	.REF_CLK(clk_50),				//50MHz reference clock 
	
	//inout
	.I2C_SDA(SDA),					//serial data
	
	//output
	.I2C_BUSY(busy),				//internal busy signal
	.I2C_SCL(SCL),					//serial clock
	.I2C_ERROR_LED(I2C_LED)		//error light
);

//HDMI module
vga_hdmi hdmi_submodule
(
	//input
	.IMAGE_DATA(temp_colour),	//24-bit input data
	.REF_CLK25(clk_25),			//25.175MHz reference clock
	.REF_CLK50(clk_50),			//50MHz reference clock
	.RESET_HDMI(reset),			//reset for HDMI
	.I2C_BUSY(busy),				//check I2C configuration before sending data
	
	//output
	.H_SYNC(H_SYNC),				//horizontal sync
	.V_SYNC(V_SYNC),				//vertical sync
	.DATA_ENABLE(DE),				//data enable (DE)
	.PIXEL_DATA(DATA),			//24-bit input data
	.HDMI_CLK(CLK)					//vga clock
);

endmodule 