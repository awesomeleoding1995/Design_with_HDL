#verify the function of timer
#Q: how to set a clock in tcl?
proc runSim {} {
    #Restart the waveform generator
    restart -force -nowave

    #simulate counter
    #Add waveform 
    add wave *
    #add wave clk_in
    #add wave clk_out
    
    property wave -radix hex *

    #set a reference clock period = 100ps
    force -deposit clk_in 1 0, 0 {50ps} -r 100
    run 6400    
    
}