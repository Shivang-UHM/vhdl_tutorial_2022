/**
 * @file 	TARGETC_RegisterMap.c
 * @author	Jonathan Hendriks
 * @date	14th November 2018
 * @version 0.0
 */

#include "../include/hmb_cal/TARGETC_RegisterMap.hh"

#include <iostream>

/**************** Extern global variables ****************/
/*********************************************************/
/** @brief Array containing registers of AXI-lite */
// extern int* regptr;

/** **********************************************************
 * @brief 	Set the TargetC Registers to default value using AXI Lite control
 *
 * @param	-
 *
 * @return	status
 *
 * @note	-
 *
 ************************************************************* */

void SetTargetCRegisters(int *regptr)
{

    for (int i = 0; i < 64; i++)
    {
        WriteRegister(TC_VDLYTUNE_REG + i, 0, regptr);
    }
    //	*** TARGETC Register Initial Values
    WriteRegister(TC_SSTOUTFB_REG, 60, regptr); // 0x03a

    WriteRegister(TC_SSPIN_LE_REG, 51, regptr); // TEST with SSPIN
    WriteRegister(TC_SSPIN_TE_REG, 7, regptr);

    WriteRegister(TC_WR_STRB2_LE_REG, 58, regptr); // 58
    WriteRegister(TC_WR_STRB2_TE_REG, 12, regptr); // 12

    WriteRegister(TC_WR2_ADDR_LE_REG, 5, regptr);  // Adrian's numbers work from here
    WriteRegister(TC_WR2_ADDR_TE_REG, 25, regptr); // 25

    WriteRegister(TC_WR_STRB1_LE_REG, 26, regptr); // 20
    WriteRegister(TC_WR_STRB1_TE_REG, 40, regptr); // 40

    WriteRegister(TC_WR1_ADDR_LE_REG, 39, regptr); // 33
    WriteRegister(TC_WR1_ADDR_TE_REG, 53, regptr); // 53

    WriteRegister(TC_VQBUFF_REG, 1100, regptr); ///// 1100
    WriteRegister(TC_QBIAS_REG, 0, regptr);
    WriteRegister(TC_VTRIMT_REG, 2500, regptr);   ///  0x4d8
    WriteRegister(TC_VBIAS_REG, 0x4B0, regptr);   //
    WriteRegister(TC_VAPBUFF_REG, 0x3D9, regptr); // 985(10)
    // WriteRegister(TC_VADJP_REG,		0x480);	// 1152
    WriteRegister(TC_VADJP_REG, 1020, regptr);   // 1020
    WriteRegister(TC_VANBUFF_REG, 1042, regptr); // 1062

    // WriteRegister(TC_VADJN_REG,		0x8BB);	// 2235
    //	xil_printf("VADJN=0 \r\n");
    //
    WriteRegister(TC_VADJN_REG, 2690, regptr); // 2420 - 2450  2430
    WriteRegister(TC_SBBIAS_REG, 0x78E, regptr);
    WriteRegister(TC_VDISCH_REG, 0, regptr);
    // WriteRegister(TC_ISEL_REG,		2600);
    WriteRegister(TC_ISEL_REG, 2300, regptr); // 2300 good for Vped around 512

    WriteRegister(TC_DBBIAS_REG, 0x690, regptr);

    // Initial Base Value
    WriteRegister(TC_CMPBIAS2_REG, 0x2D6, regptr);  // 726
    WriteRegister(TC_PUBIAS_REG, 0xBCA, regptr);    // 3018
    WriteRegister(TC_CMPBIASIN_REG, 0x654, regptr); // 1620

    //	usleep(5000000);
    //  /*
    // To operate DLL
    xil_printf("Turning DLL ON \r\n");
    WriteRegister(TC_QBIAS_REG, 0, regptr);      // 1,300 Meeting 07/02/2019
    WriteRegister(TC_VANBUFF_REG, 1042, regptr); // 1,300 Meeting 07/02/2019, 1062  0x44C
    sleep(10);

    WriteRegister(TC_QBIAS_REG, 1500, regptr); // 1300, // 1,300 Meeting 07/02/2019 0x426// stable at 528, 08/20/2019
    WriteRegister(TC_VANBUFF_REG, 0, regptr);  // // 1,300 Meeting 07/02/2019
    //	usleep(20);

    // */
    WriteRegister(TC_MISCDIG_REG, 0, regptr);     // nRD_EN, nWR1_Enable nWR2_Enable are set to
    WriteRegister(TC_MONTIMING_REG, 128, regptr); // INIT MonTiming PASS disable

    xil_printf("TargetC's registers initialized!\r\n");
}

