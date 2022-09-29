#include "/home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/include/hmb_cal/I2C_bit_banging.h"
#include <stdint.h>
#include <stdbool.h>

int gpio_SCL;
int gpio_SDA;

/* Basic I2C functions */
void I2C_SET_SCL(void) {
	gpio_set_direction(gpio_SCL, 0);
	//	gpio_write(gpio_SCL, 1);
}
;

void I2C_CLR_SCL(void) {
	gpio_set_direction(gpio_SCL, 1);
	gpio_write(gpio_SCL, 0);
}
;

void I2C_SET_SDA(void) {
	gpio_set_direction(gpio_SDA, 0);
	//	gpio_write(gpio_SDA, 1);
}
;

void I2C_CLR_SDA(void) {
	gpio_set_direction(gpio_SDA, 1);
	gpio_write(gpio_SDA, 0);
}
;
//
//
void I2C_DELAY(void) {
	usleep(20);
}
;

/* Initiating a start condition */
void _start_condition(void) {
	I2C_SET_SCL();
	I2C_SET_SDA();
	I2C_DELAY();
	I2C_CLR_SDA();
	I2C_DELAY();
	I2C_CLR_SCL();
	I2C_DELAY();
	//    xil_printf("start_condition finished \r\n");
}

/* Initiating a stop condition */
void _stop_condition(void) {
	I2C_CLR_SDA();
	I2C_DELAY();
	I2C_SET_SDA();
	I2C_DELAY();
	I2C_CLR_SDA();
	I2C_DELAY();
	I2C_SET_SCL();
	I2C_DELAY();
	I2C_DELAY();
	I2C_SET_SDA();
}

/* Writing a bit */
void _write_bit(uint8_t b) {
	if (b > 0)
		I2C_SET_SDA();
	else
		I2C_CLR_SDA();

	I2C_DELAY();
	I2C_SET_SCL();
	I2C_DELAY();
	I2C_CLR_SCL();
}

/* Write */

bool _wait_write(void) {
	I2C_DELAY();
	I2C_SET_SCL();
	I2C_DELAY();
	I2C_CLR_SCL();
	return true;

}

/* Acknowledge */

bool _wait_ack(void) {

	I2C_SET_SDA();
	I2C_DELAY();
	I2C_SET_SCL();
	I2C_DELAY();
	I2C_CLR_SCL();
	return true;
}

/* Writing a byte */
bool _write_byte(uint8_t B, bool isSlaveADDRESS, bool start, bool stop) {
	int numBits;
	int msbMask;
	if (isSlaveADDRESS) {
		numBits = 7; //Slave address is 7-bit
		msbMask = 0x40;
	} else {
		numBits = 8; //It is a command or data
		msbMask = 0x80;
	}
	if (start)
		_start_condition();
	uint8_t i;
	for (i = 0; i < numBits; i++) {
		/* Write the most-significant bit */
		_write_bit(B & msbMask);
		B <<= 1;
	}
	if (stop) {
		_wait_ack();
		_stop_condition();
	}
	return true; //Not ack in account
}

/* Sending a byte of data with I2C */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Sends slave address plus write bit, then two consecutive data bytes.
 (The first byte is typically used as a register address, and the second
 as a data byte.)
 Params:
 address = 7-bit slave address
 reg = first byte of data after the slave address
 data = second byte of data after the slave address
 Returns:
 true if slave has ACK'd all three sent bytes
 */
bool i2c_send_byte_data(uint8_t address, uint8_t reg, uint16_t data) {
	uint8_t msbData = data >> 8;
	uint8_t lsbData = data & 0x00FF;
	/* Start, send address */
	if (_write_byte(address, true, true, false)) {
		_wait_write();
		_wait_ack();
		/* Send register */
		if (_write_byte(reg, false, false, false)) {
			_wait_ack();
			/* Send data, stop */
			if (_write_byte(msbData, false, false, false)) {
				_wait_ack();
				if (_write_byte(lsbData, false, false, true)) {
					return true;

				}
			}

		}
	}

	/* Make sure to impose a stop if NAK'd */
	//    _stop_condition();
	return false;
}

int set_DAC_CHANNEL(int channel, float voltage) {
	xil_printf("set channel % \r\n", channel);
	gpio_SCL = 11;
	gpio_SDA = 12;
	//int Status;
	uint16_t intvolt;
	if (voltage >= 2.5)
		intvolt = 65535;
	else
		intvolt = (uint16_t)(65535.0 * voltage / 3.68);
	xil_printf("%f V\r\n", voltage);
	//	_start_condition();

	if (i2c_send_byte_data(IIC_SLAVE_ADDRESS, WRITE_REG | channel, intvolt)) {
		//	if (i2c_send_byte_data(IIC_SLAVE_ADDRESS,0x30|2, intvolt)) {
		return XST_SUCCESS;
	}
	return XST_SUCCESS;

}

int set_DAC_CHANNEL_8574(float voltage) {
	gpio_SCL = 12;
	gpio_SDA = 11;
	//	int Status;
	uint16_t intvolt;
	if (voltage >= 2.5)
		intvolt = 65535;
	else
		intvolt = (uint16_t)(65535.0 * voltage / 2.7);
	xil_printf("%f V\r\n", voltage);
	//	_start_condition();

	if (i2c_send_byte_data(IIC_SLAVE_ADDRESS_8574, 0x20, intvolt)) {
		//	if (i2c_send_byte_data(IIC_SLAVE_ADDRESS,0x30|2, intvolt)) {
		return XST_SUCCESS;
	}
	return XST_SUCCESS;

}

