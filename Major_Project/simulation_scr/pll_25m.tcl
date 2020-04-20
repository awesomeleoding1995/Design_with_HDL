#verify the function of PLL
#make sure the clock rate is divided to 25.175MHz

proc runSim {} {
    restart -force -nowave

    add wave *

    property wave -radix hex *

    force -deposit CLOCK50 1 0, 0 {10ns} -r 20ns
    #force -freeze PLLRESET 0
    #run 100ns

    #force -freeze PLLRESET 0
   \
    #force -freeze PLLRESET 0
    run 5000ns
}