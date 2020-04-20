//clock divider												  //
//Author		  : Li Ding										  //
//Last updated: 17/05/2019									  //
//Description : this module tries to divide 25MHz    //
//					 clock into 100kHz rate to drive I2C  //

module clock_divider
(
	//input
	RESET_CLK,
	CLK_IN,
	
	//output
	CLK_OUT
);

//parameter
parameter ref_rate = 50000000;
parameter target_rate = 200000;
parameter count_width = 8;
//input declaration
input RESET_CLK;
input CLK_IN;

//output declaration
output CLK_OUT;

//internal variables
reg [count_width - 1:0] count;
reg clk_out;

//asignment
assign CLK_OUT = clk_out;

always @(posedge CLK_IN, posedge RESET_CLK)
	begin
		if (RESET_CLK == 1'b1)
			begin
				count <= 0;
				clk_out <= 0;
			end
		else
			begin
				if (count == (((ref_rate/target_rate)/2) - 1'b1))
					begin
						clk_out <= ~clk_out;
						count <= 0;
					end
				else
					begin
						count <= count + 1'b1;
					end
			end
	end

endmodule 