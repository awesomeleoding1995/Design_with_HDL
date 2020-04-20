//HDMI controller module/submodule 						  //
//Authors		  : Li Ding	& Zhe Bai					  //
//Last updated: 31/05/2019									  //
//Description : this module tries to transmitt image //
//					 data at 25.175MHz 						  //

module vga_hdmi
(
	//input
	IMAGE_DATA,		//24-bit input data
	REF_CLK25,		//25.175MHz reference clock
	REF_CLK50,		//50MHz reference clock
	RESET_HDMI,		//reset for HDMI
	I2C_BUSY,		//check I2C configuration before sending data
	
	//output
	H_SYNC,			//horizontal sync
	V_SYNC,			//vertical sync
	DATA_ENABLE,	//data enable (DE)
	PIXEL_DATA,		//24-bit input data
	HDMI_CLK			//vga clock
);

//parameters
parameter datawidth = 24;
//declare states (h_state machine)
localparam hdisplay_state = 3'b000;
localparam hfrontp_state = 3'b001;
localparam hsyncp_state = 3'b010;
localparam hbackp_state = 3'b011;
//declare states (v_state machine)
localparam vdisplay_state = 3'b100;
localparam vfrontp_state = 3'b101;
localparam vsyncp_state = 3'b110;
localparam vbackp_state = 3'b111;


//input declaration
input [datawidth -1:0] IMAGE_DATA;
input REF_CLK25;
input REF_CLK50;
input RESET_HDMI;
input I2C_BUSY;

//output declaration
output H_SYNC;
output V_SYNC;
output DATA_ENABLE;
output [datawidth -1:0] PIXEL_DATA;
output HDMI_CLK;

//internal variables
reg [2:0] h_state;
reg [2:0] v_state;
reg [9:0] h_pixelcounter;		//maximum number = 640+16+96+48 = 800
reg [9:0] v_pixelcounter;		//maximum number = 480+10+2+33 = 525

wire busy = I2C_BUSY;
//assignment
assign H_SYNC = (h_state == hsyncp_state) ? 1'b0 : 1'b1;
assign V_SYNC = (v_state == vsyncp_state) ? 1'b0 : 1'b1;
assign DATA_ENABLE = ((h_state == hdisplay_state) && (v_state == vdisplay_state) && (busy == 0)) ? 1'b1 : 1'b0;
assign PIXEL_DATA = ((h_state == hdisplay_state) && (v_state == vdisplay_state) && (busy == 0)) ? IMAGE_DATA : 24'b0;

//vga clock output block
systemclock ref_clk25MHz(

	.CLOCK50(REF_CLK50),		//50MHz reference clock
	.PLLRESET(1'b0),			//reset pin for PLL
	.CLOCK25(HDMI_CLK)		//output 25MHz clock
);

//creat horziontal state machine
always @(posedge REF_CLK25, posedge RESET_HDMI)
	begin
		if (RESET_HDMI == 1'b1)
			begin
				h_pixelcounter <= 10'b0;
				h_state <= hdisplay_state;
			end
		else
			begin
				case (h_state)
					hdisplay_state:
						begin
							if (busy == 1'b1)
								begin
									h_state <= hdisplay_state;
									h_pixelcounter <= 10'b0;
								end
							else
								begin
									h_pixelcounter <= h_pixelcounter + 1'b1;
									if (h_pixelcounter == 10'd639)
										begin
											h_state <= hfrontp_state;
										end
									else
										begin
											h_state <= hdisplay_state;
										end
								end
						end
					hfrontp_state:
						begin
							h_pixelcounter <= h_pixelcounter + 1'b1;
							if (h_pixelcounter == 10'd655)
								begin
									h_state <= hsyncp_state;
								end
							else
								begin
									h_state <= hfrontp_state;
								end
						end
					hsyncp_state:
						begin
							h_pixelcounter <= h_pixelcounter + 1'b1;
							if (h_pixelcounter == 10'd751)
								begin
									h_state <= hbackp_state;
								end
							else
								begin
									h_state <= hsyncp_state;
								end
						end
					hbackp_state:
						begin
							if (h_pixelcounter == 10'd799)
								begin
									h_state <= hdisplay_state;
									h_pixelcounter <= 10'b0;
								end
							else
								begin
									h_state <= hbackp_state;
									h_pixelcounter <= h_pixelcounter + 1'b1;
								end
						end
					default:
						begin
							h_state <= hdisplay_state;
							h_pixelcounter <= 10'b0;
						end
				endcase
			end
	end
	
//create vertical state machine
always @(posedge REF_CLK25, posedge RESET_HDMI)
	begin
		if (RESET_HDMI == 1'b1)
			begin
				v_pixelcounter <= 10'b0;
				v_state <= vdisplay_state;
			end
		else
			begin
				case (v_state)
					vdisplay_state:
						begin
							if (busy == 1'b1)
								begin
									v_state <= vdisplay_state;
									v_pixelcounter <= 10'b0;
								end
							else if ((v_pixelcounter == 10'd479) && (h_pixelcounter == 10'd799))
								begin
									v_state <= vfrontp_state;
									v_pixelcounter <= v_pixelcounter + 1'b1;
								end
							else
								begin
									v_state <= vdisplay_state;
									if (h_pixelcounter == 10'd799)		//may have problem?
										begin
											v_pixelcounter <= v_pixelcounter + 1'b1;
										end
									else
										begin
											v_pixelcounter <= v_pixelcounter;
										end
								end
						end
					vfrontp_state:
						begin
							if ((v_pixelcounter == 10'd489) && (h_pixelcounter == 10'd799))
								begin
									v_state <= vsyncp_state;
									v_pixelcounter <= v_pixelcounter + 1'b1;
								end
							else
								begin
									v_state <= vfrontp_state;
									if (h_pixelcounter == 799)		
										begin
											v_pixelcounter <= v_pixelcounter + 1'b1;
										end
									else
										begin
											v_pixelcounter <= v_pixelcounter;
										end
								end
						end
					vsyncp_state:
						begin
							if ((v_pixelcounter == 10'd491) && (h_pixelcounter == 10'd799))
								begin
									v_state <= vbackp_state;
									v_pixelcounter <= v_pixelcounter + 1'b1;
								end
							else
								begin
									v_state <= vsyncp_state;
									if (h_pixelcounter == 799)		
										begin
											v_pixelcounter <= v_pixelcounter + 1'b1;
										end
									else
										begin
											v_pixelcounter <= v_pixelcounter;
										end
								end
						end
					vbackp_state:
						begin
							if ((v_pixelcounter == 10'd524) && (h_pixelcounter == 10'd799))
								begin
									v_state <= vdisplay_state;
									v_pixelcounter <= 10'b0;
								end
							else
								begin
									v_state <= vbackp_state;
									if (h_pixelcounter == 799)		
										begin
											v_pixelcounter <= v_pixelcounter + 1'b1;
										end
									else
										begin
											v_pixelcounter <= v_pixelcounter;
										end
								end
						end
					default:
						begin
							v_state <= vdisplay_state;
							v_pixelcounter <= 10'b0;
						end
				endcase
			end
	end
endmodule 