/****************************************************************************/
/**
 * @brief	In VERBOSE mode, print the status bit
 *
 * @param	-
 *
 * @return	-
 *
 * @note		-
 *
 ****************************************************************************/

void GetTargetCStatus(int *regptr)
{

    std::cout << ">> STATUS:\t 0x" << std::hex << regptr[TC_STATUS_REG] << std::dec << std::endl;

    // xil_printf(" :");
#ifdef VERBOSE
    if (regptr[TC_STATUS_REG] & BUSY_MASK)
        xil_printf("\t BUSY_MASK");
    if (regptr[TC_STATUS_REG] & LOCKED_MASK)
        xil_printf("\t LOCKED_MASK");
    if (regptr[TC_STATUS_REG] & STORAGE_MASK)
        xil_printf("\t STORAGE_MASK");
    if (regptr[TC_STATUS_REG] & SSVALID_MASK)
        xil_printf("\t SSVALID_MASK");

        // if(regptr[TC_STATUS_REG] & RESET_MASK)	xil_printf("\t RESET_MASK");

#endif
    xil_printf("\r\n");
}

/****************************************************************************/
/**
 * @brief	In VERBOSE mode, print the control bit
 *
 * @param	-
 *
 * @return	-
 *
 * @note		-
 *
 ****************************************************************************/
void GetTargetCControl(int *regptr)
{
	auto reg = regptr[TC_CONTROL_REG];
	std::cout << ">> CONTROL:\t 0x" << std::hex << reg << std::dec << std::endl;

//    xil_printf(">> CONTROL:\t ");
//    decToHexa(regptr[TC_CONTROL_REG]);
    // xil_printf(" :");

#ifdef VERBOSE
    if (regptr[TC_CONTROL_REG] & WRITE_MASK)
        xil_printf("\t WRITE_MASK");
    //	if(regptr[TC_CONTROL_REG] & PCLK_MASK)	xil_printf("\t PCLK_MASK");
    //	if(regptr[TC_CONTROL_REG] & SCLK_MASK)	xil_printf("\t SCLK_MASK");
    //	if(regptr[TC_CONTROL_REG] & SIN_MASK)	xil_printf("\t SIN_MASK");

    //	if(regptr[TC_CONTROL_REG] & RAMP_MASK)	xil_printf("\t RAMP_MASK");
    if (regptr[TC_CONTROL_REG] & REGCLR_MASK)
        xil_printf("\t REGCLR_MASK");
    //	if(regptr[TC_CONTROL_REG] & SS_INCR_MASK)	xil_printf("\t SS_INCR_MASK");
    if (regptr[TC_CONTROL_REG] & SS_TPG_MASK)
        xil_printf("\t SS_TPG_MASK");

    //	if(regptr[TC_CONTROL_REG] & SS_RESET_MASK)	xil_printf("\t SS_RESET_MASK");
    //	if(regptr[TC_CONTROL_REG] & RDAD_MASK)	xil_printf("\t RDAD_MASK");
    //	if(regptr[TC_CONTROL_REG] & STARTSTORAGE_MASK)	xil_printf("\t STARTSTORAGE_MASK");
    //	if(regptr[TC_CONTROL_REG] & SSACK_MASK)	xil_printf("\t SSACK_MASK");

    if (regptr[TC_CONTROL_REG] & SWRESET_MASK)
        xil_printf("\t SWRESET_MASK");
#endif
 //   xil_printf("\r\n");
}

/****************************************************************************/
/**
 * @brief	Change a bit in the control register
 *
 * @param	mask: which to change
 * @param	actionID: set with ENABLE, reset with DISABLE, initialized with INIT
 *
 * @return	-
 *
 * @note		-
 *
 ****************************************************************************/
