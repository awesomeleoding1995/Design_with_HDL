#verify the function of I2C controller
#mainly verify the function of (inout) I2C_SDA
proc runSim {} {
    #restart the waveform generator
    restart -froce -nowave
    #add waveform
    add wave *
    #add wave RESET_CTRL
    #add wave REF_CLK
    #add wave CONFIG_DATA
    #add wave START_BIT
    #add wave STOP_BIT
    #add wave READY
    #add wave END
    #add wave I2C_SDA
    #add wave I2C_SCL
    
    #set radix
    property wave -radix hex *

    force -deposit CONFIG_DATA 24'h72af16
   force -deposit CLK_200KHZ 1 0, 0 {50ps} -r 100
    force -freeze RESET_CTRL 0
    force -freeze START_BIT 0
    force -freeze STOP_BIT 0
    run 100
    force -freeze RESET_CTRL 1
    run 100 
    force -freeze RESET_CTRL 0
    run 100
    force -freeze START_BIT 1
    run 100
    force -freeze START_BIT 0
    run 1800
    force -freeze I2C_SDA 0
    run 200
    noforce I2C_SDA
    run 1600
    force -freeze I2C_SDA 0
    run 200
    noforce I2C_SDA
    run 1600
    force -freeze I2C_SDA 0
    run 200
    noforce I2C_SDA
    run 200
    force -freeze STOP_BIT 1
    run 200
    force -freeze STOP_BIT 0
    run 1600

    
}