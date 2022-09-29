# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_Zynq/platform.tcl
# 
# OR launch xsct and run below command.
# source /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_Zynq/platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {hmb_Zynq}\
-hw {/home/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -fsbl-target {psu_cortexa53_0} -out {/home1/shivang/github/HMB_CalRDout/hmb_cpp_source}

platform write
platform generate -domains 
platform active {hmb_Zynq}
bsp reload
bsp setlib -name xilrsa -ver 1.6
bsp setlib -name xilffs -ver 4.4
bsp setlib -name lwip211 -ver 1.3
bsp write
bsp reload
catch {bsp regenerate}
domain active {zynq_fsbl}
bsp reload
bsp setlib -name lwip211 -ver 1.3
bsp write
bsp reload
catch {bsp regenerate}
platform generate
platform active {hmb_Zynq}
platform config -updatehw {/home/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
bsp reload
bsp reload
domain active {standalone_domain}
bsp reload
platform generate -domains 
bsp reload
domain active {zynq_fsbl}
bsp reload
bsp config lwip_stats "true"
bsp config udp_debug "true"
bsp config netif_debug "true"
bsp config lwip_debug "true"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains zynq_fsbl 
bsp config phy_link_speed "CONFIG_LINKSPEED_AUTODETECT"
bsp config phy_link_speed "CONFIG_LINKSPEED100"
bsp write
bsp reload
catch {bsp regenerate}
domain active {standalone_domain}
bsp config phy_link_speed "CONFIG_LINKSPEED100"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_domain,zynq_fsbl 
bsp reload
domain active {zynq_fsbl}
bsp reload
bsp reload
catch {bsp regenerate}
bsp config phy_link_speed "CONFIG_LINKSPEED_AUTODETECT"
bsp config lwip_debug "false"
bsp config netif_debug "false"
bsp write
bsp reload
catch {bsp regenerate}
domain active {standalone_domain}
bsp config phy_link_speed "CONFIG_LINKSPEED_AUTODETECT"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_domain,zynq_fsbl 
domain active {zynq_fsbl}
bsp reload
bsp reload
bsp config phy_link_speed "CONFIG_LINKSPEED100"
bsp write
bsp reload
catch {bsp regenerate}
domain active {standalone_domain}
bsp config phy_link_speed "CONFIG_LINKSPEED100"
bsp write
bsp reload
catch {bsp regenerate}
domain active {zynq_fsbl}
bsp reload
platform generate -domains standalone_domain,zynq_fsbl 
bsp reload
bsp config phy_link_speed "CONFIG_LINKSPEED_AUTODETECT"
bsp write
bsp reload
catch {bsp regenerate}
domain active {standalone_domain}
bsp reload
bsp config phy_link_speed "CONFIG_LINKSPEED_AUTODETECT"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_domain,zynq_fsbl 
domain active {zynq_fsbl}
bsp config phy_link_speed "CONFIG_LINKSPEED1000"
bsp write
bsp reload
catch {bsp regenerate}
domain active {standalone_domain}
bsp config phy_link_speed "CONFIG_LINKSPEED1000"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_domain,zynq_fsbl 
domain active {zynq_fsbl}
bsp reload
platform config -updatehw {/home/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
bsp reload
bsp config phy_link_speed "CONFIG_LINKSPEED100"
bsp write
bsp reload
catch {bsp regenerate}
platform config -updatehw {/home/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains zynq_fsbl 
bsp reload
bsp config phy_link_speed "CONFIG_LINKSPEED100"
bsp write
domain active {standalone_domain}
bsp reload
bsp config phy_link_speed "CONFIG_LINKSPEED100"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_domain 
platform config -updatehw {/home/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform generate
platform generate -domains standalone_domain 
platform generate -domains standalone_domain 
platform active {hmb_Zynq}
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains standalone_domain 
domain active {zynq_fsbl}
bsp reload
platform generate -domains 
platform generate -domains standalone_domain 
platform clean
platform generate
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
bsp reload
bsp config phy_link_speed "CONFIG_LINKSPEED_AUTODETECT"
bsp write
bsp reload
catch {bsp regenerate}
domain active {standalone_domain}
bsp reload
bsp config phy_link_speed "CONFIG_LINKSPEED_AUTODETECT"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_domain,zynq_fsbl 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top_31_aug.xsa}
domain active {zynq_fsbl}
bsp reload
domain active {standalone_domain}
bsp reload
domain active {zynq_fsbl}
bsp reload
platform clean
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform clean
platform generate
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top_31_aug.xsa}
platform generate -domains 
platform active {hmb_Zynq}
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform active {hmb_Zynq}
bsp reload
domain active {standalone_domain}
bsp reload
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top_sep28.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top.xsa}
platform generate -domains 
platform config -updatehw {/home1/shivang/github/HMB_CalRDout/HMB_Cal/target_C_top_sep28.xsa}
platform generate -domains 
