#verify the function of clock divider
proc runSim {} {
    #restart the waveform generator
    restart -force -nowave
    #add waveform
    add wave *

    property wave -radix hex *

    force -deposit CLK_IN 1 0, 0 {10ns} -r 20ns
    force -freeze RESET_CLK 0
    run 20ns
    force -freeze RESET_CLK 1
    run 20ns
    force -freeze RESET_CLK 0
    run 40000ns


}