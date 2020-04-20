proc runSim {} {
    #restart waveform generator
    restart -force -nowave
    
    #simulate four bit register 
    #add waveform fb_d, fb_clk, fb_preset, fb_q
    add wave fb_d
    add wave fb_clk
    add wave fb_preset
    add wave fb_q

    property wave -radix hex *

    #set all inputs to 0
    force -freeze fb_d 0
    force -freeze fb_clk 0
    force -freeze fb_preset 0
    run 200

    #set data
    set i 1
    for {set i 0} {$i < 4} {incr i} {
        force -freeze fb_d 16#$i
        force -freeze fb_clk 16#[expr $i + 1]
        run 200    
    }
    
    #switch preset
    force -freeze fb_preset 1
    run 50
    force -freeze fb_preset 0
    run 50

    set i 1
    for {set i 4} {$i < 8} {incr i} {
        force -freeze fb_d 16#$i
        force -freeze fb_clk 16#[expr $i + 1]
        run 200    
    }   

  
}