Practical time: 27th March – 3rd April 2019 

Tutor’s name: Chris Harrison 

Author: Li Ding

# Introduction

In this lab, the aim is to construct a hierarchical design which is consisted of SR Latch and Dtype Flip Flop and use LEDs to sequentially display individual student numbers in binary. Therefore, the whole design includes following steps.

• Design a SR Latch connecting to tactile switch in order to capture input clock signal

• Design single bit D-type Flip Flop and use it as submodule to create registers 

• Connect all sub-modules and LEDs together in Top Level Entity

To realize the entire design on board, a functional block diagram is necessary to categorise each sub-module, which could help simplify the design procedure.
<img width="510" alt="functional_block_diagram" src="https://user-images.githubusercontent.com/15827364/79707241-1cd1bc00-82ff-11ea-9803-bb25e6d464b2.PNG">

As the functional block diagram above shows, the main components of this lab are SR Latch and 4 bits registers excluding inputs and outputs. Hence, the whole lab can be divided into two parts and develop them separately.
