#include "../include/hmb_cal/my_axi4_lite_exporter.hh"
#include "xscugic.h"

const uint32_t data_read_pointer  = 0;

const uint32_t data_reader_offset = 4;

const uint32_t register_offset = 8;


my_axi4_lite_exporter::my_axi4_lite_exporter( uint32_t Addr_offset ):m_addr_offset(Addr_offset) {

}

void my_axi4_lite_exporter::set_value( uint32_t addr, uint32_t value ){
	Xil_Out32( m_addr_offset + addr, value);
}
uint32_t my_axi4_lite_exporter::get_value(uint32_t addr){
	return Xil_In32( m_addr_offset + addr);
}
uint32_t my_axi4_lite_exporter::read_buffer_at(uint32_t addr){
	set_value(data_read_pointer , addr);
	return get_value(data_reader_offset);
}


void my_axi4_lite_exporter::set_registers(uint32_t addr, uint32_t data ){
	uint32_t reg_val = (addr <<16) + data;
	set_value(register_offset , reg_val);
}


void my_axi4_lite_exporter::reset(){
	set_registers(100, 1);
	set_registers(100, 0);
}

void my_axi4_lite_exporter::done_readout(){
	set_registers(101, 1);
	set_registers(101, 0);
}
