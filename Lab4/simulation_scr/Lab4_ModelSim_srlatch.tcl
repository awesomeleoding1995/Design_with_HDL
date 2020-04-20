#sr latch simulation
proc runSim {} {
    #Restart the waveform generator
    restart -force -nowave

    #simulate sr latch
    #Add waveform s, r, sr_q
    add wave s
    add wave r
    add wave sr_q

    property wave -radix hex *

    #set all inputs to 1
    force -freeze s 1
    force -freeze r 1
    run 200

    #set counter i for a 'for' loop
    set i 1 
    for {set i 0} {$i < 8} {incr i} {
        force -freeze s 16#$i
        force -freeze r 16#[expr $i + 1]
        run 200
    }

    #set all inputs to 0
    force -freeze s 0
    force -freeze r 0
    run 200    

    #Display the waveform output
    view wave 

} 