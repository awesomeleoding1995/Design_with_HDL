#verify the function of HDMI 
#check data change 
#check state 
proc runSim {} {
    restart -froce -nowave
    #add waveform
    add wave *

    property wave -radix hex *

    force -deposit REF_CLK25 1 0, 0 {20ns} -r 40ns
    force -deposit REF_CLK50 1 0, 0 {10ns} -r 20ns
    force -freeze IMAGE_DATA 16#ff0000
    force -freeze RESET_HDMI 0
    force -freeze I2C_BUSY 1
    run 40ns

    force -freeze RESET_HDMI 1
    run 40ns
    force -freeze RESET_HDMI 0
    run 200ns
    force -freeze I2C_BUSY 0
    for {set i 0} {$i < 525} {incr i} {
        run 32000ns
    }
    run 32000ns
    #repeat the display 
    #run 43000ns


}