void ControlRegisterWrite(int mask, int actionID, int *regptr)
{

    // int* regptr = XPAR_TARGETC_0_TC_AXI_BASEADDR;
    if (actionID == ENABLE)
    {
        regptr[TC_CONTROL_REG] = regptr[TC_CONTROL_REG] | mask;
    }
    else if (actionID == DISABLE)
    {
        regptr[TC_CONTROL_REG] = regptr[TC_CONTROL_REG] & (0xFFFFFFFF ^ mask);
    }
    else if (actionID == INIT)
    {
        regptr[TC_CONTROL_REG] = 0;
    }
    else
    {
        xil_printf("Error:\t%s\r\n\tNo valid argument {ENABLE/DISABLE}", __func__);
    }

    // DEBUG

#ifdef VERBOSE
    xil_printf(">> CONTROL:\t");

    if (regptr[TC_CONTROL_REG] & WRITE_MASK)
        xil_printf("\t WRITE_MASK");
    //	if(regptr[TC_CONTROL_REG] & PCLK_MASK)	xil_printf("\t PCLK_MASK");
    //	if(regptr[TC_CONTROL_REG] & SCLK_MASK)	xil_printf("\t SCLK_MASK");
    //	if(regptr[TC_CONTROL_REG] & SIN_MASK)	xil_printf("\t SIN_MASK");

    //	if(regptr[TC_CONTROL_REG] & RAMP_MASK)	xil_printf("\t RAMP_MASK");
    if (regptr[TC_CONTROL_REG] & REGCLR_MASK)
        xil_printf("\t REGCLR_MASK");
    //	if(regptr[TC_CONTROL_REG] & SS_INCR_MASK)	xil_printf("\t SS_INCR_MASK");
    if (regptr[TC_CONTROL_REG] & SS_TPG_MASK)
        xil_printf("\t SS_TPG_MASK");

    //	if(regptr[TC_CONTROL_REG] & SS_RESET_MASK)	xil_printf("\t SS_RESET_MASK");
    //	if(regptr[TC_CONTROL_REG] & RDAD_MASK)	xil_printf("\t RDAD_MASK");
    //	if(regptr[TC_CONTROL_REG] & STARTSTORAGE_MASK)	xil_printf("\t STARTSTORAGE_MASK");
    //	if(regptr[TC_CONTROL_REG] & SSACK_MASK)	xil_printf("\t SSACK_MASK");

    if (regptr[TC_CONTROL_REG] & SWRESET_MASK)
        xil_printf("\t SWRESET_MASK");
    xil_printf("\r\n");
#endif
}

/****************************************************************************/
/**
 * @brief	Change the value of a TARGET register
 *
 * @param	regID: register ID
 * @param	regData: new value to set
 *
 * @return	-
 *
 * @note		-
 *
 ****************************************************************************/
void WriteRegister(int regID, int regData, int *regptr)
{
    //	if(regID <= TC_MISCDIG_REG || regID == TC_TPG_REG){
    if (regID <= TC_FSTWINDOW_REG || regID <= TC_MISCDIG_REG || regID == TC_TPG_REG)
    {

        ControlRegisterWrite(WRITE_MASK, DISABLE, regptr);

        regptr[regID] = regData;
        regptr[TC_ADDR_REG] = regID;

        ControlRegisterWrite(WRITE_MASK, ENABLE, regptr);
        while (regptr[TC_STATUS_REG] & BUSY_MASK)
        {
            usleep(100); // sleep 100ms
        }
        ControlRegisterWrite(WRITE_MASK, DISABLE, regptr);
    }
    else
        printf("Invalid register!\r\n");
}

/****************************************************************************/
/**
 * @brief	Change the value of a TARGET register and reads it back
 *
 * @param	regID: register ID
 * @param	regData: new value to set
 *
 * @return	-
 *
 * @note		Result is printed
 *
 ****************************************************************************/
void WriteReadBackRegister(int regID, int regData, int *regptr)
{

    // int* regptr = XPAR_TARGETC_0_TC_AXI_BASEADDR;

    // regptr[TC_CONTROL_REG] = 0;
    ControlRegisterWrite(WRITE_MASK, DISABLE, regptr);

    regptr[regID] = regData;
    regptr[TC_ADDR_REG] = regID;

    ControlRegisterWrite(WRITE_MASK, ENABLE, regptr);
    // regptr[TC_CONTROL_REG] = 1 | RAMP_MASK;

    while (regptr[TC_STATUS_REG] & BUSY_MASK)
    {
        usleep(100000); // sleep 100ms
    }
    ControlRegisterWrite(WRITE_MASK, DISABLE, regptr);


	std::cout
	<< "W:\tReg: 0x"
	<< std::hex << regID << std::dec
	<< "\tData: 0x"
	<< std::hex << regData << std::dec << std::endl;



    // Dummy Write
    ControlRegisterWrite(WRITE_MASK, ENABLE, regptr);
    while (regptr[TC_STATUS_REG] & BUSY_MASK)
    {
        usleep(100000); // sleep 100ms
    }
    ControlRegisterWrite(WRITE_MASK, DISABLE, regptr);

    // xil_printf(">>\tRB:\tReg:%d\tData:%d\r\n",regptr[TC_DATA_OUT_REG]>>12,regptr[TC_DATA_OUT_REG] & 0x00000FFF);
    xil_printf("RB:\t%d\t", regptr[TC_DATA_OUT_REG]);

    std::cout << "0x" << std::hex << regptr[TC_DATA_OUT_REG] << std::dec << std::endl;

}
