//Lab2_BinaryConvertDecimal
//Aurther: Li Ding
//Last update: 20/03/2019

module Lab2_Lee                             //the module name should be the same as top-level entity
(

  input [3:0] SW,                           //define a input (4-bits)
  output LED6,LED5,LED4,LED3,LED2,LED1,LED0 //define 7 segements individual outputs

);

reg [6:0] outputAddress; //define a reg for storing data
always @(*) //declare a always block
      begin
		

		// the following if-base is to complete the convertion from binary to decimal
			if (SW == 4'b0000) outputAddress = 7'b1111110;      // number 0
			else if (SW == 4'b0001) outputAddress = 7'b0110000; //number 1
			else if (SW == 4'b0010) outputAddress = 7'b1101101; //number 2
			else if (SW == 4'b0011) outputAddress = 7'b1111001; //number 3
			else if (SW == 4'b0100) outputAddress = 7'b0110011; //number 4
			else if (SW == 4'b0101) outputAddress = 7'b1011011; //number 5
			else if (SW == 4'b0110) outputAddress = 7'b1011111; //number 6
			else if (SW == 4'b0111) outputAddress = 7'b1110000; //number 7
			else if (SW == 4'b1000) outputAddress = 7'b1111111; //number 8
			else if (SW == 4'b1001) outputAddress = 7'b1111011; //number 9
			else outputAddress = 7'b0000000;                    //the rest of combinations show nothing
      end
assign {LED6,LED5,LED4,LED3,LED2,LED1,LED0} = outputAddress; //assign the value of reg to outputs


endmodule 