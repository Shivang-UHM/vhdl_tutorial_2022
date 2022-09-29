# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw_system/_ide/scripts/systemdebugger_hmb_cpp_sw_system_standalone.tcl
# 
# 
# Usage with xsct:
# In an external shell use the below command and launch symbol server.
# symbol_server -S -s tcp::1534
# To debug using xsct, launch xsct and run below command
# source /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw_system/_ide/scripts/systemdebugger_hmb_cpp_sw_system_standalone.tcl
# 
connect -path [list tcp::1534 tcp:192.168.153.115:3121]
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent JTAG-HS1 210205329388A" && level==0 && jtag_device_ctx=="jsn-JTAG-HS1-210205329388A-23727093-0"}
fpga -file /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/_ide/bitstream/target_C_top.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_Zynq/export/hmb_Zynq/hw/target_C_top.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/Debug/hmb_cpp_sw.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
