//PLL system clock module/submodule 					  //
//Authors		  : Zhe Bai									  //
//Last updated: 3/06/2019									  //
//Description : this module divide the clock rate 	  //
//					 from 50MHz to 25.175MHz 				  //

module systemclock(

	input CLOCK50,		//50MHz reference clock
	input PLLRESET,	//reset pin for PLL
	output CLOCK25		//output 25MHz clock
	
);

pll25m generate25m(

	.refclk (CLOCK50),   //  refclk.clk
	.rst (PLLRESET),     //   reset.reset
	.outclk_0 (CLOCK25)  // outclk0.clk
	

);
endmodule 