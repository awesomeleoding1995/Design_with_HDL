Practical time: week 6 – week 8 

Tutor’s name: Chris Harrison 

Author: Li Ding

# Introduction

The aim of this laboratory is to establish a home alarm system using Finite State Machine (FSM) and implement the system to DE-10 Nano Development Board. The alarm system can detect movement in four zones which are represented by four slide switches and use three states and LEDs to inform user the operation of state machine. Though three states which show as ‘disarmed’, ‘armed’ and ‘triggered’ respectively are explicit from user’s perspective, inside the state machine, there are multiple states to support different conditions while running the whole system [1]. Thus, in this lab different conditions and situations of running the system should be considered and tackled by building up states. Steps to develop this system are showed as follow:

• Build up timers and counters to drive the state machine and achieve certain timing latency as required

• Design a state machine as the body of the system 

• Combine sub-modules mentioned above together and complete the display connection in Top Level Entity

# Reference
[1] “EEET2162 / 2035 – Advanced Digital Design / Design with Hardware Description Languages – FSM Design,” 2019.
