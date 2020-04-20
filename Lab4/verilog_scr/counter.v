//Create counter to reduce clock rate
//Author: Li Ding
//Last updated: 23/04/2019

//create a counter sub-module
//use to develop five sec and ten sec latency
module counter 
(
	input clk_in,
	input enable_count,
	
	output count_out
);

//declare a counterwidth
parameter counterwidth = 4;
parameter constantNum = 5;
//declare a counter
reg [counterwidth - 1:0] temp_counter;
reg c_out = 0;
always @(posedge clk_in)
	begin
		if(enable_count == 1)	//enable countering
			begin
				if(temp_counter == (constantNum - 1))
					begin
						c_out = 1;
						temp_counter = 0;
					end
				else
					begin
						c_out = 0;
						temp_counter = temp_counter + 1'b1;   
					end
			end
		else 
			temp_counter = 0; 	//reset to 0
	end

assign count_out = c_out;		//count complete

endmodule 



//Design a 1Hz clock
//using a 50MHz clock 
//clk_out need to flip evey 25M rise edge clock_50Mhz
//the bandwidth of vector should be 25
module counter_timer
(
	input clk_in,
	
	output clk_out
);

//set the bandwidth with parameter
parameter bandwidth = 4;					
//set constantNum
parameter constantNum = 16;

//variable vector
reg [bandwidth - 1:0] temp_counter = 0;
reg temp_clk = 0;
//try to generate 1Hz clk
always @(posedge clk_in)
	begin
		if(temp_counter == constantNum-1)
			begin
				temp_counter = 0;
				temp_clk = !temp_clk;
			end
		else
			begin
				temp_counter = temp_counter + 1'b1;
			end
	end
assign clk_out = temp_clk;
	
endmodule
