#verify the function of counter
proc runSim {} {
    #Restart the waveform generator
    restart -force -nowave

    #simulate counter
    #Add waveform 
    add wave clk_in
    add wave enable_count
    add wave count_out
    
    property wave -radix hex *

    force -freeze enable_count 0
    #set a reference clock period = 100ps 
    force -deposit clk_in 1 0, 0 {50ps} -r 100
    run 100    

    force -freeze enable_count 1
    run 700  

    force -freeze enable_count 0
    run 500 
    
   
   


    
}
