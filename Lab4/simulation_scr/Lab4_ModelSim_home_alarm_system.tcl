#verify the function of home alarm system
proc runSim {} {
    #Restart the waveform generator
    restart -force -nowave
    #Add waveform 
    add wave KEY_0
    add wave KEY_1
    add wave CLOCK_IN
    add wave CLOCK_1
    add wave COUNT_OUT_P2
    add wave COUNT_OUT_P1
    add wave MOVEMENT_SW
    add wave SIREN_LED
    add wave STROBE_LED
    add wave MOVEMENT_LED
    add wave MOVEMENT_LATCH
    add wave AORT_LED
    add wave D_LED
    add wave ENABLE_COUNT_P2
    add wave ENABLE_COUNT_P1
    add wave currentState
    add wave nextState
    #add wave *
    
    property wave -radix hex *

    #set initial value
    force -freeze KEY_0 1
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    #set reference clocks period = 100ps and 200ps
    force -deposit CLOCK_IN 1 0, 0 {50ps} -r 100
    force -deposit CLOCK_1 1 0, 0 {100ps} -r 200
    run 100

    #when KEY_0 is pressed
    force -freeze KEY_0 0
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    run 100
    #release KEY_0
    force -freeze KEY_0 1
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    run 100
    #receive count_out signal from 5 sec couter
    force -freeze KEY_0 1
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 1
    force -freeze MOVEMENT_SW 4'b0101
    run 100
    #enter armed state
    force -freeze KEY_0 1
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    run 400
    #receive count_out signal from 10 sec counter 
    force -freeze KEY_0 1
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 1
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    run 100
    #when KEY_0 is pressed again
    force -freeze KEY_0 0
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    run 100
    #release KEY_0
    force -freeze KEY_0 1
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    run 400
    #when KEY_1 is pressed 
    force -freeze KEY_0 1
    force -freeze KEY_1 0
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    run 100
    #release KEY_1
    force -freeze KEY_0 1
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    run 400
    #when KEY_0 is pressed again
    force -freeze KEY_0 0
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    run 100
    #release KEY_0
    force -freeze KEY_0 1
    force -freeze KEY_1 1
    force -freeze COUNT_OUT_P1 0
    force -freeze COUNT_OUT_P2 0
    force -freeze MOVEMENT_SW 4'b0101
    run 400
}