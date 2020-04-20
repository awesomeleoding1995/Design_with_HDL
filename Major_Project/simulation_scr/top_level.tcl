#verify the function of top level
#timing issues!

proc runSim {} {
    restart -force -nowave 

    add wave *

    property wave -radix hex *

   force -deposit CLOCK_50 1 0, 0 {10ns} -r 20ns
    force -freeze RESET_I2C 0
    force -freeze RESET 0
    run 20ns
    #reset
    force -freeze RESET_I2C 1
    run 20ns
    force -freeze RESET_I2C 0
    run 500ns

    force -freeze RESET 1
    run 5000ns
    force -freeze RESET 0
    run 7000ns

    
    
   run 90000ns
   force -freeze SDA 0
   run 10000ns
   noforce SDA
   run 80000ns
   force -freeze SDA 0
   run 10000ns
   noforce SDA
   run 80000ns
   force -freeze SDA 0
   run 10000ns
   noforce SDA
   run 15000ns

 for {set i 0} {$i < 19  } {incr i} {
        run 100000ns
        force -freeze SDA 0
        run 10000ns
        noforce SDA
        run 80000ns
        force -freeze SDA 0
        run 10000ns
        noforce SDA
        run 80000ns
        force -freeze SDA 0 
        run 10000ns
        noforce SDA
        run 15000ns
    }

run 200000ns
}