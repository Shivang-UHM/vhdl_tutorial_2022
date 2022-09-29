#
# This file was created by Xilinx Vitis tool.
#


#
# tools
#

RM = rm -f
RMDIR = rm -rf



#
# variables
#

SDCARD_GEN = sdcard_gen
GENERATE_BIF = ::scw::generate_bif

XPFM_PATH = /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_Zynq/export/hmb_Zynq/hmb_Zynq.xpfm
SYS_CONFIG = hmb_Zynq
DOMAINS = standalone_domain
BIF_PATH = /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw_system/Debug/system.bif

BITSTREAM_PATH = /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/_ide/bitstream/target_C_top.bit
SD_FILES = --elf /home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/Debug/hmb_cpp_sw.elf,ps7_cortexa9_0

GENERATE_BIF_XSCT_CMD = ${GENERATE_BIF} -xpfm ${XPFM_PATH} -domains ${DOMAINS} -bifpath ${BIF_PATH}

#
# primary build targets
#

all: package

package:
	-@echo Generating bif file for the system project
	-@echo Executing command \'${GENERATE_BIF_XSCT_CMD}\' on XSCT
	-@echo "connect -u TCP:localhost:38519; tcf send_command $$::xsdb::curchan xsdb eval s es [list \"${GENERATE_BIF_XSCT_CMD}\"]" | xsct
	${SDCARD_GEN} --xpfm ${XPFM_PATH} --sys_config ${SYS_CONFIG} --bif ${BIF_PATH} --bitstream ${BITSTREAM_PATH} ${SD_FILES}

clean:
	$(RMDIR) ./_sds
	${RMDIR} package
	${RM} system.bif

.PHONY: all package clean


