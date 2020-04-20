//HDMI test module/submodule 								  //
//Author		  : Li Ding	& Zhe Bai						  //
//Last updated: 30/05/2019									  //
//Description : this module tries to build a module  //
//					 to test the function of HDMI, this   //
//					 module does not include image display//
//					 funtion.									  //

module hdmi
(
  // inputs
  CLOCK25, 		//25MHz clock
  CLOCK50, 		//50MHz clock
  RESET,			//reset
  SWITCH_R, 	//red element input
  SWITCH_G, 	//green element input
  SWITCH_B,		//blue element input

  //outputs
  HSYNC, 		//horizontal sync
  VSYNC,			//vertical sync
  EN_DATA,		//data enable
  CLOCKVGA,		//vga clock
  RGB				//pixel data
);

//parameter

// inputs
input CLOCK25, CLOCK50, RESET;
input SWITCH_R, SWITCH_G, SWITCH_B;

//outputs
output reg HSYNC, VSYNC;
output reg EN_DATA;
output reg CLOCKVGA;
output [23:0] RGB;

//internal variables
reg [9:0]PIXEL_H, PIXEL_V;		//H and V counters

wire reset = RESET;

initial begin
  HSYNC      = 1;
  VSYNC      = 1;
  PIXEL_H     = 0;
  PIXEL_V     = 0;
  EN_DATA = 0;
  CLOCKVGA   = 0;
end

//display logic (counters logic)
always @(posedge CLOCK25 or posedge reset) begin
  if(reset) begin
    HSYNC  <= 1;
    VSYNC  <= 1;
    PIXEL_H <= 0;
    PIXEL_V <= 0;
  end
  else begin
    // Display Horizontal
    if(PIXEL_H==0 && PIXEL_V!=524) begin	
      PIXEL_H<=PIXEL_H+1'b1;
      PIXEL_V<=PIXEL_V+1'b1;
    end
    else if(PIXEL_H==0 && PIXEL_V==524) begin	// reset vertical pixel when it reaches 525
      PIXEL_H <= PIXEL_H + 1'b1;
      PIXEL_V <= 0; // 525th pixel
    end
    else if(PIXEL_H<=640) 
		PIXEL_H <= PIXEL_H + 1'b1;
    // Front Porch Counting
    else if(PIXEL_H<=656) 
		PIXEL_H <= PIXEL_H + 1'b1;
    // Sync Pulse
    else if(PIXEL_H<=752) begin
      PIXEL_H <= PIXEL_H + 1'b1;
      HSYNC  <= 0;
    end
    // Back Porch Counting
    else if(PIXEL_H<799) begin
      PIXEL_H <= PIXEL_H+1'b1;
      HSYNC  <= 1;
    end
    else PIXEL_H<=0; // pixel 800

    // Sync Pulse
    if(PIXEL_V == 491 || PIXEL_V == 492)
      VSYNC <= 0;
    else
      VSYNC <= 1;
  end
end

// EN_DATA signal
always @(posedge CLOCK25 or posedge reset) begin
  if(reset) EN_DATA<= 0;

  else begin
    if(PIXEL_H >= 0 && PIXEL_H <640 && PIXEL_V >= 0 && PIXEL_V < 480)	//if the scaning range is within the active pixel range, enable scaning; if not, disable.
      EN_DATA <= 1;
    else
      EN_DATA <= 0;
  end
end

// VGA pixeClock signal
// Clocks should not handle direct outputs, a trick should be used
initial CLOCKVGA = 0;

always @(posedge CLOCK50 or posedge reset) begin
  if(reset) CLOCKVGA <= 0;
  else      CLOCKVGA <= ~CLOCKVGA;
end


// ??change gere for futuer pictures

assign RGB[23:16] = (SWITCH_R)? 8'd255 : 8'd0;
assign RGB [15:8] = (SWITCH_G)? 8'd255 : 8'd0;
assign RGB  [7:0] = (SWITCH_B)? 8'd255 : 8'd0;

endmodule 