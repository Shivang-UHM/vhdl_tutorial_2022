#include <iostream>
#include <unistd.h>

#include "hmb_cal/udp_handler.hh"

#include "xparameters.h"
#include "xscuwdt.h"

#include "/home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/include/hmb_cal/I2C_bit_banging.h"
#include "/home1/shivang/github/HMB_CalRDout/hmb_cpp_source/hmb_cpp_sw/include/hmb_cal/gpio_ctrl.h"
#include "iic_DAC_LTC2657.h"

struct register_t121 {
	int addr=0;
	int value=0;
	int response=0;
};

register_t121 get_register( cstring_r data , size_t& offset ){
    auto itt = data.find_first_of("a:", offset);
	auto itt1 = data.find_first_of(' ', itt );
	offset = itt1;

	auto itt2 = data.find_first_of("v:", offset);
	auto itt3 = data.find_first_of('\n', itt2 );
	offset = itt3;

	return {
				std::atoi(data.substr(itt+2, itt1 - itt).c_str()),
				std::atoi(data.substr(itt2+2, itt3 - itt2).c_str()),
				0
			};
}

void setupDACs(void){
	//	/* Initialize the DAC (Vped, Comparator value) */
		if(gpio_init() == XST_SUCCESS) xil_printf("DAC initialization pass!\r\n");
		else{
			std::cout <<  "DAC initialization failed!" << std::endl;
		}

		if(set_DAC_CHANNEL(DAC_GRP_0,THRESHOLD_CMP_0) != XST_SUCCESS){
			std::cout <<  "DAC initialization failed!" << std::endl;
		}
		if(set_DAC_CHANNEL(DAC_GRP_1,THRESHOLD_CMP_1) != XST_SUCCESS){
			std::cout <<  "DAC initialization failed!" << std::endl;
		}
		if(set_DAC_CHANNEL(DAC_GRP_2,THRESHOLD_CMP_2) != XST_SUCCESS){
			std::cout <<  "DAC initialization failed!" << std::endl;
		}
		if(set_DAC_CHANNEL(DAC_GRP_3,THRESHOLD_CMP_3) != XST_SUCCESS){
			std::cout <<  "DAC initialization failed!" << std::endl;
		}
		if(set_DAC_CHANNEL(DAC_GRP_4,THRESHOLD_CMP_4) != XST_SUCCESS){
			std::cout <<  "DAC initialization failed!" << std::endl;
		}
		if(set_DAC_CHANNEL(DAC_GRP_5,THRESHOLD_CMP_5) != XST_SUCCESS){
			std::cout <<  "DAC initialization failed!" << std::endl;

		}
		if(set_DAC_CHANNEL(DAC_GRP_6,THRESHOLD_CMP_6) != XST_SUCCESS){
			std::cout <<  "DAC initialization failed!" << std::endl;

		}
		if(set_DAC_CHANNEL(DAC_GRP_7,THRESHOLD_CMP_7) != XST_SUCCESS){
			std::cout <<  "DAC initialization failed!" << std::endl;

		}
	   usleep(30);
		if(set_DAC_CHANNEL_8574(VPED_ANALOG) != XST_SUCCESS){
			std::cout <<  "DAC initialization failed!" << std::endl;

		}
}


class board_handler {

public:
	void set_register(const register_t121& reg){
		Xil_Out32(XPAR_MY_AXI4_LITE_EXPORTER_0_S00_AXI_BASEADDR, (reg.addr<<16)  + reg.value);
	    usleep(10);
	}
	u32 get_register(int addr) {
		Xil_Out32(XPAR_MY_AXI4_LITE_EXPORTER_0_S00_AXI_BASEADDR +4, addr);
		return Xil_In32( XPAR_MY_AXI4_LITE_EXPORTER_0_S00_AXI_BASEADDR + 8);
	}
	std::string readout_data(){
		std::string ret;
		for (int i =0; i <1025 ;++i){
			auto data_out  =  get_register(i);
			ret += std::to_string(data_out ) + ", ";
		}
		return ret;
	}

};

int main(){

	xil_printf("-------PS Start--------\n\r");
	setupDACs();
	auto myboard_handler = board_handler ();

	auto udp_h = udp_handler(
			{192, 168, 1, 10},

			7,//PORT_DATA,

			[&](udp_handler &arg, cstring_r data )  {
			    std::cout << data << std::endl;
			    size_t i =0;
			    while(i < data.size() ){
				    auto reg = get_register(data , i );
				    if (reg.addr == 1001){
				    	arg.Max_length = reg.value;
				    }else if (reg.addr == 1002){
				    	sleep(reg.value);
				    }
				    myboard_handler.set_register(reg);
				    std::cout << reg.addr << " " << reg.value << std::endl;
			    }

			    std::cout << "end receiver \n";
			    auto data_ro = myboard_handler.readout_data();
			    arg.write(data_ro.substr(0, 8192 ));

			    std::cout <<  data_ro << std::endl;

			}
	);
	udp_h.run();

	return 0;
}

