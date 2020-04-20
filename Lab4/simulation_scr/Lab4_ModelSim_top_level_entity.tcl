#verify the top level entity
#verify the function of home alarm system
proc runSim {} {
    #Restart the waveform generator
    restart -force -nowave

    #simulate counter
    #Add waveform 
    add wave *
    
    property wave -radix hex *

    #set initial value
    force -freeze key_0 1
    force -freeze key_1 1
    force -deposit SW 4'b0011
    #set reference clcok period = 100ps
    force -deposit clk_50 1 0, 0 {50ps} -r 100
    run 450
    #press key_0 to activate alarm system
    force -freeze key_0 0
    force -freeze key_1 1
    run 200
    #release key_0
    force -freeze key_0 1
    force -freeze key_1 1
    run 10000
    #press key_0 to disable alarm system
    force -freeze key_0 0
    force -freeze key_1 1
    run 400
    #release key_0
    force -freeze key_0 1
    force -freeze key_1 1
    run 1000
    #press key_1 to activate 'panic' state
    force -freeze key_0 1
    force -freeze key_1 0
    run 400
    #release key_1
    force -freeze key_0 1
    force -freeze key_1 1
    run 10000   
    #press key_0 to disable alarm system
    force -freeze key_0 0
    force -freeze key_1 1
    run 200
    #release key_0
    force -freeze key_0 1
    force -freeze key_1 1
    run 5000

 
}
