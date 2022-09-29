#include "/home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/include/hmb_cal/gpio_ctrl.h"

XGpioPs Gpio; /* The driver instance for GPIO Device. */
XGpioPs_Config *ConfigPtr;

int gpio_init(void) {
	xil_printf("gpio_init \r\n");

	int Status;
	//int gpio_pins[5]={11,12,0,13,10};
	//int i;
	int pin_a = 11;
	int pin_b = 12;

	/* Initialize the GPIO driver. */
	ConfigPtr = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_DEVICE_ID);
	Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr, ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XGpioPs_SetDirectionPin(&Gpio, pin_a, 1);
	usleep(10);
	XGpioPs_SetOutputEnablePin(&Gpio, pin_a, 1);
	usleep(10);
	XGpioPs_SetDirectionPin(&Gpio, pin_b, 1);
	usleep(10);
	XGpioPs_SetOutputEnablePin(&Gpio, pin_b, 1);
	usleep(10);
	return XST_SUCCESS;
}

void gpio_write(int pin, u32 value) {
	XGpioPs_WritePin(&Gpio, pin, value);

}

void gpio_set_direction(int pin, u32 direction) {
	XGpioPs_SetDirectionPin(&Gpio, pin, direction);

}

