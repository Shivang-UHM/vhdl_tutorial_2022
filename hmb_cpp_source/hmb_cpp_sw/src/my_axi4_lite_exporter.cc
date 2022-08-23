#include "../include/hmb_cal/AXI4lite_to_GPIO.hh"
#include "xscugic.h"

const uint32_t data_read_pointer  = 0;

const uint32_t data_reader_offset = 4;

const uint32_t register_offset = 8;


AXI4lite_to_GPIO::AXI4lite_to_GPIO( uint32_t Addr_offset ):m_addr_offset(Addr_offset) {

}

void AXI4lite_to_GPIO::set_value( uint32_t addr, uint32_t value ){
	Xil_Out32( m_addr_offset + addr, value);
}
uint32_t AXI4lite_to_GPIO::get_value(uint32_t addr){
	return Xil_In32( m_addr_offset + addr);
}
uint32_t AXI4lite_to_GPIO::read_buffer_at(uint32_t addr){
	set_value(data_read_pointer , addr);
	return get_value(data_reader_offset);
}


void AXI4lite_to_GPIO::set_registers(uint32_t addr, uint32_t data ){
	uint32_t reg_val = (addr <<16) + data;
	set_value(register_offset , reg_val);
}


void AXI4lite_to_GPIO::reset(){
	set_registers(100, 1);
	set_registers(100, 0);
}

void AXI4lite_to_GPIO::done_readout(){
	set_registers(101, 1);
	set_registers(101, 0);
}
