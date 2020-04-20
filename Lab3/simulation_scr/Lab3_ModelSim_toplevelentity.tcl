proc runSim {} {
    #Restart the waveform generator
    restart -force -nowave

    #simulate top level entity
    #Add waveform preset, tact_sw1, tact_sw0, tle_q
    add wave preset
    add wave tact_sw0
    add wave tact_sw1
    add wave tle_q

    property wave -radix hex *

    #set all inputs
    force -freeze tact_sw0 1
    force -freeze tact_sw1 1
    force -freeze preset 1
    run 50
    force -freeze preset 0
    run 50
    
    #start display student number
    set i 1 
    for {set i 0} {$i < 20} {incr i} {
        force -freeze tact_sw0 16#$i
        force -freeze tact_sw1 16#[expr $i + 1]
        run 50
    }    
    #reset in the half way
    force -freeze preset 1
    run 10
    force -freeze preset 0
    set i 1 
    for {set i 0} {$i < 20} {incr i} {
        force -freeze tact_sw0 16#$i
        force -freeze tact_sw1 16#[expr $i + 1]
        run 50
    }       
    #Display the waveform output
    view wave 

} 