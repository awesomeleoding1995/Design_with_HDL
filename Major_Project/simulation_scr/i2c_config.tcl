#verify the function of I2C configure file
#check data output 
#check input sequence

proc runSim {} {
    #restart the waveform generator
    restart -froce -nowave
    #add waveform
    add wave *

    property wave -radix hex *

    force -deposit REF_CLK 1 0, 0 {10ns} -r 20ns
    force -freeze RESET_I2C 0
    force -freeze RESET_CONFIG 0
    run 20ns
    #reset
    force -freeze RESET_I2C 1
    run 20ns
    force -freeze RESET_I2C 0
    run 500ns

    force -freeze RESET_CONFIG 1
    run 5000ns
    force -freeze RESET_CONFIG 0
    run 7000ns

    
    
   run 90000ns
   force -freeze I2C_SDA 0
   run 10000ns
   noforce I2C_SDA
   run 80000ns
   force -freeze I2C_SDA 0
   run 10000ns
   noforce I2C_SDA
   run 80000ns
   force -freeze I2C_SDA 0
   run 10000ns
   noforce I2C_SDA
   run 15000ns

 for {set i 0} {$i < 19  } {incr i} {
        run 100000ns
        force -freeze I2C_SDA 0
        run 10000ns
        noforce I2C_SDA
        run 80000ns
        force -freeze I2C_SDA 0
        run 10000ns
        noforce I2C_SDA
        run 80000ns
        force -freeze I2C_SDA 0 
        run 10000ns
        noforce I2C_SDA
        run 15000ns
    }
    
    run 20000ns

}