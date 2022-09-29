/**
 * @file 	iic_DAC_LTC2657.h
 * @author	Anthony Schluchin
 * @date	15th December 2018
 * @version 0.0
 */

#ifndef IIC_DAC_LTC2657_H   /* prevent circular inclusions */
#define IIC_DAC_LTC2657_H   /* by using protection macros */

#include "xparameters.h"
#include "xil_cache.h"
#include "xscugic.h"
#include "xil_printf.h"
#include "xtime_l.h"
//#include "xiicps.h"

//#include "global.h"

/*** DEFINES *********************************************************/
/*********************************************************************/
/** @brief Base address for device I2C (from xparameters.h) */
#define IIC_DEVICE_ID		XPAR_XIICPS_0_DEVICE_ID
/** @brief I2C address of the DAC */
#define IIC_SLAVE_ADDRESS	0x10
/** @brief Channel A register */
#define CHANNEL_A	0x00
/** @brief Channel B register */
#define CHANNEL_B	0x01
/** @brief Channel c register */
#define CHANNEL_C	0x02
/** @brief Channel D register */
#define CHANNEL_D	0x03
/** @brief Channel E register */
#define CHANNEL_E	0x04
/** @brief Channel F register */
#define CHANNEL_F	0x05
/** @brief Channel G register */
#define CHANNEL_G	0x06
/** @brief Channel H register */
#define CHANNEL_H	0x07
/** @brief All channels register */
#define CHANNEL_ALL	0x0F
/** @brief Channel A register */
#define DAC_GRP_0	CHANNEL_A
/** @brief Channel B register */
#define DAC_GRP_1	CHANNEL_B
/** @brief Channel C register */
#define DAC_GRP_2	CHANNEL_C
/** @brief Channel D register */
#define DAC_GRP_3	CHANNEL_D
/** @brief Channel A register */
#define DAC_GRP_4	CHANNEL_E
/** @brief Channel B register */
#define DAC_GRP_5	CHANNEL_F
/** @brief Channel C register */
#define DAC_GRP_6	CHANNEL_G

/** @brief Channel H register */
#define DAC_GRP_7	CHANNEL_H

#define MASK_INFO		0xF
/** @brief Vped value, but in digital (2.5V <=> 2047 -> 1.75V <=> 1434 or 1.25V <=> 1024)*/
#define VPED_DIGITAL	1434
/** @brief Vped voltage to set up in DAC (in float)*/
#define VPED_ANALOG		2.0//1.6 //1.75
/** @brief Threshold voltage to set up in DAC for the comparator of the trigger system (in float)*/
#define THRESHOLD_CMP_0	1.78  //1.78//1.78 //1.25/** @brief Treshold used to select the gain stage in function correct_data to send (digital value)*/

#define THRESHOLD_CMP_1 1.78

#define THRESHOLD_CMP_2	1.78

#define THRESHOLD_CMP_3	1.78

#define THRESHOLD_CMP_4	1.78

#define THRESHOLD_CMP_5	1.78

#define THRESHOLD_CMP_6	1.78

#define THRESHOLD_CMP_7	1.78


#define THRESHOLD_PULSE	500



/*** Function prototypes *********************************************/
//int DAC_LTC2657_initialize();
//int DAC_LTC2657_SetChannelVoltage(int channel, float voltage);
int DAC_LTC2657_initialize_PS(void);
int DAC_LTC2657_SetChannelVoltage_PS(int channel, float voltage);
//void XIicPs_MasterSendNOint(XIicPs *InstancePtr, u8 *MsgPtr, s32 ByteCount,
//		u16 SlaveAddr);
//int iicps_example(void);


#endif

