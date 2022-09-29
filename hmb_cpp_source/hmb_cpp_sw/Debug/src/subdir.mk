################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

CXX_SRCS += \
../src/main.cxx 

CC_SRCS += \
../src/TARGETC_RegisterMap.cc \
../src/udp_handler.cc 

C_SRCS += \
../src/I2C_bit_banging.c \
../src/gpio_ctrl.c 

CC_DEPS += \
./src/TARGETC_RegisterMap.d \
./src/udp_handler.d 

OBJS += \
./src/I2C_bit_banging.o \
./src/TARGETC_RegisterMap.o \
./src/gpio_ctrl.o \
./src/main.o \
./src/udp_handler.o 

CXX_DEPS += \
./src/main.d 

C_DEPS += \
./src/I2C_bit_banging.d \
./src/gpio_ctrl.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 g++ compiler'
	arm-none-eabi-g++ -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I/home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_Zynq/export/hmb_Zynq/sw/hmb_Zynq/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 g++ compiler'
	arm-none-eabi-g++ -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I/home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_Zynq/export/hmb_Zynq/sw/hmb_Zynq/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/main.o: ../src/main.cxx
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 g++ compiler'
	arm-none-eabi-g++ -Wall -O0 -g3 -I/home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/include -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I/home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_Zynq/export/hmb_Zynq/sw/hmb_Zynq/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"src/main.d" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


