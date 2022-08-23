
#include "../include/hmb_cal/targetc.hh"

#include "xparameters.h"
#include <stdexcept>

//#include <hmb_cal/hmb_cal_exceptions.hh>
#include "../include/hmb_cal/TARGETC_RegisterMap.hh"
//#include "hmb_cal/axis_peripheral.h"


targetc::targetc(int *reg)
{
    m_reg = reg;
    for (int i = TC_VDLYTUNE_REG; i <= LAST_REGISTER_ADDR; i++)
    {
        m_reg[i] = 0;
    }
    GetTargetCStatus(m_reg);
    GetTargetCControl(m_reg);
    // setupDACs();
    initTARGETregisters();
    printf("after INIT\r\n");

    GetTargetCStatus(m_reg);

    GetTargetCControl(m_reg);

    // Waiting on PL's clocks to be ready
    while ((m_reg[TC_STATUS_REG] & LOCKED_MASK) != LOCKED_MASK)
    {
        sleep(1);
    }
    printf("after LOCKEDmask\r\n");

    GetTargetCStatus(m_reg);

    GetTargetCControl(m_reg);

    printf("PL's clock ready\r\n");

    SetTargetCRegisters(m_reg);

    printf("sleep to set the debug core\r\n");
    GetTargetCStatus(m_reg);

    GetTargetCControl(m_reg);

    //	testPattern();
}

void targetc::get_status()
{
    GetTargetCStatus(m_reg);
}
void targetc::ControlRegisterWrite(int mask, int actionID)
{
    ::ControlRegisterWrite(mask, actionID, m_reg); // mode for selecting the interrupt, 1 for dma
    usleep(100);
}

void targetc::initTARGETregisters()
{

    ControlRegisterWrite(0, INIT);
    // software reset PL side
    ControlRegisterWrite(SWRESET_MASK, DISABLE);
    // Reset TargetC's registers
    ControlRegisterWrite(REGCLR_MASK, DISABLE);
    usleep(100000);
    ControlRegisterWrite(SWRESET_MASK, ENABLE);
    usleep(1000);
    ControlRegisterWrite(SS_TPG_MASK, ENABLE);
    usleep(1000);
}
//
//void targetc::testPattern()
//{
//    if (test_TPG(m_reg) != XST_SUCCESS)
//    {
//        printf("TestPattern Generator failed!");
//        // throw HMB_EXCEPTION("TestPattern Generator failed!");
//    }
//    printf("TestPattern Generator pass!\r\n");
//    sleep(5);
//}



void targetc::PS_disable_busy_mask() {
	ControlRegisterWrite(PSBUSY_MASK, DISABLE);

}

void targetc::PS_enable_busy_mask() {
	ControlRegisterWrite(PSBUSY_MASK, ENABLE);
}

void targetc::set_sample_mode(bool status) {
	if (status){
		ControlRegisterWrite(SMODE_MASK, ENABLE);
	}else {
		ControlRegisterWrite(SMODE_MASK, DISABLE);
	}
}

void targetc::Testpattern_mode_disable() {
	ControlRegisterWrite(SS_TPG_MASK, ENABLE);
}

void targetc::Testpattern_mode_enable() {
	ControlRegisterWrite(SS_TPG_MASK, DISABLE);
}

void targetc::set_Running_mode_to_user_mode() {
	ControlRegisterWrite(CPUMODE_MASK, 0);
}

void targetc::set_Running_mode_to_trigger_mode() {
	ControlRegisterWrite(CPUMODE_MASK, 1);
}

void targetc::reset(){
	ControlRegisterWrite(SWRESET_MASK, DISABLE);
	ControlRegisterWrite(SWRESET_MASK, ENABLE);

	ControlRegisterWrite(SMODE_MASK, ENABLE); // mode for selecting the interrupt, 1 for dma
	usleep(100);

	ControlRegisterWrite(SS_TPG_MASK, ENABLE); // 0 for test pattern mode, 1 for sample mode (normal mode)
	usleep(100);

	ControlRegisterWrite(CPUMODE_MASK, ENABLE); // mode trigger, 0 for usermode (cpu mode), 1 for trigger mode

  	ControlRegisterWrite(PSBUSY_MASK,DISABLE);


	//XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DEVICE_TO_DMA);
}


