#pragma once
#include  <cstdint>


class my_axi4_lite_exporter{
public:
	my_axi4_lite_exporter( uint32_t Addr_offset );

	void set_value( uint32_t addr, uint32_t value );
	uint32_t get_value(uint32_t addr);

	uint32_t read_buffer_at(uint32_t addr);

	void set_registers(uint32_t addr, uint32_t data );

	void reset();
	void done_readout();
private:
	uint32_t m_addr_offset =0;
};

