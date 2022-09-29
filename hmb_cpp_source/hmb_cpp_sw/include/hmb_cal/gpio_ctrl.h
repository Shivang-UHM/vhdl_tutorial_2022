#ifndef SRC_GPIO_CTRL_H_  /* prevent circular inclusions */
#define SRC_GPIO_CTRL_H_   /* by using protection macros */

#include "xparameters.h"
#include "xil_printf.h"
#include "xgpiops.h"
#include <unistd.h>




/*** Function prototypes *********************************************/
int gpio_toggling(void);
int gpio_init(void);
void gpio_write(int pin, u32 value);
void gpio_set_direction(int pin, u32 direction);
#endif /* SRC_GPIO_CTRL_H_ */
