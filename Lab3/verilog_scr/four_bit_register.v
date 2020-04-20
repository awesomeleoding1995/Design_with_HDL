//build four bit register sub-module
//Author: Li Ding
//Last updated: 4/4/2019
/*
//build a single bit D-type flipflop 
module singlebit_Dflipflop
(
	input d, clk,		//define input d, clk
	output d_q//, d_qn	//define output d_q, d_qn
);


reg D_Q;
//reg D_QN;
assign d_q = D_Q;  
//assign d_qn = D_QN;

always @(posedge clk)	//define posedege clk as signal
	begin
		D_Q <= d;			//assign data to output q
//		D_QN <= !d;			//qn = !q
	end

endmodule
*/


//create four bit register
module four_bit_register
(
	fb_d, fb_clk, fb_preset, fb_q
);

//use parameters to create register
parameter bitwidth = 4;			//define the bitwidth which improve the flexibility to expand it to 8bit or more bits
parameter stu_num = 4'b0000;	//initialise student number 

//define input and output
input [bitwidth-1:0] fb_d; 			//define data input which consists of 4 bit binary numbers
input fb_clk, fb_preset;				//define clock and preset button
output [bitwidth-1:0] fb_q;			//define data output

integer i = 0;						//set a integer for 'for' loop

reg [bitwidth-1:0] FB_Q;

//use single bit D-type flipflop to transmit data separately 
always @(posedge fb_clk, posedge fb_preset)
	begin
		if (fb_preset == 1'b1)
			FB_Q <= stu_num;
		else
		// 'for' loop to create 4 bit register
			begin
				for (i = 0; i < bitwidth; i = i + 1)
					begin
						FB_Q[i] <= fb_d[i];		//transfer single bit number
					end
			end
	end

assign fb_q = FB_Q;	

endmodule


 