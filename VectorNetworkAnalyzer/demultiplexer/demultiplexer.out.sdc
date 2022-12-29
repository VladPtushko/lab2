## Generated SDC file "demultiplexer.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.0.0 Build 614 04/24/2018 SJ Standard Edition"

## DATE    "Tue Dec 20 16:29:19 2022"

##
## DEVICE  "10CL006YE144A7G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {Clk_DataFlow} -period 12.500 -waveform { 0.000 6.2500 } [get_ports {Clk_DataFlow}]
create_clock -name {Clk_ADC} -period 25.000 -waveform { 0.000 12.500 } [get_ports {Clk_ADC}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {Clk_DataFlow}] -rise_to [get_clocks {Clk_DataFlow}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {Clk_DataFlow}] -fall_to [get_clocks {Clk_DataFlow}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {Clk_DataFlow}] -rise_to [get_clocks {Clk_DataFlow}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {Clk_DataFlow}] -fall_to [get_clocks {Clk_DataFlow}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {Clk_ADC}] -rise_to [get_clocks {Clk_DataFlow}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {Clk_ADC}] -fall_to [get_clocks {Clk_DataFlow}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {Clk_ADC}] -rise_to [get_clocks {Clk_DataFlow}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {Clk_ADC}] -fall_to [get_clocks {Clk_DataFlow}]  0.030  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -end -from [get_keepers {demultiplexer:demultiplexer_inst|ConversionStarted_r}] -to [get_keepers {demultiplexer:demultiplexer_inst|Q_r[4]}] 2


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

