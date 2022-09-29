
/*
 * c3k_i2cbb.h
 *
 * Copyright 2018  Calvin A. Cherry (calvincherry@gmail.com)
 *                 calcium3000.wordpress.com
 *
 * Description:
 *   This is the header file for the I2C bit-banging tutorial as seen on
 *   calcium3000.wordpress.com.  Provided are three platforms for common
 *   8-bit and 16-bit microcontrollers: Microchip's PIC8 (using MPLABX)
 *   and AVR (using avr-gcc), and Texas Instruments' MSP430 (using
 *   msp430-gcc).  These functions are basic; more and better features are
 *   recommended for the user to pursue.  However, this should be a decent
 *   starting point.
 *
 * Use:
 *   Comment out the first-encountered #defines below except for the platform
 *   of intent.  Within the respective #ifdef block, adjust the appropriate
 *   hardware parameters -- e.g. SCL and SDA bits, input ports, and data/port
 *   direction slash tristate registers.  More libraries and hardware setups
 *   may be needed -- consult your datasheet.
 *
 * Example:
 * uint8_t data = 0xCC, reg = 0x17, slave_addr = 0x44;
 *
 * i2c_init();
 *
 * while( 1 )
 * {
 *     if( i2c_send_byte_data( slave_addr, reg, data ) )
 *     {
 *         PORTA = i2c_receive_byte_data( slave_addr, reg );
 *     }
 *     else
 *     {
 *         PORTA = 0;
 *     }
 *
 *     _delay_ms( 500 );
 * }
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 */


// #define MSP430
// #define AVR

#ifndef SRC_I2C_BIT_BANGING_  /* prevent circular inclusions */
#define SRC_I2C_BIT_BANGING_   /* by using protection macros */

#include <unistd.h>
#include "gpio_ctrl.h"
#include <stdbool.h>
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Initializing I2C with PIC
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#define IIC_SLAVE_ADDRESS	0x10
#define WRITE_REG           0x30
#define IIC_SLAVE_ADDRESS_8574	0x4C

/*  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
Initializes pins for I2C operation.
Params:
    none
Returns:
    none
*/
void i2c_init( void );
bool i2c_send_byte_data( uint8_t, uint8_t, uint16_t );
bool i2c_send_byte_data_8574( uint8_t address, uint8_t reg, uint16_t data );
int set_DAC_CHANNEL(int channel, float voltage );
int set_DAC_CHANNEL_8574( float voltage );
void I2C_SET_SCL(void);
void I2C_CLR_SCL(void);
void I2C_SET_SDA(void);
void I2C_CLR_SDA(void);
void I2C_DELAY(void);
void _start_condition( void );
void _stop_condition( void );
void _write_bit( uint8_t b);
bool _wait_ack(void);
bool _wait_write(void);
//static uint8_t _read_bit( void );
bool _write_byte( uint8_t,bool isSlaveADDRESS, bool, bool );
#endif /* SRC_I2C_BIT_BANGING_ */



