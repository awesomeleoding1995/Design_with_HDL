#verify the function of I2C transmitter 
proc runSim {} {
    #Restart the waveform generator
    restart -force -nowave
    #Add waveform 
    #add wave SDA_CLK
    #add wave SCL_CLK
    add wave CLK_200KHZ
    add wave RESET
    add wave START
    add wave STOP
    add wave READY
    add wave END
    add wave DEV_ADDR
    add wave REG_ADDR
    add wave DATA
    add wave dev_addr_write
    add wave reg_addr
    add wave data 
    add wave I2C_SDA_ACK
    add wave i2c_sda 
    add wave I2C_SDA_OUT 
    add wave I2C_SCL
    add wave I2C_SDA_EN
    add wave state
    add wave count

    property wave -radix hex *

    #set initial value
    force -freeze RESET 0
    force -freeze START 0
    force -freeze STOP 0
    force -freeze I2C_SDA_ACK 1
    force -deposit DEV_ADDR 7'b1011001 
    force -deposit REG_ADDR 8'haf
    force -deposit DATA 8'h16
    #set reference clcok period = 100ps
    force -deposit CLK_200KHZ 1 0, 0 {2500ns} -r 5000ns
    run 5000ns
    #press RESET to start the state machine
    force -freeze RESET 1
    run 5000ns
    force -freeze RESET 0
    run 5000ns
    force -freeze START 1
    run 5000ns
    #enter start signal
    force -freeze START 0
    run 90000ns
    #enter the ack signal 1
    force -freeze I2C_SDA_ACK 0
    run 10000ns
    force -freeze I2C_SDA_ACK 1
    run 80000ns
    #enter ack signal 2
    force -freeze I2C_SDA_ACK 0
    run 10000ns
    force -freeze I2C_SDA_ACK 1
    run 80000ns
    #enter ack signal 3
    force -freeze I2C_SDA_ACK 0
    run 10000ns
    force -freeze I2C_SDA_ACK 1
    run 5000ns
    force -freeze STOP 1
    run 5000ns
    force -freeze STOP 0
    run 10000ns
    force -freeze RESET 1
    run 5000ns
    force -freeze RESET 0
    force -freeze START 1
    run 5000ns
    #enter start signal
    force -freeze START 0
    run 5000ns
   
}